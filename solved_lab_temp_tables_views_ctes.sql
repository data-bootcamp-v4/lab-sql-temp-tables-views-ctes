USE sakila;

-- 1
SELECT * FROM customer;
SELECT * FROM rental;

CREATE VIEW customer_rental_summary AS 
SELECT 	c.customer_id, 
		c.first_name, 
		c.last_name, 
        c.email, 
        COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM customer_rental_summary;

-- 2
SELECT * FROM payment;
SELECT * FROM customer_rental_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 	c.customer_id, 
		SUM(p.amount) AS total_paid
FROM customer_rental_summary AS c
LEFT JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

SELECT * FROM customer_payment_summary;

-- 3
SELECT * FROM customer_payment_summary;
SELECT * FROM customer_rental_summary;

WITH customer_summary AS (
SELECT 	c.customer_id, 
		c.first_name, 
        c.last_name, 
        c.email, 
        c.rental_count,
        p.total_paid
FROM customer_rental_summary AS c
LEFT JOIN customer_payment_summary AS p
ON c.customer_id = p.customer_id
)

SELECT 	customer_id,
		first_name,
        last_name,
        email,
        rental_count,
        total_paid,
        ROUND(total_paid / rental_count, 2) AS avg_payment_per_rental
FROM customer_summary;









