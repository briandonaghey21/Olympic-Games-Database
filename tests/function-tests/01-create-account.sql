SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addAccountId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(4);

    SELECT has_function('createaccount', ARRAY['VARCHAR(30)', 'VARCHAR(30)', 'role_domain', 'TIMESTAMP']);

    PREPARE create_account_new AS
        SELECT * FROM createAccount(
            'sean_lord'::VARCHAR(30),
            'beansarecool'::VARCHAR(30),
            'Guest'::role_domain,
            CURRENT_TIMESTAMP::TIMESTAMP
        );

    SELECT lives_ok(
        'create_account_new',
        'A new account with a unique username should be added without errors'
    );

    PREPARE create_same_username AS
        SELECT * FROM createAccount(
        'sean_lord'::VARCHAR(30),
        'itsadifferentpassword'::VARCHAR(30),
        'Participant'::role_domain,
        '1992-02-17 00:00:00'::TIMESTAMP
        );

    SELECT throws_ilike(
        'create_same_username',
        '%violates unique constraint%',
        'A new account with a taken username should violate a unique constraint'
    );

    PREPARE select_sean_password AS
        SELECT passkey
        FROM account
        WHERE username = 'sean_lord';

    SELECT results_eq(
        'select_sean_password',
        ARRAY['beansarecool']::VARCHAR(30)[],
        'The first account should be maintained in case of duplicate usernames'
    );

    SELECT * FROM finish();
ROLLBACK;