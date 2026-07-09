-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
USE sakila;


CREATE VIEW view_rental_sum AS 
	SELECT c.customer_id, CONCAT(first_name, " ", last_name) AS customer_name, email, COUNT(rental_id) AS rental_count
	FROM customer AS c
	LEFT JOIN rental AS r
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id;
    
-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
-- calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_total_paid AS 
	SELECT v.customer_id,
		   v.customer_name,
           SUM(p.amount) AS total_paid
	FROM payment AS p
    JOIN view_rental_sum AS v
    ON v.customer_id = p.customer_id
    GROUP BY v.customer_id, v.customer_name;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_cust_review AS (
    SELECT v.customer_name,
           v.email,
           v.rental_count,
           t.total_paid
    FROM view_rental_sum AS v
    JOIN temp_total_paid AS t
    ON t.customer_id = v.customer_id
)
SELECT *
FROM cte_cust_review;


-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived 
-- column from total_paid and rental_count.


WITH cte_cust_review AS (
    SELECT v.customer_name,
           v.email,
           v.rental_count,
           t.total_paid
    FROM view_rental_sum AS v
    JOIN temp_total_paid AS t
    ON t.customer_id = v.customer_id
)
SELECT *, ROUND(total_paid/rental_count,2) AS average_payment_per_rental
FROM cte_cust_review;