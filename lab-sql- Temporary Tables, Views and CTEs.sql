-- LAB | Temporary Tables, Views and CTEs
-- Creating a Customer Summary Report

USE sakila;

-- STEP 1: Create a View
-- This view summarizes the rental information per customer

CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
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


-- Check the view
SELECT *
FROM customer_rental_summary
LIMIT 10;


-- STEP 2: Create a Temporary Table
-- This temporary table calculates total paid per customer


CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    ROUND(SUM(p.amount), 2) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p
    ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count;


-- Check the temporary table
SELECT *
FROM customer_payment_summary
LIMIT 10;


-- STEP 3: Create a CTE and Final Customer Summary Report
-- The CTE joins the view and the temporary table


WITH customer_summary AS (
    SELECT 
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
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;