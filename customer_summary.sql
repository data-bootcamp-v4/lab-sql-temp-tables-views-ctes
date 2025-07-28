CREATE OR REPLACE VIEW rental_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;
SELECT * FROM rental_summary;
CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;
SELECT * FROM payment_summary;
WITH customer_summary AS (
    SELECT 
        rs.first_name,
        rs.last_name,
        rs.email,
        rs.rental_count,
        ps.total_paid,
        ROUND(ps.total_paid / rs.rental_count, 2) AS average_payment_per_rental
    FROM rental_summary rs
    JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT * FROM customer_summary;
