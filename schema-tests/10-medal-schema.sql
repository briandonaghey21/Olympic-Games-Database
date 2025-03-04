SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(8);

    SELECT has_table('medal');
    SELECT col_is_pk('medal', 'medal_id');

    SELECT col_type_is('medal', 'medal_id', 'integer');
    SELECT col_type_is('medal', 'type', 'medal_domain');
    SELECT col_type_is('medal', 'points', 'integer');

    SELECT col_not_null('medal', 'medal_id');
    SELECT col_not_null('medal', 'type');
    SELECT col_not_null('medal', 'points');

    SELECT * FROM finish();
ROLLBACK;