-- LAB | Temporary Tables, Views and CTEs

-- Setting the working database 

USE Sakila; 

-- ========================================
-- Temporary Tables 
-- ========================================
-- A temporary table is a short-lived table that exists only for the duration of a session or a specific task within that session 

-- 1. Creating a temporary table to summarize rental information for each customer. 
-- The view includes the customer's ID, name, emailadress, total number of rentals (rental counts).

DROP VIEW IF EXISTS customer_summary;

CREATE VIEW customer_summary AS 
SELECT 	
		c.customer_id, 
		c.first_name, 
        c.last_name, 
        c.email,
        COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental as r ON r.customer_id = c.customer_id
GROUP by customer_id, c.first_name, c.last_name, c.email; 

-- 2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.

DROP TEMPORARY TABLE IF EXISTS total_paid; 
DROP TEMPORARY TABLE IF EXISTS customer_payments_summary; 

CREATE TEMPORARY TABLE customer_payments_summary AS 
SELECT 
	cs.customer_id, 
	cs.first_name, 
    cs.last_name, 
	cs.email, 
	cs.rental_count, 
	COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_summary as cs
LEFT JOIN payment AS p ON cs.customer_id = p.customer_id
GROUP BY cs.customer_id, cs.first_name, cs.last_name, cs.email, cs.rental_count;

-- 3. Create a CTE and the Customer Summary Report.
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

-- DROP TEMPORARY TABLE IF EXISTS customer_summary_report;

CREATE TEMPORARY TABLE customer_summary_report AS (
	SELECT 
		CONCAT(cps.first_name, ' ', cps.last_name) AS customer_name,
		cps.email,
		cps.rental_count,
		cps.total_paid,
		ROUND(
			CASE 
				WHEN cps.rental_count = 0 THEN 0 
				ELSE cps.total_paid / cps.rental_count 
			END, 2
		) AS average_payment_per_rental
	FROM customer_payments_summary AS cps
);
