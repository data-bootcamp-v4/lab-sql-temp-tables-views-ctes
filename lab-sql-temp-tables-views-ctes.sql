USE sakila;
SHOW TABLES;

-- Step 1
CREATE VIEW customer_rentals AS SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(*) AS number_of_rentals
FROM payment p
JOIN customer c
ON c.customer_id = p.customer_id
GROUP BY customer_id;

-- Step 2
CREATE TEMPORARY TABLE customer_payments AS
SELECT cr.*, SUM(amount) AS total_paid 
FROM customer_rentals cr
JOIN payment p
ON cr.customer_id = p.customer_id 
GROUP BY customer_id;

SELECT * FROM customer_payments;

-- Step 3
WITH customer_info AS 
		(SELECT *, total_paid/number_of_rentals AS average_payment
			FROM customer_payments)
            SELECT * FROM customer_info;