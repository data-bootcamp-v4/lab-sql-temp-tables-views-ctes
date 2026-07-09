-- 1. Creating a Customer Summary Report

-- 1.1 Step 1: Create a View that summarizes rental information for each customer.
USE Sakila;
DROP VIEW IF EXISTS customer_summary;
CREATE VIEW Customer_summary AS
SELECT c.customer_id, c.first_name,c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer as c
JOIN rental as r
ON c.customer_id=r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM customer_summary;
-- 1.2  create a Temporary Table that calculates the total amount paid by each customer (total_paid).
SELECT *
FROM payment
LIMIT 5;
CREATE TEMPORARY TABLE temp_customer_payment AS
SELECT 
    cs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_summary AS cs
JOIN payment AS p
ON cs.customer_id = p.customer_id
GROUP BY cs.customer_id;
SELECT * FROM temp_customer_payment;

-- Create a CTE and the Customer Summary Report
WITH final_summary AS (
    SELECT
        CONCAT(cs.first_name, ' ', cs.last_name) AS customer_name,
        cs.email,
        cs.rental_count,
        tcp.total_paid
    FROM customer_summary AS cs
    JOIN temp_customer_payment AS tcp
        ON cs.customer_id = tcp.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM final_summary;
