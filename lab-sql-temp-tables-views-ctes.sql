-- LAB | Temporary Tables, Views and CTEs

USE sakila;
-- Step 1: Create a rental summary view

CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    -- Step 2: Create a temporary payment summary table

DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary AS crs
LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;
SELECT *
FROM customer_payment_summary;
-- Step 3: Create a CTE and generate the customer summary report

WITH customer_summary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary AS crs
    JOIN customer_payment_summary AS cps
        ON crs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(
        total_paid / NULLIF(rental_count, 0),
        2
    ) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;
