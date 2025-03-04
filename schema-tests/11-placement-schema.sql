SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(13);

    SELECT has_table('placement');
    SELECT col_is_pk('placement', ARRAY['event', 'team']);

    SELECT col_type_is('placement', 'event', 'integer');
    SELECT col_type_is('placement', 'team', 'integer');
    SELECT col_type_is('placement', 'medal', 'medal_domain');
    SELECT col_type_is('placement', 'position', 'integer');

    SELECT fk_ok('placement', 'event', 'event', 'event_id');
    SELECT fk_ok('placement', 'team', 'team', 'team_id');
    SELECT fk_ok('placement', 'medal', 'medal', 'type');

    SELECT col_not_null('placement', 'event');
    SELECT col_not_null('placement', 'team');
    SELECT col_is_null('placement', 'medal');
    SELECT col_is_null('placement', 'position');

    SELECT * FROM finish();
ROLLBACK;