SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(17);

    SELECT has_table('event');
    SELECT col_is_pk('event', 'event_id');

    SELECT col_type_is('event', 'event_id', 'integer');
    SELECT col_type_is('event', 'venue', 'varchar(30)');
    SELECT col_type_is('event', 'olympiad', 'varchar(30)');
    SELECT col_type_is('event', 'sport', 'integer');
    SELECT col_type_is('event', 'gender', 'genderteam_domain');
    SELECT col_type_is('event', 'date', 'timestamp');

    SELECT fk_ok('event', 'venue', 'venue', 'venue_name');
    SELECT fk_ok('event', 'olympiad', 'olympiad', 'olympiad_num');
    SELECT fk_ok('event', 'sport', 'sport', 'sport_id');

    SELECT col_not_null('event', 'event_id');
    SELECT col_not_null('event', 'venue');
    SELECT col_not_null('event', 'olympiad');
    SELECT col_not_null('event', 'sport');
    SELECT col_not_null('event', 'gender');
    SELECT col_not_null('event', 'date');

    SELECT * FROM finish();
ROLLBACK;