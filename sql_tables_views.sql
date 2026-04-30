 USE sakila;
 
 CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

WITH customer_summary_report AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    -- Calculem la mitjana per lloguer
    CASE 
        WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
        ELSE 0 
    END AS average_payment_per_rental
FROM customer_summary_report;