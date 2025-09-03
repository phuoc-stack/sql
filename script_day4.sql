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

8. 
 SELECT f.name, IFNULL(DATEDIFF(MAX(start_time), MIN(start_time)), 0) AS 'Distance between the first and the last screening (in days)' 
 FROM screening s 
 RIGHT JOIN film f 
 ON s.film_id = f.id 
 GROUP BY f.name;

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
SELECT DISTINCT room_id
FROM screening s
GROUP BY room_id, DATE(start_time)
HAVING COUNT(DISTINCT film_id) > 2;

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

15. SELECT f.name, COUNT(DISTINCT s.room_id) AS room_count
FROM film f
JOIN screening s ON f.id = s.film_id
GROUP BY f.name
ORDER BY room_count DESC
LIMIT 1;

16. SELECT DAYNAME(s.start_time) AS dow,
COUNT(DISTINCT s.film_id) AS film_count
FROM screening s
GROUP BY dow
ORDER BY film_count DESC;

17. SELECT f.id, f.name,
COUNT(*) * f.length_min AS total_minutes
FROM screening s
JOIN film f ON f.id = s.film_id
WHERE DATE(s.start_time) = '2022-05-28'
GROUP BY f.id, f.name, f.length_min
ORDER BY total_minutes DESC;

18. WITH totals AS (
  SELECT f.id, f.name, COUNT(s.id) * f.length_min AS total_minutes
  FROM film f
  LEFT JOIN screening s ON s.film_id = f.id
  GROUP BY f.id, f.name, f.length_min
),
avg_val AS (
  SELECT AVG(total_minutes) AS avg_minutes FROM totals
)
SELECT t.id, t.name, t.total_minutes,
       CASE
         WHEN t.total_minutes > a.avg_minutes THEN 'above'
         WHEN t.total_minutes < a.avg_minutes THEN 'below'
         ELSE 'equal'
       END AS vs_average
FROM totals t CROSS JOIN avg_val a
ORDER BY t.total_minutes DESC;

19. SELECT s.room_id, r.name AS room_name, COUNT(*) AS seat_count
FROM seat s
JOIN room r ON r.id = s.room_id
GROUP BY s.room_id, r.name
ORDER BY seat_count ASC
LIMIT 1;

20. WITH seat_counts AS (
  SELECT s.room_id, COUNT(*) AS seat_count
  FROM seat s
  GROUP BY s.room_id
),
avg_ct AS (
  SELECT AVG(seat_count) AS avg_seats FROM seat_counts
)
SELECT r.id AS room_id, r.name AS room_name, sc.seat_count
FROM seat_counts sc
JOIN room r ON r.id = sc.room_id
JOIN avg_ct a
WHERE sc.seat_count > a.avg_seats
ORDER BY sc.seat_count DESC;

21. SELECT s2.id AS seat_id, s2.row_no, s2.seat_no
FROM booking b1
JOIN screening sc ON sc.id = b1.screening_id
JOIN seat s2 ON s2.room_id = sc.room_id
LEFT JOIN reserved_seat rs
       ON rs.seat_id = s2.id
      AND rs.booking_id IN (SELECT id FROM booking WHERE screening_id = sc.id)
WHERE b1.id = 1
  AND rs.seat_id IS NULL;

22. SELECT f.id, f.name, COUNT(s.id) AS total_screenings
FROM film f
JOIN screening s ON s.film_id = f.id
GROUP BY f.id, f.name
HAVING COUNT(s.id) > 10
ORDER BY total_screenings DESC;

23. SELECT DAYNAME(sc.start_time) AS dow,
       COUNT(b.id) AS total_bookings
FROM booking b
JOIN screening sc ON sc.id = b.screening_id
GROUP BY dow
ORDER BY total_bookings DESC
LIMIT 3;

24. SELECT f.id, f.name,
       COUNT(b.id) / NULLIF(COUNT(DISTINCT s.id), 0) AS booking_rate
FROM film f
LEFT JOIN screening s ON s.film_id = f.id
LEFT JOIN booking  b ON b.screening_id = s.id
GROUP BY f.id, f.name
ORDER BY booking_rate DESC, f.name;

25. WITH room_counts AS (
  SELECT f.id, f.name, COUNT(DISTINCT s.room_id) AS room_count
  FROM film f
  JOIN screening s ON s.film_id = f.id
  GROUP BY f.id, f.name
),
avg_ct AS ( SELECT AVG(room_count) AS avg_room_count FROM room_counts )
SELECT rc.id, rc.name, rc.room_count,
    CASE
        WHEN rc.room_count > a.avg_room_count THEN 'above'
        WHEN rc.room_count < a.avg_room_count THEN 'below'
        ELSE 'equal'
    END AS vs_average
FROM room_counts rc
CROSS JOIN avg_ct a
ORDER BY rc.room_count DESC, rc.name;

26. WITH ranked AS (
  SELECT c.id, c.first_name, c.last_name,
         SUM(f.length_min) AS total_minutes,
         DENSE_RANK() OVER (ORDER BY SUM(f.length_min)) AS rnk
  FROM customer c
  JOIN booking b ON b.customer_id = c.id
  JOIN screening s ON s.id = b.screening_id
  JOIN film f ON f.id = s.film_id
  GROUP BY c.id, c.first_name, c.last_name
)
SELECT *
FROM ranked
WHERE rnk <= 2
ORDER BY rnk, total_minutes;