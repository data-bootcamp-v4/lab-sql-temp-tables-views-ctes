USE sakila;

-- Step 1: Create a rental summary view per customer
CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    
-- Check Step 1
SELECT *
FROM customer_rental_summary
LIMIT 10;

-- Step 2: Create a temporary payment summary table per customer
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    customer_id,
    SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;

-- Check Step 2
SELECT *
FROM customer_payment_summary
LIMIT 10;

-- Step 3: Create final customer summary report using a CTE
WITH customer_summary AS (
    SELECT
        crs.customer_id,
        CONCAT(crs.first_name, ' ', crs.last_name) AS customer_name,
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
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary;