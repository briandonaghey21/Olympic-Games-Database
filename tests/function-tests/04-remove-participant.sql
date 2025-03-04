SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing

    SELECT plan(4);

    SELECT has_function('removeparticipant', ARRAY['INTEGER']);

    INSERT INTO participant VALUES
        (1, 5, 'Michael', 'Jeffery', 'Jordan', 'USA', '1963-02-17 00:00:00', 'M'),
        (2, 23, 'Kendrick', 'Lamar', 'Duckworth', 'USA', '1987-06-17 00:00:00', 'M');

    PREPARE remove_kendrick AS
        SELECT * FROM removeParticipant(2);

    SELECT lives_ok(
        'remove_kendrick',
        'A participant that exists should be removed without issue'
    );

    SELECT results_eq(
        'SELECT last FROM participant WHERE participant_id = 1',
        ARRAY['Jordan']::VARCHAR(30)[],
        'One participant''s removal should not directly impact others'
    );

    SELECT results_eq(
        'SELECT last FROM participant WHERE participant_id = 2',
        ARRAY[]::VARCHAR(30)[],
        'A participant should not be present after an attempted removal'
    );

    SELECT * FROM finish();
ROLLBACK;