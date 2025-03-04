SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(9);

    SELECT has_table('sport');
    SELECT col_is_pk('sport', 'sport_id');

    SELECT col_type_is('sport', 'sport_id', 'integer');
    SELECT col_type_is('sport', 'sport_name', 'varchar(30)');
    SELECT col_type_is('sport', 'description', 'varchar(30)');
    SELECT col_type_is('sport', 'team_size', 'integer');
    SELECT col_type_is('sport', 'date_added', 'timestamp');

    SELECT col_not_null('sport', 'sport_id');
    SELECT col_not_null('sport', 'team_size');

    SELECT * FROM finish();
ROLLBACK;