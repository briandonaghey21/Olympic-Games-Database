SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SELECT plan(7);

    SELECT has_domain('gender_domain');
    SELECT domain_type_is('gender_domain', 'varchar(1)');

    SELECT col_not_null('participant', 'gender');

    PREPARE insert_male_participant AS INSERT INTO participant VALUES
        (4, 4, 'Nayvadius', 'DeMun', 'Wilburn', 'USA', '1983-11-20 00:00:00', 'M');

    SELECT lives_ok(
        'insert_male_participant',
        'A male participant should be added without errors'
    );

    PREPARE insert_female_participant AS INSERT INTO participant VALUES
        (5, 5, 'Alicia', 'Augello', 'Cook', 'USA', '1989-01-25 00:00:00', 'F');

    SELECT lives_ok(
        'insert_female_participant',
        'A female participant should be added without errors'
    );

    PREPARE insert_blank_gender_participant AS INSERT INTO participant VALUES
        (6, 6, 'A', ' Normal', 'Brick', 'GER', '1912-07-10 00:00:00', '');

    SELECT throws_ilike(
        'insert_blank_gender_participant',
        '%violates check constraint%',
        'A participant with a blank gender should violate a check constraint'
    );

    PREPARE insert_w_gender_participant AS INSERT INTO participant VALUES
        (7, 7, 'Welding Equipment', 'Worn While', 'Watching Eclipse', 'USA', '1972-02-28 00:00:00', 'W');

    SELECT throws_ilike(
        'insert_w_gender_participant',
        '%violates check constraint%',
        'A participant with "W" gender should violate a check constraint'
    );

    SELECT * FROM finish();
ROLLBACK;