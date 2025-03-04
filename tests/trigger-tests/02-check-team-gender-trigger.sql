SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    SELECT plan(9);

    SELECT has_trigger('team_members', 'check_team_gender');

    INSERT INTO team VALUES
        (1, '2024', 10, 10, 'USA', 'M', TRUE),
        (2, '2024', 10, 10, 'USA', 'X', TRUE),
        (3, '2024', 10, 10, 'USA', 'F', TRUE);

    INSERT INTO participant VALUES
        (1, 1, 'Sergio', 'Giovanni', 'Kitchens', 'USA', '1993-06-14 00:00:00', 'M'),
        (2, 2, 'Megan', 'Jovon Ruth', 'Pete', 'USA', '1995-02-15', 'F');

    PREPARE insert_male_male AS INSERT INTO team_members(team, participant) VALUES
        (1, 1);

    SELECT lives_ok(
        'insert_male_male',
        'A male participant should be added to a male team without errors'
    );

    PREPARE insert_male_mixed AS INSERT INTO team_members(team, participant) VALUES
        (2, 1);

    SELECT lives_ok(
        'insert_male_mixed',
        'A male participant should be added to a mixed team without errors'
    );

    PREPARE insert_male_female AS INSERT INTO team_members(team, participant) VALUES
        (3, 1);

    SELECT throws_ilike(
        'insert_male_female',
        '%mismatching genders%',
        'A male participant cannot be added to a female team'
    );

    PREPARE insert_female_male AS INSERT INTO team_members(team, participant) VALUES
        (1, 2);

    SELECT throws_ilike(
        'insert_female_male',
        '%mismatching genders%',
        'A female participant cannot be added to a male team'
    );

    PREPARE insert_female_mixed AS INSERT INTO team_members(team, participant) VALUES
        (2, 2);

    SELECT lives_ok(
        'insert_female_mixed',
        'A female participant should be added to a mixed team without errors'
    );

    PREPARE insert_female_female AS INSERT INTO team_members(team, participant) VALUES
        (3, 2);

    SELECT lives_ok(
        'insert_female_female',
        'A female participant should be added to a female team without errors'
    );

    PREPARE update_male_female AS
        UPDATE team_members
        SET team = 3
        WHERE team = 1 and participant = 1;

    SELECT throws_ilike(
        'update_male_female',
        '%mismatching genders%',
        'Team_members should not be updatable to have a male participant on a female team.'
    );

    PREPARE update_female_male AS
        UPDATE team_members
        SET team = 1
        WHERE team = 3 and participant = 2;

    SELECT throws_ilike(
        'update_female_male',
        '%mismatching genders%',
        'Team_members should not be updatable to have a female participant on a male team.'
    );

    SELECT * FROM finish();
ROLLBACK;