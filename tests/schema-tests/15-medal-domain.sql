SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SELECT plan(9);

    SELECT has_domain('medal_domain');
    SELECT domain_type_is('medal_domain', 'varchar(6)');

    SELECT col_not_null('medal', 'type');
    SELECT col_is_null('placement', 'medal');

    PREPARE insert_gold_medal AS INSERT INTO medal VALUES
        (5, 'Gold', 5);

    SELECT lives_ok(
        'insert_gold_medal',
        'A Gold medal should be added without errors'
    );

    PREPARE insert_silver_medal AS INSERT INTO medal VALUES
        (6, 'Silver', 3);

    SELECT lives_ok(
        'insert_silver_medal',
        'A Silver medal should be added without errors'
    );

    PREPARE insert_bronze_medal AS INSERT INTO medal VALUES
        (7, 'Bronze', 1);

    SELECT lives_ok(
        'insert_bronze_medal',
        'A Bronze medal should be added without errors'
    );

    PREPARE insert_medal_medal AS INSERT INTO medal VALUES
        (8, 'Medal', 100);

    SELECT throws_ilike(
        'insert_medal_medal',
        '%violates check constraint%',
        'A "Medal" medal should violate a check constraint'
    );

    PREPARE insert_blank_medal AS INSERT INTO medal VALUES
        (9, '', 0);

    SELECT throws_ilike(
        'insert_blank_medal',
        '%violates check constraint%',
        'A blank medal should violate a check constraint'
    );

    SELECT * FROM finish();
ROLLBACK;

