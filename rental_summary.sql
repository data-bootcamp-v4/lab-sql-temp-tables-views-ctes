USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       c.email, 
       COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT v.customer_id, 
       SUM(p.amount) AS total_paid
FROM customer_rental_summary v
JOIN payment p ON v.customer_id = p.customer_id
GROUP BY v.customer_id;


WITH customer_summary AS (
    SELECT v.customer_name, 
           v.email, 
           v.rental_count, 
           t.total_paid,
           (t.total_paid / v.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary v
    JOIN customer_payment_summary t ON v.customer_id = t.customer_id
)
SELECT * 
FROM customer_summary
ORDER BY customer_name;
