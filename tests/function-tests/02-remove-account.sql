SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing

    SELECT plan(4);

    SELECT has_function('removeaccount', ARRAY['INTEGER']);

    INSERT INTO account VALUES
        (1, 'joe_biden', 'joe', 'Participant', CURRENT_TIMESTAMP),
        (3, 'rudy_gobert', 'basketball', 'Participant', CURRENT_TIMESTAMP);

    PREPARE remove_joe AS
        SELECT * FROM removeAccount(1);

    SELECT lives_ok(
        'remove_joe',
        'A present account ID should allow error-free removal'
    );

    SELECT results_eq(
        'SELECT username FROM account WHERE account_id = 1',
        ARRAY[]::VARCHAR(30)[],
        'An account should not be present after an attempted removal'
    );

    SELECT results_eq(
        'SELECT username FROM account WHERE account_id = 3',
        ARRAY['rudy_gobert']::VARCHAR(30)[],
        'An account being removed should not affect other accounts'
    );

    SELECT * FROM finish();
ROLLBACK;