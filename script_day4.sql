1. SELECT * FROM FILM WHERE length_min >100;

2. SELECT * FROM FILM  
WHERE length_min > (SELECT AVG(length_min) FROM FILM);

3. SELECT * FROM FILM
WHERE name LIKE 't%';

4. SELECT * FROM FILM
WHERE name LIKE '%a%';

5. SELECT COUNT(*)
FROM FILM 
WHERE country = "US";

6. SELECT MIN(length_min), MAX(length_min)
FROM FILM;

7. SELECT DISTINCT genre FROM FILM;
