SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(4);

    SELECT has_function('countryrankings', ARRAY[NULL]);
    SELECT has_function('mostsuccessfulparticipantsinolympiad', ARRAY['VARCHAR(30)', 'INTEGER']);
    SELECT has_function('topsports', ARRAY['INTEGER', 'INTEGER']);
    SELECT has_function('connectedcoaches', ARRAY['INTEGER', 'INTEGER']);

    SELECT * FROM finish();
ROLLBACK;