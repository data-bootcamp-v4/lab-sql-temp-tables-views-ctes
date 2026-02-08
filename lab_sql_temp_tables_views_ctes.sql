USE sakila ;

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

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    v.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary v
JOIN payment p
    ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

WITH customer_summary_cte AS (
    SELECT
        v.customer_id,
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM customer_rental_summary v
    JOIN temp_customer_payments t
        ON v.customer_id = t.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY customer_name;