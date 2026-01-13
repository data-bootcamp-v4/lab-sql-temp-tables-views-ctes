-- In this exercise, you will create a customer summary report that summarizes 
-- key information about customers in the Sakila database, including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_info_per_customer AS
SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count
FROM customer
INNER JOIN rental USING(customer_id)
GROUP BY customer_id;



-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_spent AS
SELECT customer_id, first_name, last_name, SUM(amount) AS total_paid
FROM rental_info_per_customer
INNER JOIN payment USING(customer_id)
GROUP BY customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
WITH customer_summary_report AS (
	SELECT rpc.first_name, rpc.last_name, rpc.email, rental_count, total_paid
	FROM total_spent
	INNER JOIN rental_info_per_customer AS rpc USING(customer_id)
)
-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.
SELECT *, total_paid/rental_count AS average_payment_per_rental
FROM customer_summary_report;