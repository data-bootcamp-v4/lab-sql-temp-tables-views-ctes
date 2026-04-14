USE sakila;

-- =========================
-- Step 1: Create View
-- =========================

CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;


-- =========================
-- Step 2: Temporary Table
-- =========================

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    v.customer_id,
    v.customer_name,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary v
LEFT JOIN payment p ON v.customer_id = p.customer_id
GROUP BY v.customer_id, v.customer_name;


-- =========================
-- Step 3: CTE + Final Report
-- =========================

WITH customer_summary AS (
    SELECT 
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM customer_rental_summary v
    JOIN customer_payment_summary t 
        ON v.customer_id = t.customer_id
)

SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS avg_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;