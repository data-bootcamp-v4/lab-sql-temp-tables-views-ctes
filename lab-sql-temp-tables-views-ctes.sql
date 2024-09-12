/* Creating a Customer Summary Report*/

/* In this exercise, you will create a customer summary report that summarizes key information about customers 
in the Sakila database, including their rental history and payment details. The report will be generated using 
a combination of views, CTEs, and temporary tables.

/* Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's 
ID, name, email address, and total number of rentals (rental_count).*/

CREATE VIEW view_customer_rental AS
SELECT sakila.customer.customer_id, CONCAT(first_name, " ", last_name) AS full_name, email, total_rental
FROM sakila.customer
INNER JOIN (
	SELECT customer_id, COUNT(amount) AS total_rental
	FROM sakila.payment
	GROUP BY customer_id) AS cus_rent
ON sakila.customer.customer_id = cus_rent.customer_id;


SELECT * FROM view_customer_rental;

/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary
 Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total 
 amount paid by each customer.*/

CREATE TEMPORARY TABLE temp_customer_rental AS
SELECT sakila.customer.customer_id, CONCAT(first_name, " ", last_name) AS full_name, email, sum_rental
FROM sakila.customer
INNER JOIN (
	SELECT customer_id, SUM(amount) AS sum_rental
	FROM sakila.payment
	GROUP BY customer_id) AS cus_rent
ON sakila.customer.customer_id = cus_rent.customer_id;


SELECT * FROM temp_customer_rental;

/* Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.*/

WITH rental_cte AS (
					SELECT *
					FROM sakila.customer
					INNER JOIN (
						SELECT customer_id, SUM(amount) AS sum_rental
						FROM sakila.payment
						GROUP BY customer_id) AS cus_rent
					ON sakila.customer.customer_id = cus_rent.customer_id)
SELECT sakila.customer.customer_id, CONCAT(first_name, " ", last_name) AS full_name, email, sum_rental FROM rental_cte;


/* Next, using the CTE, create the query to generate the final customer summary report, which should include: customer
 name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from
 total_paid and rental_count.*/