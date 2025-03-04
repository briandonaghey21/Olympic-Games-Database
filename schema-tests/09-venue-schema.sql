SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(5);

    SELECT has_table('venue');
    SELECT col_is_pk('venue', 'venue_name');

    SELECT col_type_is('venue', 'venue_name', 'varchar(30)');
    SELECT col_type_is('venue', 'capacity', 'integer');

    SELECT col_not_null('venue', 'venue_name');

    SELECT * FROM finish();
ROLLBACK;