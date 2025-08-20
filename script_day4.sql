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

10. SELECT * FROM screening 
WHERE start_time LIKE '2022-05-25%' OR start_time LIKE '2022-05-24%';

SELECT * FROM film f
LEFT JOIN screening s ON f.id = s.film_id
WHERE s.film_id IS NULL;

11. SELECT c.id, c.first_name, c.last_name, b.id as booking_id, COUNT(rs.seat_id) as seats_booked
FROM customer c
INNER JOIN booking b ON c.id = b.customer_id
INNER JOIN reserved_seat rs ON b.id = rs.booking_id
GROUP BY c.id, c.first_name, c.last_name, b.id
HAVING COUNT(rs.seat_id) > 1
ORDER BY seats_booked DESC;

12. 
SELECT 
    room_id, 
    DATE(start_time) AS screening_day,
    COUNT(film_id) AS film_count
FROM screening
GROUP BY 
    room_id, 
    DATE(start_time)
HAVING COUNT(DISTINCT film_id) > 2;

13. SELECT room_id, COUNT(DISTINCT film_id) AS film_count
FROM screening
GROUP BY room_id
ORDER BY film_count ASC
LIMIT 1;

14. SELECT f.name FROM sql.film f
INNER JOIN screening s ON f.id = s.film_id
LEFT JOIN booking b ON b.screening_id = s.id
GROUP BY f.name
HAVING COUNT(b.id) =0;

15. 