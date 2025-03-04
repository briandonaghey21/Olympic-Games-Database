SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SET CONSTRAINTS FK_TEAM_MEMBERS1 IMMEDIATE;
    SET CONSTRAINTS FK_TEAM_MEMBERS2 IMMEDIATE;

    SELECT plan(4);

    SELECT has_function('addteammember', ARRAY['INTEGER', 'INTEGER']);

    INSERT INTO team VALUES
        (5, '2020', 10, 10, 'RUS', 'M', TRUE);

    INSERT INTO participant VALUES
        (1, 55, 'Sergio', 'Giovanni', 'Kitchens', 'USA', '1993-06-14 00:00:00', 'M'),
        (2, 4, 'Megan', 'Jovon Ruth', 'Pete', 'USA', '1995-02-15', 'F');

    SELECT lives_ok(
        'SELECT * FROM addTeamMember(1, 5)',
        'A valid participant should be added to a valid team without issue'
    );

    SELECT throws_ilike(
        'SELECT * FROM addTeamMember(7, 5)',
        '%failed%due to a foreign key violation',
        'Attempting to a participant that does not exist to a valid team should fail'
    );

    SELECT results_eq(
        'SELECT participant FROM team_members WHERE team = 5',
        ARRAY[1]::INTEGER[],
        'Only valid participants should be added to teams'
    );

    SELECT * FROM finish();
ROLLBACK;