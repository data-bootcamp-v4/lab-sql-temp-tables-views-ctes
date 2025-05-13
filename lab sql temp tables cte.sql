Use sakila;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;
-- temp table
CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    r.customer_id,
    SUM(p.amount) AS total_paid
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY r.customer_id;
-- CTE and the Customer Summary Report
WITH customer_cte AS (
    SELECT 
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid,
        CASE WHEN rs.rental_count > 0 THEN ps.total_paid / rs.rental_count ELSE 0 END AS average_payment_per_rental
    FROM rental_summary rs
    LEFT JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)

-- Customer Summary Report
SELECT * FROM customer_cte;
