-- sakila_CTEs.sql

use sakila;

-- Step 1: Create Sql "View" 
-- Summarize rental info per customer (ID, name, email, rental count).

-- Step 1: Create the View
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
    c.email, 
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

SELECT * FROM customer_rental_summary; 

-- Step 2: Create Temp. Table
-- Calculate total per customer (join payment table with view -- create summary AS select ...)

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id, 
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

SELECT * FROM customer_payment_summary;

-- Step 3: Create CTE and final Report
-- CTE (Common Table Expressions) are sql standard programming vars. use WITH to define temp result and query that!
-- Join View and Temp Table INSIDE a CTE, then do (total_paid / rental_count) 

WITH customer_summary_cte AS (
    SELECT 
        crs.customer_name, 
        crs.email, 
        crs.rental_count, 
        cps.total_paid
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)

-- Use CTE in execution Select statement
SELECT 
    customer_name, 
    email, 
    rental_count, 
    total_paid, 
    (total_paid / rental_count) AS average_payment_per_rental
FROM customer_summary_cte;