

USE sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

DROP VIEW IF EXISTS sum_rental_info;

CREATE VIEW sum_rental_info AS 
SELECT s.customer_id, s.first_name,s.last_name, s.email, s.rental_count FROM
( SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.customer_id) as rental_count from sakila.customer as c
JOIN sakila.rental as r
ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER by rental_count DESC) as s;

SELECT * from sum_rental_info;

-- step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.


CREATE TEMPORARY TABLE IF NOT EXISTS sakila.total_paid
SELECT customer_id, SUM(amount) AS total_paid
FROM sakila.payment
GROUP by customer_id
ORDER BY total_paid;


SELECT s.customer_id,s.first_name,s.last_name, s.email ,s.rental_count, t.total_paid from sum_rental_info as s
JOIN total_paid as t
ON s.customer_id = t.customer_id
ORDER by total_paid DESC;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_rental_cust AS (
SELECT s.customer_id,s.first_name,s.last_name, s.email ,s.rental_count, tp.total_paid from sum_rental_info as s
JOIN sakila.total_paid as tp
ON s.customer_id = tp.customer_id

)
SELECT 
	* 
FROM cte_rental_cust
ORDER BY total_paid DESC;


SELECT s.customer_id,s.first_name,s.last_name, s.email ,s.rental_count, tp.total_paid from cte_rental_cust;
