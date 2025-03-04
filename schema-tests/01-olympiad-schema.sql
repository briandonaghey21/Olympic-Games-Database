SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(13);

    SELECT has_table('olympiad');
    SELECT col_is_pk('olympiad', 'olympiad_num');

    SELECT col_type_is('olympiad', 'olympiad_num', 'varchar(30)');
    SELECT col_type_is('olympiad', 'city', 'varchar(30)');
    SELECT col_type_is('olympiad', 'country', 'char(3)');
    SELECT col_type_is('olympiad', 'opening_date', 'timestamp');
    SELECT col_type_is('olympiad', 'closing_date', 'timestamp');
    SELECT col_type_is('olympiad', 'website', 'varchar(30)');

    SELECT fk_ok('olympiad', 'country', 'country', 'country_code');

    SELECT col_not_null('olympiad', 'olympiad_num');
    SELECT col_not_null('olympiad', 'country');
    SELECT col_not_null('olympiad', 'website');

    SELECT col_is_unique('olympiad', 'website');

    SELECT * FROM finish();
ROLLBACK;