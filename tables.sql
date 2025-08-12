-- Step 1
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count)
DROP VIEW IF EXISTS customer_info;
CREATE VIEW customer_info AS
SELECT c.customer_id AS customer_id, c.first_name AS first_name,c.last_name AS last_name, c.email AS email, COUNT(r.rental_id) AS rental_count FROM customer AS c
JOIN rental AS r
ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name,c.last_name, c.email
;

SELECT * FROM customer_info;

-- STEP 2
-- Temporary Table that calculates the total amount paid by each customer (total_paid)
DROP TABLE IF EXISTS total_paid;

CREATE TEMPORARY TABLE total_paid 
SELECT ci.customer_id, ci.first_name, ci.last_name, ci.email, ci.rental_count , SUM(amount) AS total_paid FROM customer_info AS ci
JOIN payment AS p
ON p.customer_id = ci.customer_id
GROUP BY ci.customer_id, ci.first_name, ci.last_name, ci.email, ci.rental_count;

SELECT * FROM total_paid;

-- STEP 3

WITH cte_summary AS (
SELECT *, (total_paid/ rental_count) AS average_payment_per_rental FROM total_paid ) 
SELECT * FROM cte_summary;
