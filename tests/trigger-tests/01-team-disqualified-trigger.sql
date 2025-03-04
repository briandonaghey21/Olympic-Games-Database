SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SELECT plan(25);

    SELECT has_trigger('team', 'team_disqualified');

    INSERT INTO placement(event, team, position) VALUES
        (1, 1, 1),
        (1, 2, 2),
        (1, 3, 3), -- different team in 3rd across events 1 and 2
        (1, 4, 4),
        (2, 1, 1),
        (2, 2, 2),
        (2, 5, 3), -- different team
        (2, 4, 4);

    INSERT INTO team VALUES
        (5, '2020', 10, 10, 'RUS', 'M', TRUE);

    -- Disqualify team 5 via update
    UPDATE team
    SET eligible = FALSE
    WHERE team_id = 5;

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 1',
        ARRAY[1],
        'Team 1 should maintain position in event 1 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 2',
        ARRAY[2],
        'Team 2 should maintain position in event 1 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 3',
        ARRAY[3],
        'Team 3 should maintain position in event 1 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 4',
        ARRAY[4],
        'Team 4 should maintain position in event 1 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 1',
        ARRAY[1],
        'Team 1 should maintain position in event 2 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 2',
        ARRAY[2],
        'Team 2 should maintain position in event 2 after team 5 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 5',
        ARRAY[-1]::INTEGER[],
        'Team 5 should be in position -1 in event 2 after disqualification'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 4',
        ARRAY[3],
        'Team 4 should move up one spot in event 2 after team 5 is disqualified'
    );

    -- Disqualify team 1 via insert
    INSERT INTO team VALUES
        (1, '2012', 10, 10, 'USA', 'X', FALSE);

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 1',
        ARRAY[-1]::INTEGER[],
        'Team 1 should no be in position -1 in event 1 after disqualification'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 2',
        ARRAY[1],
        'Team 2 should move up one spot in event 1 after team 1 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 3',
        ARRAY[2],
        'Team 3 should move up one spot in event 1 after team 1 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 4',
        ARRAY[3],
        'Team 4 should move up one spot in event 1 after team 1 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 1',
        ARRAY[-1]::INTEGER[],
        'Team 1 should no longer be in position -1 in event 2 after disqualification'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 2',
        ARRAY[1],
        'Team 2 should move up one spot in event 2 after team 1 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 5',
        ARRAY[-1],
        'Team 5 should maintain position -1 in event 2 after team 1 is disqualified'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 4',
        ARRAY[2],
        'Team 4 should move up one spot in event 2 after team 1 is disqualified'
    );

    -- Checking that other updates don't randomly boost that
    UPDATE team
    SET country = 'JPN'
    WHERE team_id = 5;

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 1',
        ARRAY[-1]::INTEGER[],
        'Team 1 should maintain position -1 in event 1 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 2',
        ARRAY[1],
        'Team 12should maintain position 1 in event 1 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 3',
        ARRAY[2],
        'Team 3 should maintain position 2 in event 1 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 1 AND team = 4',
        ARRAY[3],
        'Team 4 should maintain position 3 in event 1 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 1',
        ARRAY[-1]::INTEGER[],
        'Team 1 should maintain position -1 in event 2 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 2',
        ARRAY[1],
        'Team 2 should maintain position 1 in event 2 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 5',
        ARRAY[-1],
        'Team 5 should maintain position -1 in event 2 after update to team 1 country code'
    );

    SELECT results_eq(
        'SELECT position FROM placement WHERE event = 2 AND team = 4',
        ARRAY[2],
        'Team 4 should maintain position 2 in event 2 after update to team 1 country code'
    );

    SELECT * FROM finish();
ROLLBACK;