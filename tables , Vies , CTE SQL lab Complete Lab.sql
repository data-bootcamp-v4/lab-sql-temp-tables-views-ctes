use sakila;    ##loading DB

## creating view 
CREATE VIEW customer_rentals_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

##testing 
SELECT * FROM customer_rentals_summary ORDER BY rental_count DESC LIMIT 5;

##creating temp table
CREATE TEMPORARY TABLE customer_payments_summary AS
SELECT 
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    ROUND(SUM(p.amount), 2) AS total_paid
FROM customer_rentals_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.customer_name, crs.email, crs.rental_count;

##testing 
SELECT * FROM customer_payments_summary ORDER BY total_paid DESC LIMIT 5;

####Creating CTE 
WITH customer_summary_cte AS (
    SELECT 
        customer_id,
        customer_name,
        email,
        rental_count,
        total_paid
    FROM customer_payments_summary
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;