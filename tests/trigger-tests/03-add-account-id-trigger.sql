SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addAccountId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT col_is_pk('account', 'account_id');
    SELECT has_trigger('account', 'add_account_id');

    INSERT INTO account VALUES
        (1, 'joe_biden', 'joe', 'Participant', CURRENT_TIMESTAMP),
        (3, 'rudy_gobert', 'basketball', 'Participant', CURRENT_TIMESTAMP);

    PREPARE insert_no_id AS INSERT INTO account(username, passkey, role, last_login) VALUES
        ('hello', 'world', 'Organizer', CURRENT_TIMESTAMP),
        ('sean_lord', 'oof', 'Guest', CURRENT_TIMESTAMP);

    SELECT lives_ok(
        'insert_no_id',
        'Accounts inserted without account_ids should be assigned unique generated ones'
    );

    SELECT * FROM finish();
ROLLBACK;