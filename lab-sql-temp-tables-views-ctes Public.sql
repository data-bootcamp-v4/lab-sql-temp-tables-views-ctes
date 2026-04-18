USE sakila;

-- Optional cleanup if you re-run the script
DROP VIEW IF EXISTS customer_rental_summary;

-- Step 1: Create a View
-- Summarizes rental information for each customer
CREATE VIEW customer_rental_summary AS
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
-- Calculates the total amount paid by each customer
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    v.customer_id,
    v.customer_name,
    v.email,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary v
LEFT JOIN payment p
    ON v.customer_id = p.customer_id
GROUP BY
    v.customer_id,
    v.customer_name,
    v.email;

-- Step 3: Create a CTE and generate the final report
WITH customer_summary_cte AS (
    SELECT
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM customer_rental_summary v
    LEFT JOIN customer_payment_summary t
        ON v.customer_id = t.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE
        WHEN rental_count = 0 THEN 0
        ELSE ROUND(total_paid / rental_count, 2)
    END AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY customer_name;