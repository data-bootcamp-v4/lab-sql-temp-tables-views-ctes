/* Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
including their rental history and payment details. 
The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View 

First, create a view that summarizes rental information for each customer.
 The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/
 
USE sakila;

CREATE VIEW rental_information as
SELECT rental.customer_id, fullname, count(rental_id) as rentals,  email
FROM rental
INNER JOIN (
		SELECT concat(first_name, " ",last_name) as fullname, customer_id, email
		FROM customer) c
ON rental.customer_id = c.customer_id
GROUP BY rental.customer_id;

SELECT *
FROM rental_information;


/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
and calculate the total amount paid by each customer. */

CREATE TEMPORARY TABLE customer_info(
SELECT ri.customer_id, fullname, sum(amount) as total_paid,  rentals, email
FROM rental_information as ri
INNER JOIN payment
ON ri.customer_id = payment.customer_id
GROUP BY payment.customer_id);



/* Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
this last column is a derived column from total_paid and rental_count. */


#customer name, email, rental_count, total_paid and average_payment_per_rental
#this last column is a derived column from total_paid and rental_count.

WITH final as (
	SELECT ci.customer_id, ci.fullname, ci.email, ci.rentals, total_paid, total_paid/ci.rentals as average_payment_per_rental
	FROM customer_info as ci
	INNER JOIN rental_information as ri
	ON ci.customer_id = ri.customer_id
    )
    
SELECT *
FROM final;




