USE sakila;
-- Challenge: Creating a Customer Summary Report
-- Create a customer summary report that summarizes key information about customers in the Sakila database,
-- including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.
-- Step 1: Create a View that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_rental_info AS (
SELECT customer_id,  concat(first_name, " ", last_name) AS name, email, count(rental_id) AS rental_count
FROM customer INNER JOIN rental USING (customer_id) GROUP BY customer_id ORDER BY customer_id ASC);
SELECT * FROM customer_rental_info;

-- Step 2: Create a Temporary Table that calculates the total amount paid by each customer (total_paid).
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
-- and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE customer_total_payment
SELECT cri.customer_id, SUM(amount) AS total_paid FROM payment AS p
INNER JOIN customer_rental_info AS cri USING (customer_id) GROUP BY cri.customer_id;
SELECT * FROM customer_total_payment;

-- Step 3: Create a CTE and the Customer Summary Report that joins the rental summary View
-- with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid. 
WITH cte_customer_total_payment AS (SELECT * FROM customer_rental_info 
	INNER JOIN customer_total_payment USING (customer_id))
SELECT * FROM cte_customer_total_payment;

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.
WITH cte_customer_total_payment AS (SELECT * FROM customer_rental_info 
	INNER JOIN customer_total_payment USING (customer_id))
SELECT *, (total_paid / NULLIF(rental_count, 0)) AS average_payment_per_rental FROM cte_customer_total_payment;
