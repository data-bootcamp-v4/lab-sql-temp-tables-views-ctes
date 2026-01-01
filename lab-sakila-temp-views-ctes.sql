-- ---------------------------------------------------
-- Lab: Temporary Tables, Views, and CTEs (Sakila DB)
-- ---------------------------------------------------

USE sakila;

-- ---------------------------------------------------
-- Step 1: Create a View summarizing rental information per customer
-- ---------------------------------------------------
DROP VIEW IF EXISTS customer_rental_summary;

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, full_name, c.email;

-- Verify the view
SELECT * FROM customer_rental_summary LIMIT 10;

-- ---------------------------------------------------
-- Step 2: Create a Temporary Table for total amount paid per customer
-- ---------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS temp_customer_payment_summary;

CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT 
    c.customer_id,
    SUM(p.amount) AS total_paid
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- Verify temporary table data
SELECT * FROM temp_customer_payment_summary LIMIT 10;

-- ---------------------------------------------------
-- Step 3: Create a CTE and the Final Customer Summary Report
-- ---------------------------------------------------

WITH customer_summary AS (
    SELECT 
        crs.full_name,
        crs.email,
        crs.rental_count,
        tps.total_paid,
        ROUND(tps.total_paid / NULLIF(crs.rental_count, 0), 2) AS average_payment_per_rental
    FROM customer_rental_summary crs
    LEFT JOIN temp_customer_payment_summary tps 
        ON crs.customer_id = tps.customer_id
)
SELECT 
    full_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;

