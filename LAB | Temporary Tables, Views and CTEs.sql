use sakila;
# In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history 
# and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

# Step 1: Create a View
# First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals 
# (rental_count).

DROP VIEW rental_summary AS;
CREATE VIEW rental_summary AS
SELECT customer_id, first_name, last_name, email, count(rental_id)
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer_id;

select * from rental_summary;

# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view 
# created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

DROP TEMPORARY TABLE total_amount;
CREATE TEMPORARY TABLE total_amount (
								SELECT rental_summary.customer_id, sum(amount)
								FROM rental_summary
                                INNER JOIN payment
                                on payment.customer_id = rental_summary.customer_id
								GROUP BY rental_summary.customer_id);
select * from total_amount;

# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, 
# email address, rental count, and total amount paid.

WITH customer_summary AS (
	    SELECT
        rental_summary.customer_id,
        rental_summary.first_name,
        rental_summary.last_name,
        rental_summary.email,
        rental_summary.rental_count,
        total_amount.total_paid
    FROM
        rental_summary
    INNER JOIN
        total_amount ON rental_summary.customer_id = total_amount.customer_id)


SELECT
    customer_id,
    first_name,
    last_name,
    email,
    rental_count,
    total_paid
FROM
    customer_summary; 
