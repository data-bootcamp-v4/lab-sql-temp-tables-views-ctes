USE sakila;
DROP VIEW customer_summary;

CREATE VIEW rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) as customer_name, c.email, COUNT(r.rental_id) as total_rental
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY 1,2,3
;
SELECT * FROM rental_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT r.customer_id, r.customer_name, r.email, r.total_rental, SUM(p.amount) as total_payment
FROM rental_summary r
JOIN payment p
ON r.customer_id = p.customer_id
GROUP BY 1,2,3
;

SELECT * FROM customer_payment_summary;

WITH cte_customer AS(
SELECT * FROM customer_payment_summary)

SELECT customer_id, customer_name, email, total_rental, total_payment, ROUND(total_payment/total_rental,2) as avg_payment_per_rental
FROM cte_customer;





