USE sakila

-- CHALLENGE

	-- Creating a Customer Summary Report
    -- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
    -- The report will be generated using a combination of views, CTEs, and temporary tables.
		-- Step 1: Create a View
			-- First, create a view that summarizes rental information for each customer. 
            -- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
		-- Step 2: Create a Temporary Table
			-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
            -- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
		-- Step 3: Create a CTE and the Customer Summary Report
			-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
            -- The CTE should include the customer's name, email address, rental count, and total amount paid.
            -- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
            -- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
            
            
CREATE OR REPLACE VIEW customer_rental_information AS 
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, COUNT(rental.rental_id) AS rental_count
FROM customer
INNER JOIN rental
ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY rental_count DESC;


CREATE TEMPORARY TABLE tot_amount_paid AS
SELECT customer_rental_information.customer_id, customer_rental_information.first_name, customer_rental_information.last_name, customer_rental_information.email, SUM(payment.amount) AS total_paid
FROM customer_rental_information
INNER JOIN payment
ON customer_rental_information.customer_id = payment.customer_id
GROUP BY customer_rental_information.customer_id;


WITH customer_summary AS (
SELECT customer_rental_information.first_name, customer_rental_information.last_name, customer_rental_information.email, customer_rental_information.rental_count, tot_amount_paid.total_paid
FROM customer_rental_information
INNER JOIN tot_amount_paid
ON customer_rental_information.customer_id = tot_amount_paid.customer_id)
SELECT first_name, last_name, email, rental_count, total_paid, total_paid / rental_count AS average_payment_per_rental
FROM customer_summary;