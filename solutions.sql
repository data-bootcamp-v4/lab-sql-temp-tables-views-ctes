USE sakila;
SHOW tables;

# 1. 
CREATE OR REPLACE VIEW rental_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r 
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

# 2.
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p 
    ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

# 3.
WITH customer_summary_cte AS (
    SELECT 
        rs.first_name,
        rs.last_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps
        ON rs.customer_id = cps.customer_id
)
SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY last_name, first_name;
