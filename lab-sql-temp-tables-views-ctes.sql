USE sakila;
--  1: Create a View
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;
-- : Create a Temporary Table
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    r.customer_id,
    SUM(p.amount) AS total_paid
FROM 
    rental_summary r
JOIN 
    payment p ON r.customer_id = p.customer_id
GROUP BY 
    r.customer_id;

-- 3: Create a CTE and the Customer Summary Report
WITH customer_summary AS (
    SELECT
        r.name,
        r.email,
        r.rental_count,
        cps.total_paid,
        (cps.total_paid / r.rental_count) AS average_payment_per_rental
    FROM 
        rental_summary r
    JOIN 
        customer_payment_summary cps ON r.customer_id = cps.customer_id
)
SELECT 
    name, 
    email, 
    rental_count, 
    total_paid, 
    average_payment_per_rental 
FROM 
    customer_summary;
