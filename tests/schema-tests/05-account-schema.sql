SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(12);

    SELECT has_table('account');
    SELECT col_is_pk('account', 'account_id');

    SELECT col_type_is('account', 'account_id', 'integer');
    SELECT col_type_is('account', 'username', 'varchar(30)');
    SELECT col_type_is('account', 'passkey', 'varchar(30)');
    SELECT col_type_is('account', 'role', 'role_domain');
    SELECT col_type_is('account', 'last_login', 'timestamp');

    SELECT col_not_null('account', 'account_id');
    SELECT col_not_null('account', 'username');
    SELECT col_not_null('account', 'passkey');
    SELECT col_not_null('account', 'role');

    SELECT col_is_unique('account', 'username');

    SELECT * FROM finish();
ROLLBACK;