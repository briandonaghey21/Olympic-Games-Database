SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addTeamId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT has_function('addevent', ARRAY['VARCHAR(30)', 'VARCHAR(30)', 'INTEGER', 'genderteam_domain', 'TIMESTAMP']);

    PREPARE add_event_new AS
        SELECT * FROM addEvent(
            'Acrisure Stadium'::VARCHAR(30),
            '2020'::VARCHAR(30),
            10,
             'X'::genderteam_domain,
             CURRENT_TIMESTAMP::TIMESTAMP
        );

    SELECT lives_ok(
        'add_event_new',
        'A new event should be added without errors'
    );

    PREPARE select_event_count AS
        SELECT COUNT(*)::INTEGER
        FROM event
        WHERE sport = 10;

    SELECT results_eq(
        'select_event_count',
        ARRAY[1],
        'There should be one event after a single event is added'
    );


    SELECT * FROM finish();
ROLLBACK;