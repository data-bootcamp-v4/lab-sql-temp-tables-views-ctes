USE sakila;

CREATE VIEW view_rentals AS
SELECT customer_id, CONCAT(first_name, " ", last_name) as full_name, email, COUNT(rental.rental_id) as rental_count
FROM rental
JOIN customer
USING(customer_id)
GROUP BY customer_id;

SELECT *
FROM view_rentals;

CREATE TEMPORARY TABLE temp_total_paid AS
SELECT *
FROM view_rentals
JOIN payment
USING(customer_id);

SELECT full_name, email, rented, SUM(amount)
FROM temp_total_paid
GROUP BY full_name, email, rented;

WITH cte_final AS (
	SELECT full_name, email, rented, SUM(amount) AS total_amount
    FROM temp_total_paid
    GROUP BY full_name, email, rented
)
SELECT *, ROUND(total_amount/rented,2) AS avg_payment_per_rental
FROM cte_final
