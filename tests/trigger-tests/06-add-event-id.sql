SET SCHEMA 'olympicdb';
DEALLOCATE PREPARE ALL; -- Deallocate all prepared statements in current session

BEGIN;
    SET CONSTRAINTS ALL DEFERRED; -- Want to avoid having to fulfill FK constraints while testing
    ALTER SEQUENCE IF EXISTS addEventId_sequence RESTART; -- Necessary for consistent behavior
    SELECT plan(3);

    SELECT col_is_pk('event', 'event_id');
    SELECT has_trigger('event', 'add_event_id');

    INSERT INTO event VALUES
        (1, 'Acrisure Stadium', '2028', 10, 'X', CURRENT_TIMESTAMP),
        (3, 'PNC Park', '2028', 10, 'M', CURRENT_TIMESTAMP);

    PREPARE insert_no_id AS INSERT INTO event (venue, olympiad, sport, gender, date) VALUES
        ('PPG Paints Arena', '2028', 10, 'F', CURRENT_TIMESTAMP),
        ('Petersen Events Center', '2028', 10, 'X', CURRENT_TIMESTAMP);

    SELECT lives_ok(
        'insert_no_id',
        'Events inserted without event_ids should be assigned unique generated ones'
    );

    SELECT * FROM finish();
ROLLBACK;