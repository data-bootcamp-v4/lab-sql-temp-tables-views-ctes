USE sakila;
CREATE VIEW rental_info AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY rental_count DESC;

CREATE TEMPORARY TABLE total_paid AS
SELECT ri.customer_id, SUM(p.amount) AS total_amount_per_customer
FROM rental_info ri
JOIN rental AS r ON ri.customer_id = r.customer_id
JOIN payment p ON r.customer_id = p.customer_id
GROUP BY customer_id
ORDER BY total_amount_per_customer;

WITH cte AS (
SELECT c.first_name, c.last_name, c.email, ri.rental_count, tp.total_amount_per_customer
FROM customer c
JOIN rental_info ri ON c.customer_id = ri.customer_id
JOIN total_paid tp ON c.customer_id = tp.customer_id
)
SELECT * FROM cte;

WITH cte AS (
SELECT c.first_name, c.last_name, c.email, ri.rental_count, tp.total_amount_per_customer
FROM customer c
JOIN rental_info ri ON c.customer_id = ri.customer_id
JOIN total_paid tp ON c.customer_id = tp.customer_id
)
SELECT *, (total_amount_per_customer / rental_count) AS average_payment_per_rental
FROM cte
ORDER BY average_payment_per_rental DESC