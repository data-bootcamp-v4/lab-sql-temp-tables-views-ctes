CREATE OR REPLACE VIEW rental_summary_view AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE temp_payment_summary AS
SELECT 
    rsv.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary_view rsv
JOIN payment p ON rsv.customer_id = p.customer_id
GROUP BY rsv.customer_id;

WITH customer_summary_cte AS (
    SELECT 
        rsv.customer_name,
        rsv.email,
        rsv.rental_count,
        tps.total_paid
    FROM rental_summary_view rsv
    JOIN temp_payment_summary tps 
        ON rsv.customer_id = tps.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;
