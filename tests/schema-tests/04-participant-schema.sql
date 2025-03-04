SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(17);

    SELECT has_table('participant');
    SELECT col_is_pk('participant', 'participant_id');

    SELECT col_type_is('participant', 'participant_id', 'integer');
    SELECT col_type_is('participant', 'account', 'integer');
    SELECT col_type_is('participant', 'first', 'varchar(30)');
    SELECT col_type_is('participant', 'middle', 'varchar(30)');
    SELECT col_type_is('participant', 'last', 'varchar(30)');
    SELECT col_type_is('participant', 'birth_country', 'char(3)');
    SELECT col_type_is('participant', 'dob', 'timestamp');
    SELECT col_type_is('participant', 'gender', 'gender_domain');

    SELECT fk_ok('participant', 'account', 'account', 'account_id');
    SELECT fk_ok('participant', 'birth_country', 'country', 'country_code');

    SELECT col_not_null('participant', 'participant_id');
    SELECT col_not_null('participant', 'account');
    SELECT col_not_null('participant', 'first');
    SELECT col_not_null('participant', 'last');
    SELECT col_not_null('participant', 'gender');

    SELECT * FROM finish();
ROLLBACK;