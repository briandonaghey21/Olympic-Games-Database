SET SCHEMA 'olympicdb';

CREATE OR REPLACE FUNCTION createAccount(_username VARCHAR(30), _passkey VARCHAR(30), _role role_domain, _login TIMESTAMP)
RETURNS VOID AS $$
    INSERT INTO account(username, passkey, role, last_login)
        VALUES (_username, _passkey, _role, _login);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION removeAccount(id INT)
RETURNS VOID AS $$
BEGIN
     DELETE FROM ACCOUNT where account_id = id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to delete account with ID %', id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addParticipant(_account INTEGER, _first VARCHAR(30), _middle VARCHAR(30), _last VARCHAR(30), _birth_country CHAR(3), _dob TIMESTAMP, _gender gender_domain)
RETURNS VOID AS $$
    INSERT INTO participant (account, first, middle, last, birth_country, dob, gender)
        VALUES (_account, _first, _middle, _last, _birth_country, _dob, _gender);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION removeParticipant(id INT)
RETURNS VOID AS $$
DECLARE
    accountID INT;
BEGIN
    SELECT ACCOUNT INTO accountID FROM PARTICIPANT WHERE id = participant_id; -- access account
    DELETE FROM PARTICIPANT WHERE id = participant_id;
    DELETE FROM ACCOUNT WHERE account_id = accountID;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to delete participant % and their account %', id, accountID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addTeamMember(participantID INT, teamID INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO TEAM_MEMBERS(team, participant) VALUES (teamID, participantID);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Failed to add % to % due to a foreign key violation', participantID, teamID USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION removeTeamMember(participantID INT, teamID INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM TEAM_MEMBERS WHERE participantID = participant AND teamID = team;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to delete participant % from team %', participantID, teamID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registerTeam(_olympiad VARCHAR(30), _sport INTEGER, _coach INTEGER, _country CHAR(3), _gender genderteam_domain)
RETURNS VOID AS $$
BEGIN
    INSERT INTO team (olympiad, sport, coach, country, gender)
        VALUES (_olympiad, _sport, _coach, _country, _gender);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addEvent(_venue VARCHAR(30), _olympiad VARCHAR(30), _sport INTEGER, _gender genderteam_domain, _date TIMESTAMP)
RETURNS VOID AS $$
BEGIN
    INSERT INTO event (venue, olympiad, sport, gender, date)
        VALUES (_venue, _olympiad, _sport, _gender, _date);
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addTeamToEvent(eventID INT, teamID INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO PLACEMENT(event, team, medal, position) VALUES (eventID, teamID, NULL, NULL);
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to add team % to event %', teamID, eventID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION addEventOutcome(eventID INT, teamID INT, positionID INT)
RETURNS VOID AS $$
BEGIN
    UPDATE PLACEMENT
    SET position = positionID
    WHERE event = eventID AND team = teamID;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to update position of team % in event % to %', teamID, eventID, positionID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION disqualifyTeam(teamID INT)
RETURNS VOID AS $$
BEGIN
    UPDATE TEAM
    SET eligible = FALSE
    WHERE team_id = teamID;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to disqualify team %', teamID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listVenuesInOlympiad(olympiad_num VARCHAR(30))
RETURNS SETOF VENUE AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM VENUE
    WHERE venue_name IN (
        SELECT venue
        FROM EVENT
        WHERE olympiad = olympiad_num
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listEventsOfOlympiad(olympiad_num VARCHAR(30))
RETURNS SETOF EVENT AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM EVENT
    WHERE olympiad = olympiad_num;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listTeamsInEvent(eventID INTEGER)
RETURNS SETOF TEAM AS $$
BEGIN
    RETURN QUERY
        SELECT *
        FROM TEAM
        WHERE team_id IN (
            SELECT team
            FROM PLACEMENT
            WHERE event = eventID
        );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION showPlacementsInEvent(event_id INTEGER)
RETURNS SETOF PLACEMENT AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM PLACEMENT
    WHERE event = event_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION listParticipantsOnTeam(teamID INT)
RETURNS SETOF PARTICIPANT AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM PARTICIPANT
    WHERE participant_id IN (
        SELECT participant
        FROM team_members
        WHERE team = teamID
        UNION
        SELECT coach
        FROM team
        WHERE team_id = teamID
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listCountryPlacementsInOlympiad(country_code CHAR(3), olympiad_num VARCHAR(30))
RETURNS SETOF PLACEMENT AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM PLACEMENT NATURAL JOIN (
        SELECT event_id AS event, team_id AS team
        FROM TEAM NATURAL JOIN EVENT 
        WHERE country = country_code AND olympiad = olympiad_num
    ) as A;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listAthletePlacement(participant_id INTEGER)
RETURNS SETOF PLACEMENT AS $$
BEGIN
RETURN QUERY
    SELECT *
    FROM PLACEMENT
    WHERE team IN (
        SELECT team
        FROM TEAM_MEMBERS
        WHERE participant = participant_id
    );
END;
$$ LANGUAGE plpgsql;
