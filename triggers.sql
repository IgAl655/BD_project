--Триггеры

--Триггер для заполнения первой и второй лиги
CREATE OR REPLACE FUNCTION insert_into_league() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.competition_level = 1 THEN
        INSERT INTO first_league(id_team, team_name)
        VALUES (NEW.id_team, NEW.team_name);
    ELSIF NEW.competition_level = 2 THEN
        INSERT INTO second_league(id_team, team_name)
        VALUES (NEW.id_team, NEW.team_name);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_into_league
AFTER INSERT ON lfl_teams
FOR EACH ROW
EXECUTE FUNCTION insert_into_league();



--Триггер для вычисления количества игр в таблице (first_league)
CREATE OR REPLACE FUNCTION calculate_games_played_first_league()
RETURNS TRIGGER AS $$
BEGIN
  NEW.games_played := NEW.wins + NEW.draws + NEW.loses;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_games_played_first_league
  BEFORE INSERT OR UPDATE ON first_league
  FOR EACH ROW
  EXECUTE FUNCTION calculate_games_played_first_league();


--Триггер для вычисления количества игр в таблице (second_league)
CREATE OR REPLACE FUNCTION calculate_games_played_second_league()
RETURNS TRIGGER AS $$
BEGIN
  NEW.games_played := NEW.wins + NEW.draws + NEW.loses;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_games_played_second_league
  BEFORE INSERT OR UPDATE ON second_league
  FOR EACH ROW
  EXECUTE FUNCTION calculate_games_played_second_league();




--Триггер для заполнения поля mail (team_owners)
CREATE OR REPLACE FUNCTION set_default_mail() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.mail IS NULL THEN
        NEW.mail := LOWER(NEW.first_name || '.' || NEW.last_name || '@yandex.com');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_default_mail
BEFORE INSERT ON team_owners
FOR EACH ROW
EXECUTE FUNCTION set_default_mail();




--Триггер ограничения по количеству игр в ПЕРВОЙ ЛИГЕ (first_league)
CREATE OR REPLACE FUNCTION check_max_games_in_season_first_league()
RETURNS TRIGGER AS $$
DECLARE
  max_games INT;
  team_count INT;
BEGIN
  -- Считываем количество команд в лиге first_league
  SELECT COUNT(*) INTO team_count FROM first_league;
  max_games := (team_count * 2) - 2;
  NEW.games_played := NEW.wins + NEW.draws + NEW.loses;
  IF NEW.games_played > max_games THEN
    RAISE EXCEPTION 'Команда % не может сыграть больше % матчей в сезоне, текущие игры: %',
                    NEW.team_name, max_games, NEW.games_played;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_max_games_second_league
  BEFORE INSERT OR UPDATE ON first_league
  FOR EACH ROW
  EXECUTE FUNCTION check_max_games_in_season_second_league();


--Триггер ограничения по количеству игр во ВТОРОЙ ЛИГЕ (second_league)
CREATE OR REPLACE FUNCTION check_max_games_in_season_second_league()
RETURNS TRIGGER AS $$
DECLARE
  max_games INT;
  team_count INT;
BEGIN
  SELECT COUNT(*) INTO team_count FROM second_league;
  max_games := (team_count * 2) - 2;
  NEW.games_played := NEW.wins + NEW.draws + NEW.loses;
  IF NEW.games_played > max_games THEN
    RAISE EXCEPTION 'Команда % не может сыграть больше % матчей в сезоне, текущие игры: %',
                    NEW.team_name, max_games, NEW.games_played;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_max_games_second_league
  BEFORE INSERT OR UPDATE ON second_league
  FOR EACH ROW
  EXECUTE FUNCTION check_max_games_in_season_second_league();



--Триггер для проверки уникальности игрока при вставке или обновлении (lfl_players)
CREATE OR REPLACE FUNCTION check_unique_player_in_team()
RETURNS TRIGGER AS $$
BEGIN
  -- Проверяем, есть ли уже игрок с таким же именем и фамилией в той же команде
  IF EXISTS (
    SELECT 1 FROM lfl_players
    WHERE team_name = NEW.team_name
    AND first_name = NEW.first_name
    AND last_name = NEW.last_name
  ) THEN
    RAISE EXCEPTION 'Игрок с именем % % уже существует в команде %',
                    NEW.first_name, NEW.last_name, NEW.team_name;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_unique_player_in_team
  BEFORE INSERT OR UPDATE ON lfl_players
  FOR EACH ROW
  EXECUTE FUNCTION check_unique_player_in_team();


--Триггер для вычисления значения в поле team_name (lfl_players)
CREATE OR REPLACE FUNCTION update_team_name()
RETURNS TRIGGER AS $$
BEGIN
    SELECT team_name INTO NEW.team_name
    FROM lfl_teams
    WHERE lfl_teams.id_team = NEW.id_team;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_team_name
BEFORE INSERT ON lfl_players
FOR EACH ROW
EXECUTE FUNCTION update_team_name();
