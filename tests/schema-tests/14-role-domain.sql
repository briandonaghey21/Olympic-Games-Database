SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SELECT plan(9);

    SELECT has_domain('role_domain');
    SELECT domain_type_is('role_domain', 'varchar(12)');

    SELECT col_not_null('account', 'role');

    PREPARE insert_participant_account AS INSERT INTO account VALUES
        (4, 'usain_bolt', 'irunfast', 'Participant', CURRENT_TIMESTAMP);

    SELECT lives_ok(
        'insert_participant_account',
        'A Participant account should be added without errors'
    );

    PREPARE insert_organizer_account AS INSERT INTO account VALUES
        (5, 'sepp_blatter', 'im_back', 'Organizer', CURRENT_TIMESTAMP);

    SELECT lives_ok(
        'insert_organizer_account',
        'An Organizer account should be added without errors'
    );

    PREPARE insert_guest_account AS INSERT INTO account VALUES
        (6, 'emmanuel_macron', 'idk_anything_about_macron', 'Guest', CURRENT_TIMESTAMP);

    SELECT lives_ok(
        'insert_guest_account',
        'A Guest account should be added without errors'
    );

    PREPARE insert_athlete_account AS INSERT INTO account VALUES
        (7, 'ryan_crouser', 'cool_password', 'Athlete', CURRENT_TIMESTAMP);

    SELECT throws_ilike(
        'insert_athlete_account',
        '%violates check constraint%',
        'An account with the "Athlete" role should violate a check constraint'
    );

    PREPARE insert_coach_account AS INSERT INTO account VALUES
        (8, 'mike_tomlin', 'ilovebadquarterbacks', 'Coach', CURRENT_TIMESTAMP);

    SELECT throws_ilike(
        'insert_coach_account',
        '%violates check constraint%',
        'An account with the "Coach" role should violate a check constraint'
    );

    PREPARE insert_blank_account AS INSERT INTO account VALUES
        (9, 'nobody', 'cool_password_the_sequel', '', CURRENT_TIMESTAMP);

    SELECT throws_ilike(
        'insert_blank_account',
        '%violates check constraint%',
        'An account with the a blank role should violate a check constraint'
    );

    SELECT * FROM finish();
ROLLBACK