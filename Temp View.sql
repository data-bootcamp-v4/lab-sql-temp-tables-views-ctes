USE sakila;

-- Ejercicio 1 
CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Ejercicio 2

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    v.customer_id,
    v.customer_name,
    v.email,
    v.rental_count,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary v
LEFT JOIN payment p ON v.customer_id = p.customer_id
GROUP BY v.customer_id, v.customer_name, v.email, v.rental_count;


-- Ejercicio 3

WITH customer_summary AS (
    SELECT
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM customer_rental_summary v
    JOIN customer_payment_summary t ON v.customer_id = t.customer_id
)
SELECT *
FROM customer_summary;