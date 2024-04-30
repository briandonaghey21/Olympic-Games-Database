CREATE OR REPLACE FUNCTION countryRankings()
RETURNS TABLE (
    country_code CHAR(3),
    country_name VARCHAR(30),
    olympiadCount INTEGER,
    participationRank INTEGER
)
AS $$
BEGIN
    RETURN QUERY
    SELECT country.country_code, country.country_name, counts.olympiadCount::INTEGER, RANK() OVER (
        ORDER BY counts.olympiadCount DESC
    )::INTEGER AS rank
    FROM (
        SELECT country, COUNT(*) AS olympiadCount
        FROM (
            SELECT DISTINCT olympiad, country
            FROM team
        ) AS distinct_participations
        GROUP BY country
    ) AS counts JOIN country
        ON counts.country = country.country_code;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mostSuccessfulParticipantsInOlympiad(olympiadNumber VARCHAR(30), k INTEGER)
RETURNS TABLE (participantID INT, total_points BIGINT) AS $$
BEGIN
        RETURN QUERY
        SELECT participant AS participantID, SUM(MEDAL.points) AS total_points
        FROM MEDAL JOIN
        (SELECT medal, position, participant FROM
        PLACEMENT JOIN
            (SELECT TEAM_MEMBERS.participant, team_members.team AS teamNum
            FROM TEAM_MEMBERS JOIN
                ( SELECT TEAM.team_id
                  FROM TEAM
                  WHERE olympiadNumber = 'ALL' OR TEAM.olympiad = olympiadNumber
                ) AS teamsInOlympiad ON TEAM_MEMBERS.team = teamsInOlympiad.team_id
             ) AS participantsInOlympiad ON PLACEMENT.team = participantsInOlympiad.teamNum
        ) AS tableWithMedalValues ON MEDAL.type = tableWithMedalValues.medal
        GROUP BY  participant
        ORDER BY total_points DESC
        LIMIT k;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION topSports(x INTEGER, k INTEGER)
RETURNS TABLE (
    sport_id INTEGER,
    sport_name VARCHAR,
    teamCount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT EVENT.sport, SPORT.sport_name, CAST(COUNT(DISTINCT TEAM.team_id) AS INTEGER) AS teamCount
    FROM EVENT
    JOIN SPORT ON SPORT.sport_id = EVENT.sport
    JOIN PLACEMENT ON PLACEMENT.event = EVENT.event_id
    JOIN TEAM ON TEAM.team_id = PLACEMENT.team
    WHERE EVENT.date BETWEEN CURRENT_DATE - INTERVAL '1 year' * x AND CURRENT_DATE
    GROUP BY EVENT.sport, SPORT.sport_name
    ORDER BY teamCount DESC
    LIMIT k;
END;
$$ LANGUAGE plpgsql;

-- Helper function for connectedCoaches
CREATE OR REPLACE FUNCTION oneHop(coach1 INTEGER)
RETURNS TABLE(connected INTEGER) AS
$$
BEGIN
    RETURN QUERY
    WITH coachOlympiad AS
    (
        SELECT coach, olympiad
        FROM team
    )
    SELECT DISTINCT B.coach
    FROM (
        SELECT *
        FROM coachOlympiad
        WHERE coach = coach1
    ) AS A JOIN coachOlympiad AS B
        ON A.olympiad = B.olympiad;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION connectedCoaches(coach1 INT, coach2 INT)
RETURNS TEXT AS $$
DECLARE
    conn_coach INT;
BEGIN
    CREATE OR REPLACE TEMPORARY VIEW coach_olympiads AS
        SELECT DISTINCT coach, olympiad
        FROM team;

    IF EXISTS (
        SELECT *
        FROM oneHop(coach1)
        WHERE connected = coach2
    ) THEN
        RETURN FORMAT('%s -> %s', coach1, coach2);
    END IF;
    SELECT connected INTO conn_coach
    FROM oneHop(coach1) AS A NATURAL JOIN oneHop(coach2) AS B
    LIMIT 1;
    IF conn_coach IS NOT NULL THEN
        RETURN FORMAT('%s -> %s -> %s', coach1, conn_coach, coach2);
    ELSE
        RETURN FORMAT('%s -> no path -> %s', coach1, coach2);
    END IF;
END;
$$ language plpgsql;