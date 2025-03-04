SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addTeamId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT has_function('registerteam', ARRAY['VARCHAR(30)', 'INTEGER', 'INTEGER', 'CHAR(3)', 'genderteam_domain']);

    PREPARE add_team_new AS
        SELECT * FROM registerTeam(
            '2020'::VARCHAR(30),
            10,
             10,
            'USA'::CHAR(3),
            'X'::genderteam_domain
        );

    SELECT lives_ok(
        'add_team_new',
        'A new team should be added without errors'
    );

    PREPARE select_team_count AS
        SELECT COUNT(*)::INTEGER
        FROM team
        WHERE sport = 10;

    SELECT results_eq(
        'select_team_count',
        ARRAY[1],
        'There should be one team after a single team is added'
    );

    SELECT * FROM finish();
ROLLBACK;