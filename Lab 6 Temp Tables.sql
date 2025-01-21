USE sakila;

DROP VIEW IF EXISTS customer_summary3;

CREATE VIEW customer_summary3 AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(*) AS rental_count
FROM 
    customer AS c
    JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    rental_count DESC;

SELECT *
FROM customer_summary3;

SELECT *
FROM rental;

CREATE TEMPORARY TABLE customer_payment_summary AS (
    SELECT 
        crs.customer_id,
        SUM(p.amount) AS total_paid
    FROM 
        customer_summary3 AS crs
        JOIN rental AS r ON crs.customer_id = r.customer_id
        JOIN payment AS p ON r.rental_id = p.rental_id
    GROUP BY 
        crs.customer_id
);

SELECT *
FROM customer_payment_summary;

WITH customer_summary_report AS(
SELECT 
    crs.customer_name,
    crs.email,
    crs.rental_count,
    cps.total_paid
FROM 
    customer_rental_summary AS crs
    JOIN customer_payment_summary AS cps ON crs.customer_id = cps.customer_id);