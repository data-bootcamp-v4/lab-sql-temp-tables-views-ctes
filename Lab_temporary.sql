USE sakila;

-- Step 1: Create a View for Rental Summary
CREATE OR REPLACE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: Create a Temporary Table for Payment Summary
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    rental_summary rs
LEFT JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY
    rs.customer_id;
    
-- Step 3: Create a CTE and Generate the Customer Summary Report
WITH customer_summary_cte AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM
        rental_summary rs
    LEFT JOIN customer_payment_summary cps ON rs.customer_id = cps.customer_id
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
    customer_summary_cte
ORDER BY
    customer_name;
