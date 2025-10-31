USE sakila;

-- Step 1. Create a View

-- This view summarizes rental information for each customer, including their name, 
-- email, and the total number of rentals they have made.
CREATE OR REPLACE VIEW customer_rental_summary AS 
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
	customer c
JOIN
	rental r ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id, c.first_name, c.last_name, c.email;
    
SELECT * FROM customer_rental_summary LIMIT 10;
 
 
-- Step 2. Create a Temporary Table

-- This table calculates the total amount paid by each customer by joining the 
-- customer_rental_summary View (from Step 1) with the payment table.

CREATE TEMPORARY TABLE customer_payment_summary (
	customer_id SMALLINT UNSIGNED,
    total_paid DECIMAL(5, 2)
);

-- Insert data into the temporary table

INSERT INTO customer_payment_summary (customer_id, total_paid)
SELECT
	crs.customer_id,
    SUM(P.amount) AS total_paid
FROM
	customer_rental_summary crs
JOIN
	payment p ON crs.customer_id = p.customer_id
GROUP BY 
	crs.customer_id;
    
SELECT * FROM customer_payment_summary LIMIT 10;

-- Step 3. Create a CTE and the Customer Summary Report

-- Define a CTE that joins the rental summary View and the payment summary Temporary Table.
WITH Customer_Summary_CTE AS (
	SELECT
		crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
	FROM
		customer_rental_summary crs
	JOIN
		customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
        
-- Use the CTE to generate the final report with the dervied column.
SELECT 
	first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM
	Customer_Summary_CTE
order by
	last_name, first_name;