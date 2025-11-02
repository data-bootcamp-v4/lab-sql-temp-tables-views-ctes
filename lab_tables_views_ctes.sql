USE sakila;

SELECT * FROM rental;
SELECT * FROM customer;

CREATE VIEW rental_information_final AS
SELECT c.customer_id, CONCAT(first_name, ' ', last_name) AS name, email, COUNT(rental_id) AS rental_count
FROM sakila.customer AS c
LEFT JOIN sakila.rental AS r               #Instead of the inner because if you use inner join any customer with 0 rentals disappears
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT * FROM rental_information_final;

#2
SELECT * FROM payment;

CREATE TEMPORARY TABLE total_amount_paid AS
SELECT rif.customer_id, name, email, rental_count, SUM(amount) AS total_paid
FROM rental_information_final AS rif
INNER JOIN sakila.payment AS p
ON rif.customer_id = p.customer_id
GROUP BY customer_id;

SELECT * FROM total_amount_paid;

#3
WITH customer_summary AS (
	SELECT rif.name, rif.email, rif.rental_count, total_paid
    FROM rental_information_final AS rif
    INNER JOIN total_amount_paid AS tap
    ON rif.name = tap.name
    )
SELECT name, email, rental_count, total_paid, ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary;

