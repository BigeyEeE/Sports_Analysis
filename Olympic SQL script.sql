#1
select * from games 
order by games_year

#2
SELECT games_year, COUNT(*) AS count
FROM games 
GROUP BY games_year
order by 1 asc;


#4
select sport_name from sport
where sport.id in 
(select id from games
where games_year >2000) 
SELECT sport.sport_name
FROM sport
JOIN games ON sport.id = games.id
WHERE games.games_year > 2000;

#6
SELECT sport.sport_name, noc_region.region_name
FROM sport
JOIN noc_region ON sport.id = noc_region.id
GROUP BY sport.sport_name, noc_region.region_name
HAVING COUNT(noc_region.noc) > 1;


# 7 Are there any sports that have a higher number of events for one gender compared to others?
SELECT s.id AS sport_id, e.event_name , p.gender
FROM sport AS s
JOIN event AS e ON s.id = e.id
JOIN person AS p ON e.id = p.id
WHERE e.sport_id = (SELECT MAX(sport_id) FROM event)
ORDER BY 3;

WITH GenderEventCounts AS (
    SELECT
        s.sport_name,
        e.event_name,
        p.gender,
        COUNT(DISTINCT e.id) AS event_count
    FROM
        sport s
        JOIN event e ON s.id = e.sport_id
        JOIN competitor_event ce ON e.id = ce.event_id
        JOIN games_competitor gc ON ce.competitor_id = gc.id
        JOIN person p ON gc.person_id = p.id
    GROUP BY
        s.sport_name, e.event_name, p.gender
)

SELECT
    sport_name,
    MAX(CASE WHEN gender = 'Male' THEN event_count ELSE 0 END) AS male_event_count,
    MAX(CASE WHEN gender = 'Female' THEN event_count ELSE 0 END) AS female_event_count
FROM
    GenderEventCounts
GROUP BY
    sport_name
HAVING
    male_event_count > female_event_count OR female_event_count > male_event_count;

# 8Are there any new events that have been introduced in recent editions of the Olympics?

select e.event_name , g.games_year
from event as e 
join games as g on e.id=g.id
where g.games_year >2000
order by g.games_year asc ;

# 9 Are there any events that have been discontinued or removed from the Olympics?
SELECT e.event_name, g.games_year
FROM event AS e
JOIN games AS g ON e.id = g.id
WHERE g.games_year > 2000
ORDER BY 2 ASC;
