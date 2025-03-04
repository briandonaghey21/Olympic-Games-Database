SET SCHEMA 'olympicdb';

BEGIN;
    SELECT plan(18);

    -- Function names to be all lowercase to work with pgTAP from what I can tell
    SELECT has_function('createaccount', ARRAY['VARCHAR(30)', 'VARCHAR(30)', 'role_domain', 'TIMESTAMP']);
    SELECT has_function('removeaccount', ARRAY['INTEGER']);
    SELECT has_function('addparticipant', ARRAY['INTEGER', 'VARCHAR(30)', 'VARCHAR(30)', 'VARCHAR(30)', 'CHAR(3)', 'TIMESTAMP', 'gender_domain']);
    SELECT has_function('removeparticipant', ARRAY['INTEGER']);
    SELECT has_function('addteammember', ARRAY['INTEGER', 'INTEGER']);
    SELECT has_function('removeteammember', ARRAY['INTEGER', 'INTEGER']);
    SELECT has_function('registerteam', ARRAY['VARCHAR(30)', 'INTEGER', 'INTEGER', 'CHAR(3)', 'genderteam_domain']);
    SELECT has_function('addevent', ARRAY['VARCHAR(30)', 'VARCHAR(30)', 'INTEGER', 'genderteam_domain', 'TIMESTAMP']);
    SELECT has_function('addteamtoevent', ARRAY['INTEGER', 'INTEGER']);
    SELECT has_function('addeventoutcome', ARRAY['INTEGER', 'INTEGER', 'INTEGER']);
    SELECT has_function('disqualifyteam', ARRAY['INTEGER']);
    SELECT has_function('listvenuesinolympiad', ARRAY['VARCHAR(30)']);
    SELECT has_function('listeventsofolympiad', ARRAY['VARCHAR(30)']);
    SELECT has_function('listteamsinevent', ARRAY['INTEGER']);
    SELECT has_function('showplacementsinevent', ARRAY['INTEGER']);
    SELECT has_function('listparticipantsonteam', ARRAY['INTEGER']);
    SELECT has_function('listcountryplacementsinolympiad', ARRAY['CHAR(3)', 'VARCHAR(30)']);
    SELECT has_function('listathleteplacement', ARRAY['INTEGER']);

    SELECT * FROM finish();
ROLLBACk;