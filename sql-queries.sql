USE sakila;

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

DROP VIEW customer_view;
CREATE VIEW customer_view AS
SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS name, customer.email, COUNT(rental.rental_id) AS rental_count
	FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    GROUP BY rental.customer_id;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid_table AS
	SELECT customer_view.*, SUM(payment.amount) AS total_paid
	FROM customer_view
    JOIN payment ON customer_view.customer_id = payment.customer_id
    GROUP BY customer_view.customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
SELECT name, email, rental_count, total_paid FROM total_paid_table;

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH customer_cte AS
	(SELECT name, email, rental_count, total_paid FROM total_paid_table)
    SELECT *, ROUND(total_paid/rental_count, 1) AS average_payment FROM customer_cte;
