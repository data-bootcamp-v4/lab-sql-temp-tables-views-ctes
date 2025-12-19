USE sakila;

-- Step 1: Create a View
DROP VIEW IF EXISTS view_customer;

CREATE VIEW view_customer AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;

-- Step 2: Create a Temporary Table
DROP TEMPORARY TABLE IF EXISTS total_paid;

CREATE TEMPORARY TABLE total_paid AS
SELECT
    vc.customer_id,
    SUM(p.amount) AS total_payment
FROM view_customer vc
JOIN payment p
    ON vc.customer_id = p.customer_id
GROUP BY
    vc.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report
WITH customer_totals AS (
    SELECT
        vc.customer_id,
        vc.full_name,
        vc.email,
        vc.rental_count,
        tp.total_payment AS total_paid
    FROM view_customer vc
    JOIN total_paid tp
        ON vc.customer_id = tp.customer_id
)
SELECT
    customer_id,
    full_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
FROM customer_totals
ORDER BY customer_id;


















