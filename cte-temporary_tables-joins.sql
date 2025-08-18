USE sakila;

#Step 1 : Create a View
#First, create a view that summarizes rental information for each customer. The view should include:
# the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info AS
SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer_id, first_name, last_name, email;

SELECT *
FROM rental_info;

# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use 
# the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.



CREATE TEMPORARY TABLE customer_payment AS
SELECT customer_id, first_name, last_name, SUM(amount) as total_paid
FROM payment
INNER JOIN rental_info
USING (customer_id)
GROUP BY customer_id, first_name, last_name;

select * from customer_payment;

#Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.
# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, 
# total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


WITH customer_summary_report AS (
	SELECT customer_payment.first_name, customer_payment.last_name, rental_info.email, rental_count, total_paid
    FROM rental_info
    INNER JOIN customer_payment
    USING (customer_id))
SELECT *, total_paid/rental_count as average_payment_per_rental
FROM customer_summary_report;

