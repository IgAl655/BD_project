--Процедура для обновления числа побед, поражений и ничьих в первой лиге
CREATE OR REPLACE PROCEDURE UpdateTeamStatsByNameFirstLeague(
    team_name_input VARCHAR,
    new_wins INT,
    new_draws INT,      
    new_loses INT            
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE first_league
    SET wins = new_wins,
        draws = new_draws,
        loses = new_loses,
        points = (new_wins * 3) + (new_draws * 1)
    WHERE team_name = team_name_input;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Team "%" not found', team_name_input;
    END IF;
END;
$$;

--Пример:
CALL UpdateTeamStatsByNameFirstLeague('Дибиси', 16, 0, 2);


--Процедура для обновления числа побед, поражений и ничьих во второй лиге
CREATE OR REPLACE PROCEDURE UpdateTeamStatsByNameSecondLeague(
    team_name_input VARCHAR,
    new_wins INT,
    new_draws INT,
    new_loses INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE second_league
    SET wins = new_wins,
        draws = new_draws,
        loses = new_loses,
        points = (new_wins * 3) + (new_draws * 1)
    WHERE team_name = team_name_input;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Team "%" not found', team_name_input;
    END IF;
END;
$$;

--Пример:
CALL UpdateTeamStatsByNameSecondLeague('Глория-2', 25, 1, 4);




--Процедура для добавления команды в lfl_teams
CREATE OR REPLACE PROCEDURE add_new_team(
    p_team_name VARCHAR,
    p_division INT,
    p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка, существует ли команда с таким id в таблице lfl_teams
    IF NOT EXISTS (SELECT 1 FROM lfl_teams WHERE id_team = p_id) THEN
        INSERT INTO lfl_teams(id_team, team_name, competition_level)
        VALUES (p_id, p_team_name, p_division);
    ELSE
        -- Если команда с таким id уже существует, обновим её данные
        UPDATE lfl_teams
        SET team_name = p_team_name, competition_level = p_division
        WHERE id_team = p_id;
    END IF;
    IF p_division = 1 THEN
        IF NOT EXISTS (SELECT 1 FROM first_league WHERE id_team = p_id) THEN
            INSERT INTO first_league(id_team, team_name)
            VALUES (p_id, p_team_name);
        END IF;
    ELSIF p_division = 2 THEN
        IF NOT EXISTS (SELECT 1 FROM second_league WHERE id_team = p_id) THEN
            INSERT INTO second_league(id_team, team_name)
            VALUES (p_id, p_team_name);
        END IF;
    END IF;
END;
$$;

Пример:
CALL add_new_team('Орион-2', 1, 5);

--Процедура для добавления игрока в команду.
CREATE OR REPLACE PROCEDURE add_player_to_team(
    p_team_name VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_patronymic VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_team_id INT;
BEGIN
    SELECT id_team INTO v_team_id
    FROM lfl_teams
    WHERE team_name = p_team_name;
    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Команда с названием "%" не найдена', p_team_name;
    END IF;
    INSERT INTO lfl_players (id_team, first_name, last_name, patronymic)
    VALUES (v_team_id, p_first_name, p_last_name, p_patronymic);
END;
$$;

--Пример:
CALL add_player_to_team('Глория', 'Цепков', 'Георгий', 'Николаевич');

--Процедура для получения статистики команды.
CREATE OR REPLACE PROCEDURE get_team_statistics(
    p_team_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_games_played INT;
    v_wins INT;
    v_draws INT;
    v_loses INT;
    v_points INT;
BEGIN
    -- Получение статистики команды из первой лиги
    IF EXISTS (SELECT 1 FROM first_league WHERE id_team = p_team_id) THEN
        SELECT games_played, wins, draws, loses, points
        INTO v_games_played, v_wins, v_draws, v_loses, v_points
        FROM first_league
        WHERE id_team = p_team_id;
    -- Получение статистики команды из второй лиги
    ELSIF EXISTS (SELECT 1 FROM second_league WHERE id_team = p_team_id) THEN
        SELECT games_played, wins, draws, loses, points
        INTO v_games_played, v_wins, v_draws, v_loses, v_points
        FROM second_league
        WHERE id_team = p_team_id;
    ELSE
        RAISE EXCEPTION 'Team not found in any league';
    END IF;
    RAISE NOTICE 'Статистика команды: Количество игр: %, Побед: %, Ничьих: %, Поражений: %, Очков: %', 
                 v_games_played, v_wins, v_draws, v_loses, v_points;
END;
$$;

--Пример:
CALL get_team_statistics(39);
