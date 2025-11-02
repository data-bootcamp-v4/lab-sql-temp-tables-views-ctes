-- Step 1: Create a View First, create a view that summarizes rental information for each customer.
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
USE sakila;

CREATE VIEW IF NOT EXISTS rental_summary AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name,
    c.email, 
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


-- step 2

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    rs.customer_id,
    rs.first_name,
    rs.last_name,
    rs.email,
    rs.rental_count,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON p.customer_id = rs.customer_id
GROUP BY rs.customer_id, rs.first_name, rs.last_name, rs.email, rs.rental_count;


-- 3

WITH customer_summary_cte AS (
    SELECT 
        rs.customer_id,
        CONCAT(rs.first_name, ' ', rs.last_name) AS customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps ON cps.customer_id = rs.customer_id
)
SELECT 
    cs.customer_name,
    cs.email,
    cs.rental_count,
    cs.total_paid,
    ROUND(cs.total_paid / cs.rental_count, 2) AS average_payment_per_rental
FROM customer_summary_cte cs
ORDER BY cs.total_paid DESC;