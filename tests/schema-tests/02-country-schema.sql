SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(7);

    SELECT has_table('country');
    SELECT col_is_pk('country', 'country_code');

    SELECT col_type_is('country', 'country_code', 'char(3)');
    SELECT col_type_is('country', 'country_name', 'varchar(30)');

    SELECT col_not_null('country', 'country_code');
    SELECT col_not_null('country', 'country_name');

    SELECT col_is_unique('country', 'country_name');

    SELECT * FROM finish();
ROLLBACK;