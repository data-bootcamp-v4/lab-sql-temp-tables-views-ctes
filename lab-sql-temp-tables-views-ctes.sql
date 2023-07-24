/* Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/

CREATE VIEW rental_info_per_customer AS
SELECT sakila.customer.customer_id, sakila.customer.first_name, sakila.customer.email, COUNT(sakila.rental.rental_id) AS rental_count
FROM sakila.customer, sakila.rental
WHERE sakila.customer.customer_id = sakila.rental.customer_id
GROUP BY sakila.customer.customer_id, sakila.customer.first_name, sakila.customer.email;


/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
calculate the total amount paid by each customer.*/

CREATE TEMPORARY TABLE IF NOT EXISTS sakila.temporary_table
SELECT customer_id, SUM(amount) AS total_paid, ROUND(AVG(payment.amount), 2) AS average_payment_per_rental
FROM sakila.payment
GROUP BY customer_id;

/* Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
The CTE should include the customer's name, email address, rental count, and total amount paid.
Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid 
and rental_count.*/
    
WITH rental_summary AS 
(SELECT sakila.rental_info_per_customer.*, sakila.temporary_table.total_paid, sakila.temporary_table.average_payment_per_rental
 FROM sakila.temporary_table
 INNER JOIN sakila.rental_info_per_customer
 ON sakila.temporary_table.customer_id = sakila.rental_info_per_customer.customer_id)
SELECT *
FROM rental_summary;