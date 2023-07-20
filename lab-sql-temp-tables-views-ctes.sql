/*
Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers 
in the Sakila database, including their rental history and payment details. 
The report will be generated using a combination of views, CTEs, and temporary tables.
*/

/*
    Step 1: Create a View

First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
*/

SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS full_name, email, f.total_rentals
FROM sakila.customer
INNER JOIN (
	SELECT customer_id, COUNT(rental_id) AS total_rentals
	FROM sakila.rental
	GROUP BY customer_id
	) AS f
ON customer.customer_id = f.customer_id;

CREATE VIEW sakila.rental_info AS
SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS full_name, email, f.total_rentals
FROM sakila.customer
INNER JOIN (
	SELECT customer_id, COUNT(rental_id) AS total_rentals
	FROM sakila.rental
	GROUP BY customer_id
	) AS f
ON customer.customer_id = f.customer_id;

/*
    Step 2: Create a Temporary Table

Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
and calculate the total amount paid by each customer.
*/

SELECT *
FROM sakila.rental_info;

CREATE TEMPORARY TABLE sakila.customer_payment_summary
SELECT payment.customer_id, rental_info.full_name, SUM(payment.amount) AS total_spent, rental_info.total_rentals
FROM sakila.payment
INNER JOIN sakila.rental_info
ON payment.customer_id = rental_info.customer_id
GROUP BY payment.customer_id;

/*
    Step 3: Create a CTE and the Customer Summary Report

Create a CTE that joins the rental summary View with the customer payment summary 
Temporary Table created in Step 2. The CTE should include the customer's name, email address, 
rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, 
which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
this last column is a derived column from total_paid and rental_count.
*/

WITH
	cte1 AS (SELECT * FROM sakila.rental_info),
    cte2 AS (SELECT * FROM sakila.customer_payment_summary)
SELECT cte1.full_name, cte1.email, cte1.total_rentals, cte2.total_spent, cte2.total_spent/cte1.total_rentals AS avg_spent_per_rental
FROM cte1 JOIN cte2
WHERE cte1.customer_id = cte2.customer_id;