USE sakila;

####### Step 1: Create a View
# First, create a view that summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

DROP VIEW IF EXISTS rentals_pc;

/*
CREATE VIEW rental_summary AS
SELECT C.customer_id, C.last_name, C.first_name, C.email, COUNT(R.rental_id) AS rental_count
FROM customer AS C
JOIN rental AS R
USING (customer_id)
GROUP BY customer_id;   */


######### Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount 
# paid by each customer.

#cust_payment_summary
/*CREATE TEMPORARY TABLE payment_summary AS
SELECT customer_id, SUM(amount) AS total_paid
FROM payment
JOIN rental_summary
USING (customer_id)
GROUP BY customer_id; */

# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include 
# the customer's name, email address, rental count, and total amount paid.
####
# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, 
# rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH customer_summary AS
			(SELECT RS.customer_id, RS.last_name, RS.first_name, RS.email, RS.rental_count, PS.total_paid
			FROM rental_summary AS RS
			JOIN payment_summary AS PS
			USING (customer_id))

            
SELECT last_name, first_name, email, rental_count, total_paid, total_paid/rental_count AS avg_per_rental
FROM customer_summary;



 

