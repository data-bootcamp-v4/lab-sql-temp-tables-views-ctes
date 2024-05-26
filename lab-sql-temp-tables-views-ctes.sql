USE sakila;

-- View
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;
-- ------------------------------------------------------------
-- Temporary Table
CREATE TEMPORARY TABLE customer_payments AS
SELECT rs.customer_id,
       SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;
-- ------------------------------------------------------------
-- CTE and the Customer Summary Report
WITH customer_summary AS (
    SELECT rs.customer_name, rs.email, rs.rental_count, cp.total_paid,
        (cp.total_paid / rs.rental_count) AS average_payment_per_rental
    FROM rental_summary rs
    JOIN customer_payments cp ON rs.customer_id = cp.customer_id
)
SELECT customer_name, email, rental_count, total_paid, average_payment_per_rental
FROM customer_summary
ORDER BY customer_name;
