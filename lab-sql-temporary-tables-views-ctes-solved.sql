-- LAB | Temporary Tables, Views and CTEs
-- Database: Sakila (MySQL 8.0+)

USE sakila;

-- Step 1: Create a view summarizing each customer's rental history.
DROP VIEW IF EXISTS customer_rental_summary;

CREATE VIEW customer_rental_summary AS
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

-- Check the view
SELECT *
FROM customer_rental_summary
ORDER BY customer_id;

-- Step 2: Create a temporary table containing total payments per customer.
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    v.customer_id,
    COALESCE(SUM(p.amount), 0.00) AS total_paid
FROM customer_rental_summary AS v
LEFT JOIN payment AS p
    ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

-- Check the temporary table
SELECT *
FROM customer_payment_summary
ORDER BY customer_id;

-- Step 3: Use a CTE to create the final customer summary report.
WITH customer_summary AS (
    SELECT
        v.customer_id,
        v.customer_name,
        v.email,
        v.rental_count,
        p.total_paid
    FROM customer_rental_summary AS v
    INNER JOIN customer_payment_summary AS p
        ON v.customer_id = p.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE
        WHEN rental_count = 0 THEN 0.00
        ELSE ROUND(total_paid / rental_count, 2)
    END AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, customer_name;
