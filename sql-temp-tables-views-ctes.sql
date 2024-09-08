USE sakila;
-- Step 1--
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    c.email AS email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, name, email;
-- Step 2 --
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    r.customer_id AS customer_id,
    SUM(p.amount) AS total_paid
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY r.customer_id;
-- Step 3 --

WITH customer_summary AS (
    SELECT 
        rs.customer_id AS customer_id,
        rs.name AS customer_name,
        rs.email AS customer_email,
        rs.rental_count AS rental_count,
        cps.total_paid AS total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps 
    ON rs.customer_id = cps.customer_id
)
SELECT 
    customer_name,
    customer_email,
    rental_count,
    total_paid,
    (total_paid / rental_count) AS average_payment_per_rental
FROM customer_summary;



