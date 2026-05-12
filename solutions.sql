USE sakila;

-- Step 1: Create a View
DROP VIEW IF EXISTS customer_rental_summary;

CREATE VIEW customer_rental_summary AS
SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

-- Step 2: Create a Temporary Table
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
	crs.customer_id,
	SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p
	ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report
/*
Create a CTE that joins the rental summary View with the customer payment summary 
Temporary Table created in Step 2. The CTE should include the customer's name, 
email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report,
 which should include: customer name, email, rental_count, total_paid and 
 average_payment_per_rental, this last column is a derived column from total_paid 
 and rental_count.
*/

WITH customer_summary AS(
	SELECT 
		crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary crs
    LEFT JOIN customer_payment_summary cps
		ON crs.customer_id = cps.customer_id
)                   

SELECT
	customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid/rental_count,2) AS average_payment_per_rental
FROM customer_summary
ORDER BY customer_name;
