SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(19);

    SELECT has_table('team');
    SELECT col_is_pk('team', 'team_id');

    SELECT col_type_is('team', 'team_id', 'integer');
    SELECT col_type_is('team', 'olympiad', 'varchar(30)');
    SELECT col_type_is('team', 'sport', 'integer');
    SELECT col_type_is('team', 'coach', 'integer');
    SELECT col_type_is('team', 'country', 'char(3)');
    SELECT col_type_is('team', 'gender', 'genderteam_domain');
    SELECT col_type_is('team', 'eligible', 'boolean');

    SELECT fk_ok('team', 'olympiad', 'olympiad', 'olympiad_num');
    SELECT fk_ok('team', 'country', 'country', 'country_code');
    SELECT fk_ok('team', 'sport', 'sport', 'sport_id');
    SELECT fk_ok('team', 'coach', 'participant', 'participant_id');

    SELECT col_not_null('team', 'team_id');
    SELECT col_not_null('team', 'olympiad');
    SELECT col_not_null('team', 'sport');
    SELECT col_not_null('team', 'country');
    SELECT col_not_null('team', 'gender');
    SELECT col_not_null('team', 'eligible');

    SELECT * FROM finish();
ROLLBACK;