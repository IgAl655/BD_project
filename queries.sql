--Таблицы
CREATE TABLE lfl_teams(
	id_team SERIAL PRIMARY KEY ,
	team_name VARCHAR(64) NOT NULL UNIQUE,
	competition_level INT NOT NULL DEFAULT 1
);

--CREATE TABLE first_league(
	id_team INT REFERENCES lfl_teams(id_team),
	team_name VARCHAR(64) NOT NULL,
	games_played INT NOT NULL DEFAULT 0,
	wins INT NOT NULL CHECK (wins >= 0) DEFAULT 0,
	draws INT NOT NULL CHECK (draws >= 0) DEFAULT 0,
	loses INT NOT NULL CHECK (loses >= 0) DEFAULT 0,
	points INT NOT NULL CHECK (points >= 0) DEFAULT 0,
	CONSTRAINT check_game_counts CHECK (wins + draws + loses = games_played)
);

--CREATE TABLE second_league(
	id_team INT REFERENCES lfl_teams(id_team),
	team_name VARCHAR(64) NOT NULL,
	games_played INT NOT NULL DEFAULT 0,
	wins INT NOT NULL CHECK (wins >= 0) DEFAULT 0,
	draws INT NOT NULL CHECK (draws >= 0) DEFAULT 0,
	loses INT NOT NULL CHECK (loses >= 0) DEFAULT 0,
	points INT NOT NULL CHECK (points >= 0) DEFAULT 0,
	CONSTRAINT check_game_counts CHECK (wins + draws + loses = games_played)
);

--CREATE TABLE team_owners(
	team_name VARCHAR(64) REFERENCES lfl_teams(team_name),
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL,
	patronymic VARCHAR(64) NULL,
	phone VARCHAR(60) NOT NULL,
	mail VARCHAR(60) NULL
);

--CREATE TABLE lfl_players(
	id_team INT REFERENCES lfl_teams(id_team),
	id_player SERIAL PRIMARY KEY,
	first_name VARCHAR(64) NOT NULL,
	last_name VARCHAR(64) NOT NULL,
	patronymic VARCHAR(64) NULL,
	team_name VARCHAR(64) NULL
);

--CREATE TABLE match_results (
	match_id SERIAL PRIMARY KEY,
	team_1_id INT REFERENCES lfl_teams(id_team),
	team_2_id INT REFERENCES lfl_teams(id_team),
	team_1_score INT NOT NULL DEFAULT 0,
	team_2_score INT NOT NULL DEFAULT 0,
	match_date DATE NOT NULL
);

Заполнение таблицы lfl_teams

--INSERT INTO lfl_teams(team_name, competition_level) VALUES
('Дибиси', 1),
('Одиссея', 1),
('Глория', 1),
('Энергия', 1),
('Андреевка', 1),
('Сова', 1),
('Патриоты', 1),
('ФкЗБ', 1),
('Элемер', 1),
('Гуд Вуд', 1),

('Глория-2', 2),
('Дибиси-2', 2),
('Орион', 2),
('Апекс', 2),
('Русичи', 2),
('Гост', 2),
('НоуНейм', 2),
('Сова-2', 2),
('Фантом', 2),
('Энергия-2', 2),
('Велтон Парк', 2),
('Плешущиеся Пираты', 2),
('Форс', 2),
('Сандерленд', 2),
('Электрон', 2),
('Авангард', 2);




--Обновляем через процедуру данные в таблицах first_league и second_league

CALL UpdateTeamStatsByNameFirstLeague('Дибиси', 16, 0, 2);
CALL UpdateTeamStatsByNameFirstLeague('Одиссея', 12, 3, 3);
CALL UpdateTeamStatsByNameFirstLeague('Глория', 	10, 1, 7);
CALL UpdateTeamStatsByNameFirstLeague('Энергия', 9, 3, 6);
CALL UpdateTeamStatsByNameFirstLeague('Андреевка', 8, 5, 5);
CALL UpdateTeamStatsByNameFirstLeague('Сова', 	9, 1, 8);
CALL UpdateTeamStatsByNameFirstLeague('Патриоты', 7, 1, 10);
CALL UpdateTeamStatsByNameFirstLeague('ФкЗБ', 	6, 2, 10);
CALL UpdateTeamStatsByNameFirstLeague('Элемер', 4, 2, 12);
CALL UpdateTeamStatsByNameFirstLeague('Гуд Вуд', 0, 0, 18);

CALL UpdateTeamStatsByNameSecondLeague('Глория-2', 	25, 1, 4);
CALL UpdateTeamStatsByNameSecondLeague('Дибиси-2', 	24, 2, 4);
CALL UpdateTeamStatsByNameSecondLeague('НоуНейм', 	23, 3, 4);
CALL UpdateTeamStatsByNameSecondLeague('Сова-2', 	17, 6, 7);
CALL UpdateTeamStatsByNameSecondLeague('Фантом', 	18, 1, 11);
CALL UpdateTeamStatsByNameSecondLeague('Энергия-2', 	16, 3, 11);
CALL UpdateTeamStatsByNameSecondLeague('Велтон Парк', 13, 3, 14);
CALL UpdateTeamStatsByNameSecondLeague('Апекс', 	13, 3, 14);
CALL UpdateTeamStatsByNameSecondLeague('Русичи', 	12, 4, 14);
CALL UpdateTeamStatsByNameSecondLeague('Плешущиеся Пираты', 11, 5 , 14);
CALL UpdateTeamStatsByNameSecondLeague('Авангард', 	11, 4, 15);
CALL UpdateTeamStatsByNameSecondLeague('Орион', 	10, 4, 16);
CALL UpdateTeamStatsByNameSecondLeague('Форс',	7,  2, 21);
CALL UpdateTeamStatsByNameSecondLeague('Электрон', 	6,  4, 20);
CALL UpdateTeamStatsByNameSecondLeague('Гост', 		5,  3, 22);
CALL UpdateTeamStatsByNameSecondLeague('Сандерленд', 5,  0, 25);

--Заносим информацию об игроках в таблицу lfl_players

CALL add_player_to_team('Орион', 'Даниил', 'Иванов', 'Александрович');
CALL add_player_to_team('Орион', 'Никита', 'Нагайкин', 'Сергеевич');
CALL add_player_to_team('Орион', 'Артем', 'Сенчин', 'Борисович');
CALL add_player_to_team('Орион', 'Егор', 'Агейкин', 'Антонович');
CALL add_player_to_team('Орион', 'Никита', 'Агейкин', 'Антонович');
CALL add_player_to_team('Орион', 'Александр', 'Селиверстов', 'Дмитриевич');
CALL add_player_to_team('Орион', 'Егор', 'Федькин', 'Владимирович');
CALL add_player_to_team('Орион', 'Дмитрий', 'Орленкович', 'Марьянович');
CALL add_player_to_team('Орион', 'Александр', 'Малашенко', 'Геннадьевич');
CALL add_player_to_team('Орион', 'Николай', 'Цурка', 'Игоревич');
 	
--Заполняем таблицу team_owners

INSERT INTO team_owners(team_name, first_name, last_name, patronymic, phone) VALUES
('Дибиси','Евдокимов','Иван',  'Алексеевич',89999999999),
('Одиссея','Селезнев', 'Александр',   'Викторович',89998888888),
('Глория','Попаз', 'Михаил',  'Петрович', 89997777777),
('Энергия','Побединский', 'Артём',  'Владимирович',89996666666),
('Андреевка','Аржуханов', 'Алексей',  'Равильевич',89995555555),
('Сова','Семушин', 'Сергей', 'Владимирович',89994444444),
('Патриоты','Прижилов', 'Константин',  'Михайлович',89993333333),
('ФкЗБ','Митрошин', 'Александр’,  'Валерьевич',89992222222),
('Элемер','Ханаков', 'Павел', 'Сергеевич',89991111111),
('Гуд Вуд','Меняело','Андрей',   'Александрович',89990000000);

--Заполняем таблицу match_results

INSERT INTO match_results(team_1_id, team_2_id, team_1_score, team_2_score, match_date) VALUES
(39, 38, 2, 1, '2024-06-06'),
(42, 48, 4, 2, '2024-11-07'),
(51, 41, 0, 5, '2024-11-07'),
(39, 47, 2, 4, '2024-11-07'),
(45, 39, 0, 7, '2024-10-31'),
(52, 38, 0, 11, '2024-10-31'),
(37, 50, 6, 1, '2024-10-29'),
(51, 37, 0, 5, '2024-10-24'),
(50, 47, 6, 4, '2024-10-26'),
(48, 49, 3, 3, '2024-10-26');

