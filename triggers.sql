SET SCHEMA 'olympicdb';

CREATE OR REPLACE FUNCTION assignMedal()
RETURNS TRIGGER AS $$
BEGIN
    CASE
        WHEN NEW.position = '1' THEN
             NEW.medal = 'Gold';
        WHEN NEW.position = '2' THEN
             NEW.medal = 'Silver';
        WHEN NEW.position = '3' THEN
             NEW.medal = 'Bronze';
        ELSE
             NEW.medal = NULL;
    END CASE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_medal
BEFORE INSERT OR UPDATE ON PLACEMENT
FOR EACH ROW
EXECUTE FUNCTION assignMedal();



-- For some reason, disqualified team's position is set to -1 in event. This makes for pain.
-- I set up good number of tests for this, but there could very well still be a bug somewhere.
CREATE OR REPLACE FUNCTION teamDisqualified()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.eligible = FALSE AND (TG_OP = 'INSERT' OR OLD.eligible = TRUE) THEN -- TG_OP is trigger operation
        UPDATE placement AS A
        SET position = A.position - 1
        FROM ( -- Disqualified team's positions in each event they competed in
            SELECT B.event, B.position
            FROM placement AS B
            WHERE B.team = NEW.team_id
        ) AS C
        WHERE A.event = C.event AND A.position > C.position; -- Disqualified team has better position
        UPDATE placement -- Set position to -1 because its in the function requirements
        SET position = -1
        WHERE team = NEW.team_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER team_disqualified
AFTER INSERT OR UPDATE ON team
FOR EACH ROW
EXECUTE FUNCTION teamDisqualified();



-- Gonna assume we don't have to deal with updates to team or participant gender
CREATE OR REPLACE FUNCTION checkTeamGender()
RETURNS TRIGGER AS $$
DECLARE
    participant_gender gender_domain;
    team_gender genderteam_domain;
BEGIN
    SELECT gender INTO participant_gender FROM PARTICIPANT WHERE participant_id = NEW.participant;
    SELECT gender INTO team_gender FROM TEAM WHERE team_id = NEW.team;
    IF (team_gender = 'M' AND participant_gender != 'M') OR  (team_gender = 'F' AND participant_gender != 'F') THEN
        RAISE EXCEPTION 'Participant % and team % have mismatching genders', NEW.participant, NEW.team;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_team_gender ON team_members; -- Constraint trigger cannot be replaced

CREATE CONSTRAINT TRIGGER check_team_gender -- Figured I'd make this a constraint trigger for semantics
AFTER INSERT OR UPDATE ON team_members
FOR EACH ROW
EXECUTE FUNCTION checkTeamGender();



DROP SEQUENCE IF EXISTS addAccountId_sequence;
CREATE SEQUENCE addAccountId_sequence;

-- Still using sequence but need to handle case when next value is taken
CREATE OR REPLACE FUNCTION addAccountId()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.account_id IS NULL THEN
        LOOP
            NEW.account_id = nextval('addAccountId_sequence');
            IF NOT EXISTS (
                SELECT account_id
                FROM account as A
                WHERE A.account_id = NEW.account_id
            ) THEN
                EXIT;
            END IF;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_account_id
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
EXECUTE FUNCTION addAccountId();



DROP SEQUENCE IF EXISTS addParticipantId_sequence;
CREATE SEQUENCE addParticipantId_sequence;

-- I had to make this kind of weird to work with the sample data
-- For participants created without supplying a participant_id:
    -- If the 'account' is available as a 'participant_id':
        -- Inherit 'account' as 'participant_id'
    -- Otherwise:
        -- Use addParticipant_sequence to create a new sequenced value for 'participant_id'
-- I have no idea what the sample data was going for, but this should work for it
CREATE OR REPLACE FUNCTION addParticipantId()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.participant_id IS NULL THEN
        IF EXISTS ( -- If another participant has our account_id as participant_id
            SELECT participant_id
            FROM participant
            WHERE participant_id = NEW.account
        ) THEN -- Get the next available participant_id
            LOOP
                NEW.participant_id = nextval('addParticipantId_sequence');
                IF NOT EXISTS (
                    SELECT participant_id
                    FROM participant as A
                    WHERE A.participant_id = NEW.participant_id
                ) THEN
                    EXIT;
                END IF;
            END LOOP;
        ELSE
            NEW.participant_id = NEW.account; -- Set participant_id to account id
            -- Note that this may cause misleading errors if account is NULL
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_participant_id
BEFORE INSERT ON participant
FOR EACH ROW
EXECUTE FUNCTION addParticipantId();



DROP SEQUENCE IF EXISTS addTeamId_sequence;
CREATE SEQUENCE addTeamId_sequence;

CREATE OR REPLACE FUNCTION addTeamId()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.team_id IS NULL THEN
        LOOP
            NEW.team_id = nextval('addTeamId_sequence');
            IF NOT EXISTS (
                SELECT team_id
                FROM team as A
                WHERE A.team_id = NEW.team_id
            ) THEN
                EXIT;
            END IF;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_team_id
BEFORE INSERT ON TEAM
FOR EACH ROW
EXECUTE FUNCTION addTeamId();



DROP SEQUENCE IF EXISTS addEventId_sequence;
CREATE SEQUENCE addEventId_sequence;

CREATE OR REPLACE FUNCTION addEventId()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.event_id IS NULL THEN
        LOOP
            NEW.event_id = nextval('addEventId_sequence');
            IF NOT EXISTS (
                SELECT event_id
                FROM event as A
                WHERE A.event_id = NEW.event_id
            ) THEN
                EXIT;
            END IF;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_event_id
BEFORE INSERT ON event
FOR EACH ROW
EXECUTE FUNCTION addEventId();
