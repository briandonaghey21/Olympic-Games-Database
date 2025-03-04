INSERT INTO COUNTRY (country_code, country_name)
VALUES ('CHN', 'People''s Republic of China'),
       ('GER', 'Germany'),
       ('ROC', 'Russian Olympic Committee'),
       ('AUT', 'Austria'),
       ('ITA', 'Italy'),
       ('NOR', 'Norway'),
       ('SWE', 'Sweden'),
       ('GBR', 'Great Britain'),
       ('CAN', 'Canada'),
       ('JPN', 'Japan'),
       ('DEN', 'Denmark'),
       ('INA', 'Indonesia'),
       ('GUA', 'Guatemala'),
       ('ESP', 'Spain'),
       ('USA', 'United States of America'),
       ('BRA', 'Brazil');

INSERT INTO OLYMPIAD (olympiad_num, city, country, opening_date, closing_date, website)
VALUES ('XXIV', 'Beijing', 'CHN', '2022-02-04 08:00:00', '2022-02-20 00:00:00',
        'olympics.com/en/beijing-2022'),
       ('XXXII', 'Tokyo', 'JPN', '2021-07-23 00:00:00', '2021-08-08 00:00:00',
        'olympics.com/en/tokyo-2020');

INSERT INTO VENUE (venue_name, capacity)
VALUES ('Yanqing Sliding Centre', 10000),
       ('Guojia Youyong Zhongxin', 17000),
       ('Musashino Forest Plaza', 12000),
       ('Ariake Gymnastics Centre', 12000);

INSERT INTO SPORT (sport_id, sport_name, team_size, date_added, description)
VALUES (1, 'Luge', 1, '2022-02-07 19:44:00',
        'small one- or two-person sled'),
       (2, 'Curling', 3, '1924-02-04 10:00:00',
        'slide stones toward a target'),
       (3, 'Badminton', 1, '1992-07-28 12:00:00',
        'racquet sport'),
       (4, 'Artistic Gymnastics', 1, '1936-08-10 00:00:00',
        'various short routines');

INSERT INTO ACCOUNT (username, passkey, role)
VALUES ('pkc', 'password', 'Organizer'),
       ('btn', 'password', 'Guest'),
       ('ves', 'password', 'Guest');

INSERT INTO MEDAL (medal_id, type, points)
VALUES (1, 'Gold', 5),
       (2, 'Silver', 3),
       (3, 'Bronze', 1);


---------------------------
-- Luge (Singles, Women) --
---------------------------
INSERT INTO ACCOUNT (username, passkey, role)
VALUES ('nat-g', 'password', 'Participant'),
       ('ann-b', 'password', 'Participant'),
       ('jul-t', 'password', 'Participant'),
       ('tat-i', 'password', 'Participant'),
       ('yek-k', 'password', 'Participant'),
       ('mad-e', 'password', 'Participant'),
       ('han-p', 'password', 'Participant'),
       ('lis-s', 'password', 'Participant');

INSERT INTO PARTICIPANT (account, first, middle, last, birth_country, dob, gender)
VALUES (4, 'Natalie', 'l.A', 'Geisenberger', 'GER', '1988-02-05 00:00:00', 'F'),
       (5, 'Anna', 'l.B', 'Berreiter', 'GER', '1999-09-03 00:00:00', 'F'),
       (6, 'Julia', 'lc.AB', 'Taubitz', 'GER', '1996-03-01 00:00:00', 'F'),
       (7, 'Tatyana', 'l.C', 'Ivanovna', 'ROC', '1991-02-16 00:00:00', 'F'),
       (8, 'Yekaterina', 'lc.C', 'Katnikova', 'ROC', '1994-03-22 00:00:00', 'F'),
       (9, 'Madeleine', 'l.D', 'Egle', 'AUT', '1998-08-21 00:00:00', 'F'),
       (10, 'Hannah', 'l.E', 'Prock', 'AUT', '2000-02-02 00:00:00', 'F'),
       (11, 'Lisa', 'lc.DE', 'Schulte', 'AUT', '2000-12-13 00:00:00', 'F');

INSERT INTO TEAM (olympiad, sport, coach, country, gender, eligible)
VALUES ('XXIV', 1, 6, 'GER', 'F', TRUE),
       ('XXIV', 1, 6, 'GER', 'F', TRUE),
       ('XXIV', 1, 8, 'ROC', 'F', TRUE),
       ('XXIV', 1, 11, 'AUT', 'F', TRUE),
       ('XXIV', 1, 11, 'AUT', 'F', TRUE);

INSERT INTO TEAM_MEMBERS (team, participant)
VALUES (1, 4),
       (2, 5),
       (3, 7),
       (4, 9),
       (5, 10);

INSERT INTO EVENT (event_id, venue, olympiad, sport, gender, date)
VALUES (1, 'Yanqing Sliding Centre', 'XXIV', 1, 'F', '2022-02-08 00:00:00');

INSERT INTO PLACEMENT (event, team, position)
VALUES (1, 1, 1),
       (1, 2, 2),
       (1, 3, 3),
       (1, 4, 4),
       (1, 5, 5);


------------------------------
-- Curling (Doubles, Mixed) --
------------------------------
INSERT INTO ACCOUNT (username, passkey, role)
VALUES ('ste-c', 'password', 'Participant'),
       ('amo-m', 'password', 'Participant'),
       ('vio-c', 'password', 'Participant'),
       ('kri-s', 'password', 'Participant'),
       ('mag-n', 'password', 'Participant'),
       ('tho-l', 'password', 'Participant'),
       ('alm-dv', 'password', 'Participant'),
       ('osk-e', 'password', 'Participant'),
       ('seb-k', 'password', 'Participant'),
       ('jen-d', 'password', 'Participant'),
       ('bru-m', 'password', 'Participant'),
       ('gre-d', 'password', 'Participant'),
       ('rac-h', 'password', 'Participant'),
       ('joh-m', 'password', 'Participant'),
       ('sco-p', 'password', 'Participant');

INSERT INTO PARTICIPANT (account, first, middle, last, birth_country, dob, gender)
VALUES (12, 'Stefania', 'c.A', 'Constantini', 'ITA', '1999-04-15 00:00:00', 'F'),
       (13, 'Amos', 'c.A', 'Mosaner', 'ITA', '1995-03-12 00:00:00', 'M'),
       (14, 'Violetta', 'cc.A', 'Caldart', 'ITA', '1969-10-10 00:00:00', 'F'),
       (15, 'Kristin', 'c.B', 'Skaslien', 'NOR', '1986-01-18 00:00:00', 'F'),
       (16, 'Magnus', 'c.B', 'Nedregotten', 'NOR', '1990-10-24 00:00:00', 'M'),
       (17, 'Thomas', 'cc.B', 'Løvold', 'NOR', '1982-01-27 00:00:00', 'M'),
       (18, 'Almida', 'c.C', 'de Val', 'SWE', '1997-09-12 00:00:00', 'F'),
       (19, 'Oskar', 'c.C', 'Eriksson', 'SWE', '1991-05-29 00:00:00', 'M'),
       (20, 'Sebastian', 'cc.C', 'Kraupp', 'SWE', '1985-05-20 00:00:00', 'M'),
       (21, 'Jenn', 'c.D', 'Dodds', 'GBR', '1991-10-01 00:00:00', 'F'),
       (22, 'Bruce', 'c.D', 'Mouat', 'GBR', '1994-08-27 00:00:00', 'M'),
       (23, 'Greg', 'cc.D', 'Drummond', 'GBR', '1989-02-03 00:00:00', 'M'),
       (24, 'Rachel', 'c.E', 'Homan', 'CAN', '1989-04-05 00:00:00', 'F'),
       (25, 'John', 'c.E', 'Morris', 'CAN', '1978-12-16 00:00:00', 'M'),
       (26, 'Scott', 'cc.E', 'Pfeifer', 'CAN', '1977-01-05 00:00:00', 'M');

INSERT INTO TEAM (olympiad, sport, coach, country, gender, eligible)
VALUES ('XXIV', 2, 14, 'ITA', 'X', TRUE),
       ('XXIV', 2, 17, 'NOR', 'X', TRUE),
       ('XXIV', 2, 20, 'SWE', 'X', TRUE),
       ('XXIV', 2, 23, 'GBR', 'X', TRUE),
       ('XXIV', 2, 26, 'CAN', 'X', TRUE);

INSERT INTO TEAM_MEMBERS (team, participant)
VALUES (6, 12),
       (6, 13),
       (7, 15),
       (7, 16),
       (8, 18),
       (8, 19),
       (9, 21),
       (9, 22),
       (10, 24),
       (10, 25);

INSERT INTO EVENT (event_id, venue, olympiad, sport, gender, date)
VALUES (2, 'Guojia Youyong Zhongxin', 'XXIV', 2, 'X', '2022-02-08 00:00:00');

INSERT INTO PLACEMENT (event, team, position)
VALUES (2, 6, 1),
       (2, 7, 2),
       (2, 8, 3),
       (2, 9, 4),
       (2, 10, 5);


------------------------------
-- Badminton (Singles, Men) --
------------------------------
INSERT INTO ACCOUNT (username, passkey, role)
VALUES ('vik-a', 'password', 'Participant'),
       ('and-a', 'password', 'Participant'),
       ('che-l', 'password', 'Participant'),
       ('shi-y', 'password', 'Participant'),
       ('ant-g', 'password', 'Participant'),
       ('leo-c', 'password', 'Participant'),
       ('kev-c', 'password', 'Participant'),
       ('pab-a', 'password', 'Participant');

INSERT INTO PARTICIPANT (account, first, middle, last, birth_country, dob, gender)
VALUES (27, 'Viktor', 'c.A', 'Axelsen', 'DEN', '1994-01-04 00:00:00', 'M'),
       (28, 'Anders', 'cc.A', 'Antonsen', 'DEN', '1997-04-27 00:00:00', 'M'),
       (29, 'Chen', 'c.B', 'Long', 'CHN', '1989-01-18 00:00:00', 'M'),
       (30, 'Shi', 'cc.B', 'Yuqi', 'CHN', '1996-02-28 00:00:00', 'M'),
       (31, 'Anthony', 'c.C', 'Ginting', 'INA', '1996-10-20 00:00:00', 'M'),
       (32, 'Leonardus', 'cc.C', 'Christie', 'INA', '1997-09-15 00:00:00', 'M'),
       (33, 'Kevin', 'c.D', 'Cordon', 'GUA', '1986-11-28 00:00:00', 'M'),
       (34, 'Pablo', 'cc.D', 'Abián', 'ESP', '12 June 1985', 'M');

INSERT INTO TEAM (olympiad, sport, coach, country, gender, eligible)
VALUES ('XXXII', 3, 28, 'DEN', 'M', TRUE),
       ('XXXII', 3, 30, 'CHN', 'M', TRUE),
       ('XXXII', 3, 32, 'INA', 'M', TRUE),
       ('XXXII', 3, 34, 'GUA', 'M', TRUE);

INSERT INTO TEAM_MEMBERS (team, participant)
VALUES (11, 27),
       (12, 29),
       (13, 31),
       (14, 33);

INSERT INTO EVENT (event_id, venue, olympiad, sport, gender, date)
VALUES (3, 'Musashino Forest Plaza', 'XXXII', 3, 'M', '2021-07-24 00:00:00');

INSERT INTO PLACEMENT (event, team, position)
VALUES (3, 11, 1),
       (3, 12, 2),
       (3, 13, 3),
       (3, 14, 4);


--------------------------------------------------------
-- Artistic Gymnastics (Individual All-Around, Women) --
--------------------------------------------------------
INSERT INTO ACCOUNT (username, passkey, role)
VALUES ('sun-l', 'password', 'Participant'),
       ('jad-c', 'password', 'Participant'),
       ('reb-a', 'password', 'Participant'),
       ('fla-s', 'password', 'Participant'),
       ('ang-m', 'password', 'Participant'),
       ('vik-l', 'password', 'Participant'),
       ('vla-u', 'password', 'Participant'),
       ('lil-a', 'password', 'Participant'),
       ('mai-m', 'password', 'Participant'),
       ('hit-h', 'password', 'Participant');

INSERT INTO PARTICIPANT (account, first, middle, last, birth_country, dob, gender)
VALUES (35, 'Suni', 'c.A', 'Lee', 'USA', '2003-03-09 00:00:00', 'F'),
       (36, 'Jade', 'cc.A', 'Carey', 'USA', '2000-05-27 00:00:00', 'F'),
       (37, 'Rebeca', 'c.B', 'Andrade', 'BRA', '1999-05-08 00:00:00', 'F'),
       (38, 'Flávia', 'cc.B', 'Saraiva', 'BRA', '1999-09-30 00:00:00', 'F'),
       (39, 'Angelina', 'c.C', 'Melnikova', 'ROC', '2000-07-18 00:00:00', 'F'),
       (40, 'Viktoriya', 'cc.C', 'Listunova', 'ROC', '2005-05-12 00:00:00', 'F'),
       (41, 'Vladislava', 'c.D', 'Urazova', 'ROC', '2004-08-14 00:00:00', 'F'),
       (42, 'Liliya', 'cc.D', 'Akhaimova', 'ROC', '1997-03-17 00:00:00', 'F'),
       (43, 'Mai', 'c.E', 'Murakami', 'JPN', '1996-08-05 00:00:00', 'F'),
       (44, 'Hitomi', 'cc.E', 'Hatakeda', 'JPN', '2000-09-01 00:00:00', 'F');

INSERT INTO TEAM (olympiad, sport, coach, country, gender, eligible)
VALUES ('XXXII', 4, 36, 'USA', 'F', TRUE),
       ('XXXII', 4, 38, 'BRA', 'F', TRUE),
       ('XXXII', 4, 40, 'ROC', 'F', TRUE),
       ('XXXII', 4, 42, 'ROC', 'F', TRUE),
       ('XXXII', 4, 44, 'JPN', 'F', TRUE);

INSERT INTO TEAM_MEMBERS (team, participant)
VALUES (15, 35),
       (16, 37),
       (17, 39),
       (18, 41),
       (19, 43);

INSERT INTO EVENT (event_id, venue, olympiad, sport, gender, date)
VALUES (4, 'Ariake Gymnastics Centre', 'XXXII', 4, 'F', '2021-07-25 00:00:00');

INSERT INTO PLACEMENT (event, team, position)
VALUES (4, 15, 1),
       (4, 16, 2),
       (4, 17, 3),
       (4, 18, 4),
       (4, 19, 5);
