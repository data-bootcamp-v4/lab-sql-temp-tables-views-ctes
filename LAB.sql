-- CREATING A CUSTOMER SUMMARY REPORT

USE sakila;
-- Step 1: Create a view

CREATE VIEW customer_view AS
SELECT c.customer_id, CONCAT( c.first_name,' ', c.last_name) AS customer_name
				,c.email, COUNT(r.customer_id) as rental_count
FROM customer c
LEFT JOIN rental as r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- DROP VIEW customer_view;
-- Step 2: Create a Temporary Table 
CREATE TEMPORARY TABLE total_paid AS
SELECT c.customer_id, c.customer_name, sum(p.amount) as total_paid
FROM customer_view c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

SELECT * FROM total_paid;

-- DROP temporary table total_paid;

-- Step 3: Create a CTE and the Customer Summary Report 

WITH customer_information AS (
		SELECT c.customer_name, c.email, c.rental_count, t.total_paid
		FROM customer_view c
		INNER JOIN total_paid t
		ON c.customer_id = t.customer_id)
        
SELECT customer_name, email, rental_count, total_paid, 
		CASE 
        WHEN rental_count > 0 THEN ROUND(total_paid/rental_count,2)
        ELSE 0
        END AS average_payment_per_rental

FROM customer_information
ORDER BY rental_count DESC;



