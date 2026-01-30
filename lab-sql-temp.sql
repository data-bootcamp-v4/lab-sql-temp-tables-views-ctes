USE sakila;

SELECT *
FROM payment;

CREATE VIEW customer_total AS
SELECT
c.customer_id, 
c.first_name,
c.last_name, 
c.email,
COUNT(rental_id) AS total_rentals
FROM customer AS c
JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name,
c.email;

SELECT * FROM sakila.customer_total;

CREATE TEMPORARY TABLE total_paid AS
SELECT
c.customer_id, 
c.first_name,
c.last_name, 
c.email,
COUNT(rental_id) AS total_rentals,
SUM(amount) AS total_amount
FROM customer_total AS c
JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY 
c.customer_id,
c.first_name,
c.last_name,
c.email;

SELECT * FROM sakila.total_paid;

WITH customer_summary AS (
    SELECT
        ct.first_name,
        ct.last_name,
        ct.email,
        ct.total_rentals,
        tp.total_amount
    FROM customer_total ct
    JOIN total_paid tp
      ON ct.customer_id = tp.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    total_rentals,
    total_amount,
    ROUND(total_amount / total_rentals, 2) AS avg_payment_per_rental
FROM customer_summary;
