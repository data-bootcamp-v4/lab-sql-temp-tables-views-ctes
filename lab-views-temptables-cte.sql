USE sakila;

SELECT * FROM customer;
SELECT * FROM rental;

SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;

CREATE OR REPLACE VIEW rental_information AS (
		WITH rentals AS (
			SELECT customer_id, COUNT(*) AS rental_count
			FROM rental
			GROUP BY customer_id)
	SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS name, c.email, r.rental_count
    FROM customer AS c
    JOIN rentals AS r ON c.customer_id = r.customer_id);
    
SELECT * FROM rental_information;


SELECT * FROM payment;

CREATE TEMPORARY TABLE customer_rental_payment_information
WITH total_paid AS (
	SELECT SUM(amount) AS total_amount_paid, customer_id
	FROM payment
	GROUP BY customer_id
    )
SELECT r.*, t.total_amount_paid
FROM rental_information AS r
JOIN total_paid AS t ON r.customer_id = t.customer_id;

SELECT * FROM customer_rental_payment_information;


SELECT crp.*, 
       (crp.total_amount_paid / crp.rental_count) AS average_payment_per_rental
FROM customer_rental_payment_information AS crp;
