CREATE DATABASE sakila;
USE sakila;
SHOW TABLES;

SHOW TABLES IN sakila;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film;
SELECT * FROM sakila.customer;
SELECT title FROM sakila.film;
SELECT title FROM film;
SELECT first_name FROM staff;
SELECT COUNT(*) AS total_stores FROM store;
SELECT COUNT(*) AS total_staff FROM staff;
SELECT COUNT(*) AS available_films FROM inventory;
SELECT COUNT(*) AS rented_films FROM rental;
SELECT COUNT(DISTINCT last_name) AS unique_last_names FROM actor;
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 10;
SELECT *
FROM actor
WHERE first_name = 'SCARLETT';
SELECT *
FROM film
WHERE title LIKE '%ARMAGEDDON%'
AND length > 100;
SELECT COUNT(*) AS behind_the_scenes_films
FROM film
WHERE special_features LIKE '%Behind the Scenes%';
SELECT 
    MAX(length) AS max_duration,
    MIN(length) AS min_duration
FROM film;
SELECT 
    FLOOR(AVG(length) / 60) AS hours,
    FLOOR(AVG(length) % 60) AS minutes
FROM film;
SELECT 
    DATEDIFF(MAX(rental_date), MIN(rental_date)) AS operating_days
FROM rental;
SELECT 
    rental_id,
    rental_date,
    MONTH(rental_date) AS month,
    DAYNAME(rental_date) AS weekday
FROM rental
LIMIT 20;
SELECT 
    rental_id,
    rental_date,
    DAYNAME(rental_date) AS weekday,
    CASE 
        WHEN DAYNAME(rental_date) IN ('Saturday', 'Sunday') THEN 'weekend'
        ELSE 'workday'
    END AS day_type
FROM rental
LIMIT 20;
SELECT 
    title,
    IFNULL(rental_duration, 'Not Available') AS rental_duration
FROM film
ORDER BY title ASC;
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    SUBSTRING(email, 1, 3) AS email_prefix
FROM customer
ORDER BY last_name ASC;
SELECT COUNT(*) AS total_films
FROM film;
SELECT 
    rating,
    COUNT(*) AS total
FROM film
GROUP BY rating;
SELECT 
    rating,
    COUNT(*) AS total
FROM film
GROUP BY rating
ORDER BY total DESC;
SELECT 
    rating,
    ROUND(AVG(length), 2) AS avg_duration
FROM film
GROUP BY rating
ORDER BY avg_duration DESC;
SELECT 
    rating,
    ROUND(AVG(length), 2) AS avg_duration
FROM film
GROUP BY rating
HAVING AVG(length) > 120;
SELECT 
    last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;
SELECT 
    c.name AS category,
    COUNT(fc.film_id) AS total_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;
SELECT 
    s.store_id,
    ci.city,
    co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;
SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;
SELECT 
    c.name AS category,
    ROUND(AVG(f.length), 2) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;
SELECT 
    c.name AS category,
    ROUND(AVG(f.length), 2) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration DESC;
SELECT 
    f.title,
    COUNT(r.rental_id) AS times_rented
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY times_rented DESC
LIMIT 10;
SELECT 
    f.title,
    COUNT(r.rental_id) AS times_rented
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY times_rented DESC
LIMIT 10;
SELECT 
    f.title,
    i.store_id,
    COUNT(i.inventory_id) AS copies_available
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'ACADEMY DINOSAUR'
AND i.store_id = 1
GROUP BY f.title, i.store_id;
SELECT 
    f.title,
    CASE 
        WHEN COUNT(i.inventory_id) > 0 THEN 'Available'
        ELSE 'NOT available'
    END AS availability
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;
SELECT 
    COUNT(*) AS copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'HUNCHBACK IMPOSSIBLE'
);
SELECT 
    title,
    length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);
SELECT 
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'ALONE TRIP'
    )
);
SELECT 
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);
SELECT 
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);
SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';
SELECT 
    f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);
SELECT 
    DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);
SELECT 
    customer_id,
    SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS avg_table
);

USE sakila;
SHOW TABLES;
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.customer_name,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.customer_name;
WITH customer_summary AS (
    SELECT 
        crs.customer_id,
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps 
        ON crs.customer_id = cps.customer_id
)

SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS avg_payment_per_rental
FROM customer_summary;