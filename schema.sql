    DROP SCHEMA IF EXISTS olympicdb CASCADE;
    CREATE SCHEMA olympicdb;
    SET SCHEMA 'olympicdb';

    DROP TABLE IF EXISTS OLYMPIAD CASCADE;
    DROP TABLE IF EXISTS COUNTRY CASCADE;
    DROP TABLE IF EXISTS SPORT CASCADE;
    DROP TABLE IF EXISTS PARTICIPANT CASCADE;
    DROP TABLE IF EXISTS ACCOUNT CASCADE;
    DROP TABLE IF EXISTS TEAM_MEMBERS CASCADE;
    DROP TABLE IF EXISTS TEAM CASCADE;
    DROP TABLE IF EXISTS EVENT CASCADE;
    DROP TABLE IF EXISTS VENUE CASCADE;
    DROP TABLE IF EXISTS MEDAL CASCADE;
    DROP TABLE IF EXISTS PLACEMENT CASCADE;


    CREATE TABLE COUNTRY (
        country_code    CHAR(3),
        country_name    VARCHAR(30) UNIQUE NOT NULL, -- Alternate key
        CONSTRAINT PK_COUNTRY PRIMARY KEY(country_code)
    );

    CREATE TABLE OLYMPIAD (
        olympiad_num    VARCHAR(30),
        city            VARCHAR(30) NOT NULL,
        country         CHAR(3) NOT NULL,
        opening_date    TIMESTAMP,
        closing_date    TIMESTAMP,
        website         VARCHAR(30) UNIQUE NOT NULL, -- Alternate key
        CONSTRAINT PK_OLYMPIAD PRIMARY KEY(olympiad_num),
        CONSTRAINT FK_OLYMPIAD FOREIGN KEY (country) REFERENCES COUNTRY (country_code)
            DEFERRABLE INITIALLY IMMEDIATE -- Foreign keys are deferrable to enable unit testing
    );


    CREATE TABLE SPORT (
        sport_id        INTEGER,
        sport_name      VARCHAR(30),
        description     VARCHAR(30),
        team_size       INTEGER NOT NULL,
        date_added      TIMESTAMP,
        CONSTRAINT PK_SPORT PRIMARY KEY(sport_id)
    );

    CREATE DOMAIN role_domain AS VARCHAR(12)
    CHECK (VALUE IN ('Organizer', 'Participant', 'Guest'));

    CREATE TABLE ACCOUNT (
        account_id      INTEGER,
        username        VARCHAR(30) UNIQUE NOT NULL,
        passkey         VARCHAR(30) NOT NULL,
        role            role_domain NOT NULL,
        last_login      TIMESTAMP,
        CONSTRAINT PK_ACCOUNT PRIMARY KEY(account_id)
    );

    CREATE DOMAIN gender_domain AS VARCHAR(1)
    CHECK (VALUE IN ('M', 'F'));

    CREATE TABLE PARTICIPANT (
        participant_id    INTEGER,
        account           INTEGER NOT NULL,
        first             VARCHAR(30) NOT NULL,
        middle            VARCHAR(30),
        last              VARCHAR(30) NOT NULL,
        birth_country     CHAR(3), -- Nullable?
        dob               TIMESTAMP, -- Nullable?
        gender            gender_domain NOT NULL,
        CONSTRAINT PK_PARTICIPANT PRIMARY KEY(participant_id),
        CONSTRAINT FK_PARTICIPANT1 FOREIGN KEY (account) REFERENCES ACCOUNT (account_id)
            ON DELETE CASCADE -- Needed for removeAccount()
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_PARTICIPANT2 FOREIGN KEY (birth_country) REFERENCES COUNTRY (country_code)
            DEFERRABLE INITIALLY IMMEDIATE
    );

    CREATE DOMAIN genderteam_domain AS VARCHAR(1)
    CHECK (VALUE IN ('M', 'F','X'));

    CREATE TABLE TEAM (
        team_id         INTEGER,
        olympiad        VARCHAR(30)	NOT NULL,
        sport           INTEGER	NOT NULL,
        coach           INTEGER, -- Nullable?
        country         CHAR(3) NOT NULL,
        gender          genderteam_domain NOT NULL,
        eligible        BOOLEAN NOT NULL DEFAULT TRUE,
        CONSTRAINT PK_TEAM PRIMARY KEY(team_id),
        CONSTRAINT FK_TEAM1 FOREIGN KEY (olympiad) REFERENCES OLYMPIAD (olympiad_num)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_TEAM2 FOREIGN KEY (sport) REFERENCES SPORT (sport_id)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_TEAM3 FOREIGN KEY (country) REFERENCES COUNTRY (country_code)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_TEAM_COACH FOREIGN KEY (coach) REFERENCES PARTICIPANT (participant_id)
            ON DELETE SET NULL -- Best approach I can think of here
            DEFERRABLE INITIALLY IMMEDIATE
        );

    CREATE TABLE TEAM_MEMBERS (
        team           INTEGER,
        participant    INTEGER,
        CONSTRAINT PK_TEAM_MEMBERS PRIMARY KEY(team, participant),
        CONSTRAINT FK_TEAM_MEMBERS1 FOREIGN KEY (team) REFERENCES TEAM (team_id)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_TEAM_MEMBERS2 FOREIGN KEY (participant) REFERENCES PARTICIPANT (participant_id)
            ON DELETE CASCADE -- Needed for removeParticipant()
            DEFERRABLE INITIALLY IMMEDIATE
    );

    CREATE TABLE VENUE (
        venue_name      VARCHAR(30),
        capacity         INTEGER,
        CONSTRAINT PK_VENUE PRIMARY KEY(venue_name)
    );

    CREATE TABLE EVENT (
        event_id    INTEGER,
        venue       VARCHAR(30) NOT NULL,
        olympiad    VARCHAR(30)	NOT NULL,
        sport       INTEGER NOT NULL,
        gender      genderteam_domain NOT NULL,
        date        TIMESTAMP NOT NULL,
        CONSTRAINT PK_EVENT PRIMARY KEY(event_id),
        CONSTRAINT FK_EVENT1 FOREIGN KEY (olympiad) REFERENCES OLYMPIAD (olympiad_num)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_EVENT2 FOREIGN KEY (sport) REFERENCES SPORT (sport_id)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_EVENT3 FOREIGN KEY (venue) REFERENCES VENUE (venue_name)
            DEFERRABLE INITIALLY IMMEDIATE
    );

    CREATE DOMAIN medal_domain AS VARCHAR(6)
    CHECK (VALUE IN ('Gold', 'Silver','Bronze'));

    CREATE TABLE MEDAL (
        medal_id    INTEGER,
        type        medal_domain UNIQUE NOT NULL, -- Alternate key (referenced by placement table)
        points      INTEGER NOT NULL,
        CONSTRAINT PK_MEDAL PRIMARY KEY(medal_id)
    );

    CREATE TABLE PLACEMENT (
        event       INTEGER NOT NULL,
        team        INTEGER NOT NULL,
        medal       medal_domain,
        position    INTEGER,
        CONSTRAINT PK_PLACEMENT PRIMARY KEY(event, team),
        CONSTRAINT FK_PLACEMENT1 FOREIGN KEY (event) REFERENCES EVENT (event_id)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_PLACEMENT2 FOREIGN KEY (team) REFERENCES TEAM (team_id)
            DEFERRABLE INITIALLY IMMEDIATE,
        CONSTRAINT FK_PLACEMENT3 FOREIGN KEY (medal) REFERENCES MEDAL (type)
            DEFERRABLE INITIALLY IMMEDIATE
    );

