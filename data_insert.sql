--Запросы

--1. Выводит команды по количеству очков в первой лиге
SELECT team_name, wins, loses, draws, points
FROM first_league
ORDER BY points DESC;

--2. Выводит команды по количеству очков во второй лиге
SELECT team_name, wins, loses, draws, points
FROM second_league
ORDER BY points DESC;

--3. Выводит команды, который могут выйти в первую лигу
SELECT team_name AS "Команды, которые выходят в первую лигу", points AS "Очки"
FROM second_league
WHERE team_name NOT LIKE '%-2%'
ORDER BY points DESC
LIMIT 5;

--4. Выводит команды, которые вылетают из второй лиги
SELECT team_name AS "Команды, которые вылетают из второй лиги", points AS "Очки"
FROM second_league
WHERE team_name NOT LIKE '%-2%'
ORDER BY points ASC
LIMIT 2;

--5. Выводит дублирующие составы
SELECT team_name AS "Дубли в первой лиге", points AS "Очки"
FROM second_league
WHERE team_name LIKE '%-2%'
ORDER BY points DESC

--6. Команды в первой лиге с победами больше 10
SELECT team_name, wins
FROM first_league
WHERE wins > 10
ORDER BY wins DESC;

--7. Команды во второй лиге с наименьшим количеством поражений
SELECT team_name, loses
FROM second_league
WHERE loses = (SELECT MIN(loses) FROM second_league);

--8. Вывести игроков Ориона
SELECT first_name, last_name, patronymic
FROM lfl_players
WHERE id_team = 39;

--9. Вывести информацию о руководителе Дибиси
SELECT first_name, last_name, phone, mail
FROM team_owners
WHERE team_name LIKE 'Дибиси';

--10.  Среднее количество очков команд в первой лиге
SELECT AVG(points) AS avg_points
FROM first_league;

--11. Вывести число голов
SELECT SUM(team_1_score) + SUM(team_2_score) AS total_goals
FROM match_results
WHERE team_1_id = (SELECT id_team FROM lfl_teams WHERE team_name = 'Орион')
   OR team_2_id = (SELECT id_team FROM lfl_teams WHERE team_name = 'Орион');

--12. Вывести матчи команды Орион
SELECT match_id, team_1_score, team_2_score, match_date
FROM match_results
WHERE team_1_id = 39 OR team_2_id = 39; 

--13. Вывести команду с наибольшим количеством очков в двух лигах
SELECT team_name, points
FROM (
    SELECT team_name, points FROM first_league
    UNION ALL
    SELECT team_name, points FROM second_league
) AS all_teams
ORDER BY points DESC
LIMIT 1;

--14. Вывести список всех команд и их количество очков
SELECT t.team_name,
       COALESCE(MAX(fl.points), 0) + COALESCE(MAX(sl.points), 0) AS max_points
FROM lfl_teams t
LEFT JOIN first_league fl ON t.id_team = fl.id_team
LEFT JOIN second_league sl ON t.id_team = sl.id_team
GROUP BY t.team_name
ORDER BY max_points DESC;

--15. Выводит команды с наибольшим количеством побед в матчах, которые есть в базе
SELECT t.team_name,
       COUNT(mr.match_id) AS wins
FROM lfl_teams t
JOIN match_results mr ON (mr.team_1_id = t.id_team AND mr.team_1_score > mr.team_2_score) OR (mr.team_2_id = t.id_team AND mr.team_2_score > mr.team_1_score)
GROUP BY t.team_name
ORDER BY wins DESC;

--16. Выводит команды с их очками и количеством поражений на основе матчей
SELECT t.team_name,
       SUM(CASE
           WHEN (mr.team_1_id = t.id_team AND mr.team_1_score < mr.team_2_score) OR
                (mr.team_2_id = t.id_team AND mr.team_2_score < mr.team_1_score)
           THEN 1 ELSE 0 END) AS loses
FROM lfl_teams t
JOIN match_results mr ON mr.team_1_id = t.id_team OR mr.team_2_id = t.id_team
GROUP BY t.team_name
ORDER BY loses DESC;

--17. Выводит команды с наибольшим количеством ничьих на основе матчей
SELECT t.team_name,
       COUNT(mr.match_id) AS draws
FROM lfl_teams t
JOIN match_results mr ON (mr.team_1_id = t.id_team AND mr.team_1_score = mr.team_2_score)
                      OR (mr.team_2_id = t.id_team AND mr.team_2_score = mr.team_1_score)
GROUP BY t.team_name
ORDER BY draws DESC;

--18. Выводит однофамильцев из таблицы игроков
SELECT lp.last_name, 
       STRING_AGG(lp.first_name || ' ' || lp.last_name, ', ') AS players
FROM lfl_players lp
GROUP BY lp.last_name
HAVING COUNT(lp.last_name) > 1
ORDER BY lp.last_name;

--19. Выводит команды без побед
SELECT t.team_name, 
       CASE 
           WHEN fl.id_team IS NOT NULL THEN 'Первая лига' 
           WHEN sl.id_team IS NOT NULL THEN 'Вторая лига' 
       END AS league
FROM lfl_teams t
LEFT JOIN first_league fl ON t.id_team = fl.id_team
LEFT JOIN second_league sl ON t.id_team = sl.id_team
WHERE (fl.wins = 0 OR sl.wins = 0)
ORDER BY t.team_name;

--20. Выводит самую пропускающую команду на основе матчей
SELECT t.team_name,
       SUM(CASE 
               WHEN mr.team_1_id = t.id_team THEN mr.team_2_score
               WHEN mr.team_2_id = t.id_team THEN mr.team_1_score
               ELSE 0
           END) AS goals_conceded
FROM lfl_teams t
JOIN match_results mr ON mr.team_1_id = t.id_team OR mr.team_2_id = t.id_team
GROUP BY t.team_name
ORDER BY goals_conceded DESC
LIMIT 1;
