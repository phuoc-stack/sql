1. SELECT * FROM film WHERE length_min >100;

2. SELECT * FROM film  
WHERE length_min > (SELECT AVG(length_min) FROM film);

3. SELECT * FROM film
WHERE name LIKE 't%';

4. SELECT * FROM film
WHERE name LIKE '%a%';

5. SELECT COUNT(*)
FROM film 
WHERE country_code = "US";

6. SELECT MIN(length_min), MAX(length_min)
FROM film;

7. SELECT DISTINCT type FROM film;

8. WITH film_time as (
SELECT 
	id, 
    min(start_time) as min_time, 
    max(start_time) as max_time
FROM screening 
GROUP BY id
)
select id, abs(datediff(min_time, max_time)) as 'Distance in days' from film_time

9. SELECT name, room_name, start_time
FROM film 
INNER JOIN screening ON film.id = screening.film_id
WHERE name = "Tom&Jerry"
