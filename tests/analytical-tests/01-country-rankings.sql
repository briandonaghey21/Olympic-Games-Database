SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing

    SELECT plan(7);

    SELECT has_function('countryrankings', ARRAY[NULL]);

    INSERT INTO country VALUES
        ('USA', 'United States'),
        ('RUS', 'Russia'),
        ('JPN', 'Japan');

    -- Russia should have highest ranking due to most olympiads
    -- USA has more teams, but concentrated in fewer olympiads
    INSERT INTO team VALUES
        (1, '2000', 10, 10, 'JPN', 'M', TRUE),
        (2, '2000', 10, 10, 'RUS', 'X', TRUE),
        (3, '2000', 10, 10, 'USA', 'F', TRUE),
        (4, '2002', 10, 10, 'RUS', 'X', TRUE),
        (5, '2000', 10, 10, 'USA', 'F', TRUE),
        (6, '2002', 10, 10, 'USA', 'X', TRUE),
        (7, '2004', 10, 10, 'RUS', 'F', TRUE),
        (8, '2006', 10, 10, 'RUS', 'X', TRUE),
        (9, '2002', 10, 10, 'USA', 'F', TRUE),
        (0, '2002', 10, 10, 'USA', 'F', TRUE);

    -- In this test, Japan has hosted the most olympiads, but it has participated in the least
    INSERT INTO olympiad VALUES
        ('2000', 'NA1', 'JPN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NA1'),
        ('2002', 'NA2', 'JPN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NA2'),
        ('2004', 'NA3', 'RUS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NA3'),
        ('2006', 'NA4', 'USA', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NA4');

    CREATE OR REPLACE TEMPORARY VIEW test_results AS
        SELECT * FROM countryRankings();

    SELECT * FROM test_results;

    SELECT results_eq(
        'SELECT participationRank FROM test_results WHERE country_code = ''RUS''',
        ARRAY[1]::INTEGER[],
        'Russia should be ranked first'
    );

    SELECT results_eq(
        'SELECT olympiadCount FROM test_results WHERE country_code = ''RUS''',
        ARRAY[4]::INTEGER[],
        'Russia should have four participations'
    );

    SELECT results_eq(
        'SELECT participationRank FROM test_results WHERE country_code = ''USA''',
        ARRAY[2]::INTEGER[],
        'USA should be ranked second'
    );

    SELECT results_eq(
        'SELECT olympiadCount FROM test_results WHERE country_code = ''USA''',
        ARRAY[2]::INTEGER[],
        'USA should have two participations'
    );

    SELECT results_eq(
        'SELECT participationRank FROM test_results WHERE country_code = ''JPN''',
        ARRAY[3]::INTEGER[],
        'Japan should be ranked third'
    );

    SELECT results_eq(
        'SELECT olympiadCount FROM test_results WHERE country_code = ''JPN''',
        ARRAY[1]::INTEGER[],
        'Japan should have one participation'
    );

    SELECT * FROM finish();
ROLLBACK;