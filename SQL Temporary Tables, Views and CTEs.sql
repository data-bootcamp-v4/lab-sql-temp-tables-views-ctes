-- SQL Temporary Tables, Views and CTEs

USE sakila;

-- 1: Create a View

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
        LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: Create a Temporary Table

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    v.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary v
        LEFT JOIN
    payment p ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report

WITH customer_summary AS (
    SELECT 
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM
        customer_rental_summary v
            LEFT JOIN
        customer_payment_summary t ON v.customer_id = t.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE 
        WHEN rental_count > 0 THEN total_paid / rental_count
        ELSE 0
    END AS average_payment_per_rental
FROM 
    customer_summary;




