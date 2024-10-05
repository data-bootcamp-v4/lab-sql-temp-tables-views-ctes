-- Challenge
USE sakila;
-- Creating a Customer Summary Report
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_summary AS(
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id);

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment table and calculate the total amount paid by each customer.


CREATE TEMPORARY TABLE total_paid_by_customer
SELECT r.customer_id, r.first_name, r.last_name, r.email, r.rental_count, SUM(p.amount) AS total_paid
FROM rental_summary AS r
LEFT JOIN payment AS p
ON r.customer_id = p.customer_id
GROUP BY r.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address,
-- rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and 
-- average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH cte_total_summary AS (
	SELECT r.customer_id, r.first_name, r.last_name, r.email, r.rental_count, SUM(p.amount) AS total_paid
	FROM rental_summary AS r
	LEFT JOIN payment AS p
	ON r.customer_id = p.customer_id
	GROUP BY r.customer_id
)
SELECT *, total_paid/rental_count AS average_payment_per_rental
FROM cte_total_summary;


