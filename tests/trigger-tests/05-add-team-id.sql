SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addTeamId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT col_is_pk('team', 'team_id');
    SELECT has_trigger('team', 'add_team_id');

    INSERT INTO team VALUES
        (1, '1964', 10, 10, 'GER', 'F', TRUE),
        (2, '1964', 10, 10, 'POL', 'X', FALSE),
        (4, '1964', 10, 10, 'POL', 'X', FALSE);

    PREPARE insert_no_id AS INSERT INTO team (olympiad, sport, coach, country, gender, eligible) VALUES
        ('1602', 10, 10, 'WWW', 'M', TRUE),
        ('1908', 10, 10, 'JPN', 'F', TRUE);

    SELECT lives_ok(
        'insert_no_id',
        'Teams inserted without team_ids should be assigned unique generated ones'
    );

    SELECT * FROM finish();
ROLLBACK;