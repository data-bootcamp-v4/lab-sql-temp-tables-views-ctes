USE sakila;


/* STEP 1 */


CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT customer.customer_id, first_name, last_name, email, COUNT(rental.rental_id) AS rental_count
FROM customer
LEFT JOIN rental
    ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, first_name, last_name, email;


/* STEP 2 */

DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT customer_rental_summary.customer_id, COALESCE(SUM(payment.amount), 0) AS total_paid
FROM customer_rental_summary
LEFT JOIN payment
    ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;


/* STEP 3 */


WITH customer_summary AS (
SELECT CONCAT(first_name, ' ', last_name) AS customer_name, email, rental_count, total_paid 
FROM customer_rental_summary
LEFT JOIN customer_payment_summary
    ON customer_rental_summary.customer_id = customer_payment_summary.customer_id
)
SELECT customer_name, email, rental_count, total_paid, ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary;

