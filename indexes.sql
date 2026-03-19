--	Индексы для таблицы lfl_teams
--Этот индекс ускорит поиск команд по их имени, а также может улучшить производительность, 
-- если вы часто используете сортировку или фильтрацию по team_name.
CREATE INDEX idx_lfl_teams_team_name ON lfl_teams (team_name);

--Индекс ускорит запросы, которые фильтруют или сортируют команды по уровню соревнований.
CREATE INDEX idx_lfl_teams_competition_level ON lfl_teams (competition_level);

--	Индексы для таблиц с внешними ключами
--Поскольку поле id_team является внешним ключом, связывающим эти таблицы с таблицей lfl_teams, создание индекса на этих полях ускорит операции слияния (JOIN) и фильтрацию данных по этим полям.

CREATE INDEX idx_first_league_id_team ON first_league (id_team);
CREATE INDEX idx_second_league_id_team ON second_league (id_team);
CREATE INDEX idx_lfl_players_id_team ON lfl_players (id_team);
CREATE INDEX idx_team_owners_team_name ON team_owners (team_name);

--	Индексы для таблицы match_results
-- Эти индексы ускоряют выполнение запросов, которые ищут все матчи, в которых участвовала конкретная команда, как в качестве первой, так и во второй команды.

CREATE INDEX idx_match_results_team_1_id ON match_results (team_1_id);
CREATE INDEX idx_match_results_team_2_id ON match_results (team_2_id);

--Индекс ускоряет поиск матчей по дате и сортировку матчей по времени.
CREATE INDEX idx_match_results_match_date ON match_results (match_date);


--	Индекс для lfl_players по фамилии и имени
--Индекс ускоряет поиск игроков по фамилии и имени, особенно в случае поиска однофамильцев или игроков с конкретными фамилиями.
CREATE INDEX idx_lfl_players_last_name_first_name ON lfl_players (last_name, first_name);
