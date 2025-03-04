SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(11);

    SELECT has_table('olympiad');
    SELECT has_table('country');
    SELECT has_table('sport');
    SELECT has_table('participant');
    SELECT has_table('account');
    SELECT has_table('team_members');
    SELECT has_table('team');
    SELECT has_table('event');
    SELECT has_table('venue');
    SELECT has_table('medal');
    SELECT has_table('placement');

    SELECT * FROM finish();
ROLLBACK;