USE sakila;

CREATE VIEW view_rental_count AS
SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS customer_name, email, COUNT(rental_id) AS rental_count
FROM customer JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

CREATE TEMPORARY TABLE temp_total_paid AS
SELECT r.customer_id, SUM(p.amount) AS total_paid
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY r.customer_id;

WITH cte_summary_report AS (
SELECT v.customer_id, v.first_name, v.last_name, v.email, v.rental_count, t.total_paid
FROM view_rental_count v
JOIN temp_total_paid t ON v.customer_id = t.customer_id)
SELECT 
  customer_id, 
  CONCAT(first_name, ' ', last_name) AS customer_name, 
  email, 
  rental_count, 
  total_paid, 
  total_paid / rental_count AS average_payment_per_rental
FROM cte_summary_report;



