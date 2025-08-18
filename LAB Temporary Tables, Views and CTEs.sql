USE sakila;

# Step 1: Create a View:
# That summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_info AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS total_rented
FROM customer c
INNER JOIN rental r
USING(customer_id)
GROUP BY customer_id;    #aggregation if group by

drop view rental_info;

SELECT * 
FROM rental_info;

# Step 2: Create a Temporary Table:
# That calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 
# to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid AS
SELECT SUM(amount) as total_payments, p.customer_id
FROM payment p
INNER JOIN rental_info
USING(customer_id)
GROUP BY p.customer_id;

drop table total_paid;

SELECT *
FROM total_paid;

# Step 3: Create a CTE and the Customer Summary Report:
# That joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary_report AS
	(SELECT rental_info.first_name, rental_info.last_name, rental_info.email, total_rented, total_payments
	 FROM rental_info 
     INNER JOIN total_paid
     USING(customer_id))
     SELECT * 
     FROM customer_summary_report;
     
    




# Step 4: Next, using the CTE, create the query to generate the final customer summary report, which should include: 
# customer name, email, rental_count, total_paid and average_payment_per_rental, 
# this last column is a derived column from total_paid and rental_count.

WITH customer_summary_report AS
	(SELECT rental_info.first_name, rental_info.last_name, rental_info.email, total_rented, total_payments, (total_payments/total_rented) as average_per_rental
	 FROM rental_info 
     INNER JOIN total_paid
     USING(customer_id))
     SELECT * 
     FROM customer_summary_report;