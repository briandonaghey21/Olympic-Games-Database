SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(8);

    SELECT has_table('team_members');
    SELECT col_is_pk('team_members', ARRAY['team', 'participant']);

    SELECT col_type_is('team_members', 'team', 'integer');
    SELECT col_type_is('team_members', 'participant', 'integer');

    SELECT fk_ok('team_members', 'team', 'team', 'team_id');
    SELECT fk_ok('team_members', 'participant', 'participant', 'participant_id');

    SELECT col_not_null('team_members', 'team');
    SELECT col_not_null('team_members', 'participant');

    SELECT * FROM finish();
ROLLBACK;