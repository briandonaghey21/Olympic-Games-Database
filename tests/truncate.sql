SET SCHEMA 'olympicdb';

-- Run this file if you want to reset table to have original sample data
-- Slightly easier than re-running dropping schema and whatnot
-- You still have the sample data SQL file after

-- This block removes all entries from all tables
TRUNCATE TABLE venue CASCADE;
TRUNCATE TABLE medal CASCADE;
TRUNCATE TABLE team_members CASCADE;
TRUNCATE TABLE team CASCADE;
TRUNCATE TABLE account CASCADE;
TRUNCATE TABLE participant CASCADE;
TRUNCATE TABLE event CASCADE;
TRUNCATE TABLE placement CASCADE;
TRUNCATE TABLE sport CASCADE;
TRUNCATE TABLE olympiad CASCADE;
TRUNCATE TABLE country CASCADE;

-- This block resets sequences which is an issue with sample data
ALTER SEQUENCE addAccountId_sequence RESTART;
ALTER SEQUENCE addParticipantId_sequence RESTART;
ALTER SEQUENCE addTeamId_sequence RESTART;
ALTER SEQUENCE addEventId_sequence RESTART;

