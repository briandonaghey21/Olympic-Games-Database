SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addParticipantId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT has_function('addparticipant', ARRAY['INTEGER', 'VARCHAR(30)', 'VARCHAR(30)', 'VARCHAR(30)', 'CHAR(3)', 'TIMESTAMP', 'gender_domain']);

    PREPARE add_participant_new AS
        SELECT * FROM addParticipant(
            10,
            'Sean'::VARCHAR(30),
            'A'::VARCHAR(30),
            'Lord'::VARCHAR(30),
            'USA'::CHAR(3),
            '1970-01-01 00:00:00'::TIMESTAMP,
            'M'::gender_domain
        );

    SELECT lives_ok(
        'add_participant_new',
        'A new participant should be added without errors'
    );

    PREPARE select_sean_name AS
        SELECT first
        FROM participant
        WHERE account = 10;

    SELECT results_eq(
        'select_sean_name',
        ARRAY['Sean']::VARCHAR(30)[],
        'The new participant should be selected without errors'
    );

    SELECT * FROM finish();
ROLLBACK;