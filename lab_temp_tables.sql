USE sakila;

CREATE OR REPLACE VIEW rental_summary AS
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


-- Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM rental_summary rs
LEFT JOIN payment p
    ON rs.customer_id = p.customer_id
GROUP BY
    rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count;


-- Step 3: Create a CTE and final report
WITH customer_summary AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps
        ON rs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;