SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session


-- This test is more specific than I'd like because I had to implement the trigger in a strange way
-- Unlike previous tests, this one won't work for implementations that result in other valid outcomes
BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addParticipantId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(5);

    SELECT col_is_pk('participant', 'participant_id');
    SELECT has_trigger('participant', 'add_participant_id');

    INSERT INTO participant VALUES
        (1, 1, 'Michael', 'Jeffery', 'Jordan', 'USA', '1963-02-17 00:00:00', 'M'),
        (2, 2, 'Kendrick', 'Lamar', 'Duckworth', 'USA', '1987-06-17 00:00:00', 'M'),
        (4, 7, 'Gianmarco', '', 'Tamberi', 'ITA', '1992-06-01 00:00:00', 'M');

    PREPARE insert_no_id AS INSERT INTO participant (account, first, middle, last, birth_country, dob, gender) VALUES
        (1, 'Sha''Carri', '', 'Richardson', 'USA', '2000-03-25 00:00:00', 'F'),
        (7, 'Elmer', 'J', 'Fudd', 'IRL', CURRENT_TIMESTAMP, 'M');

    SELECT lives_ok(
        'insert_no_id',
        'Participants inserted without participant_ids should be assigned unique generated ones'
    );

    PREPARE select_richardson_pid AS
        SELECT participant_id FROM participant WHERE last = 'Richardson';

    SELECT results_eq(
        'select_richardson_pid',
        ARRAY[3],
        'Richardson''s participant_id should end up at 3'
    );

    PREPARE select_fudd_pid AS
        SELECT participant_id FROM participant WHERE last = 'Fudd';

    SELECT results_eq(
        'select_fudd_pid',
        ARRAY[7],
        'Fudd''s participant_id should end up at 7'
    );

    SELECT * FROM finish();
ROLLBACK;