SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SELECT plan(9);

    SELECT has_trigger('placement', 'assign_medal');

    INSERT INTO placement(event, team, position) VALUES
        (2, 2, 1),
        (4, 4, 2),
        (6, 6, 3),
        (8, 8, 4);

    PREPARE select_placement_first AS
        SELECT medal
        FROM placement
        WHERE event = 2 AND team = 2;

    SELECT results_eq(
        'select_placement_first',
        ARRAY['Gold']::medal_domain[],
        'A first place finish should receive a Gold medal'
    );

    PREPARE select_placement_second AS
        SELECT medal
        FROM placement
        WHERE event = 4 AND team = 4;

    SELECT results_eq(
        'select_placement_second',
        ARRAY['Silver']::medal_domain[],
        'A second place finish should receive a Silver medal'
    );

    PREPARE select_placement_third AS
        SELECT medal
        FROM placement
        WHERE event = 6 AND team = 6;

    SELECT results_eq(
        'select_placement_third',
        ARRAY['Bronze']::medal_domain[],
        'A third place finish should receive a Bronze medal'
    );

    PREPARE select_placement_fourth AS
        SELECT medal
        FROM placement
        WHERE event = 8 AND team = 8;

    SELECT results_eq(
        'select_placement_fourth',
        ARRAY[NULL]::medal_domain[],
        'A fourth place finish should receive no medal'
    );

    UPDATE placement
    SET position = 1
    WHERE event = 4 and team = 4;

    UPDATE placement
    SET position = 2
    WHERE event = 6 and team = 6;

    UPDATE placement
    SET position = 3
    WHERE event = 8 and team = 8;

    UPDATE placement
    SET position = 4
    WHERE event = 2 and team = 2;

    PREPARE select_new_first AS
        SELECT medal
        FROM placement
        WHERE event = 4 AND team = 4;

    SELECT results_eq(
        'select_new_first',
        ARRAY['Gold']::medal_domain[],
        'An update to a first place finish should receive a Gold medal'
    );

    PREPARE select_new_second AS
        SELECT medal
        FROM placement
        WHERE event = 6 AND team = 6;

    SELECT results_eq(
        'select_new_second',
        ARRAY['Silver']::medal_domain[],
        'An update to a second place finish should receive a Silver medal'
    );

    PREPARE select_new_third AS
        SELECT medal
        FROM placement
        WHERE event = 8 AND team = 8;

    SELECT results_eq(
        'select_new_third',
        ARRAY['Bronze']::medal_domain[],
        'An update to a third place finish should receive a Bronze medal'
    );

    PREPARE select_new_fourth AS
        SELECT medal
        FROM placement
        WHERE event = 2 AND team = 2;

    SELECT results_eq(
        'select_new_fourth',
        ARRAY[NULL]::medal_domain[],
        'An update to a fourth place finish should receive no medal'
    );

    SELECT * FROM finish();
ROLLBACK;