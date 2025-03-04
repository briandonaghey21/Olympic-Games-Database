SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SELECT plan(8);

    SELECT has_domain('genderteam_domain');
    SELECT domain_type_is('genderteam_domain', 'varchar(1)');

    SELECT col_not_null('team', 'gender');

    PREPARE insert_male_team AS INSERT INTO team VALUES
        (4, '2012', 4, 4, 'JPN', 'M', TRUE);

    SELECT lives_ok(
        'insert_male_team',
        'A male team should be added without errors'
    );

    PREPARE insert_female_team AS INSERT INTO team VALUES
        (5, '2012', 5, 5, 'POL', 'F', TRUE);

    SELECT lives_ok(
        'insert_female_team',
        'A female team should be added without errors'
    );

    PREPARE insert_mixed_team AS INSERT INTO team VALUES
        (6, '2018', 6, 6, 'RUS', 'X', FALSE);

    SELECT lives_ok(
        'insert_mixed_team',
        'A mixed team should be added without errors'
    );

    PREPARE insert_blank_team AS INSERT INTO team VALUES
        (7, '2022', 7, 7, 'NGR', '', TRUE);

    SELECT throws_ilike(
        'insert_blank_team',
        '%violates check constraint%',
        'A blank gender team should violate a check constraint'
    );

    PREPARE insert_w_gender_team AS INSERT INTO team VALUES
        (8, '2022', 8, 8, 'NGR', 'W', TRUE);

    SELECT throws_ilike(
        'insert_w_gender_team',
        '%violates check constraint%',
        'A team team with "W" gender should violate a check constraint'
    );

    SELECT * FROM finish();
ROLLBACK;