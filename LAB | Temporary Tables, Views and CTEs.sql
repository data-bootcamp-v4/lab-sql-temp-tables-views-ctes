#Step 1: Create a View
# First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_per_customer AS 
SELECT customer_id, CONCAT(first_name," ",last_name) AS "Name", email, COUNT(rental_id) AS num_counts
FROM customer
JOIN rental
USING (customer_id)
GROUP BY customer_id;

SELECT *
FROM rental_per_customer;

# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 to join with 
#the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid_customer AS (
SELECT customer_id, SUM(amount) AS total_paid
FROM rental_per_customer
INNER JOIN payment
USING (customer_id)
GROUP BY customer_id);

SELECT *
FROM total_paid_customer;

# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.
# Next, using the CTE, create the query to generate the final customer summary report, 
# which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


# this yes
WITH average_payment AS(
		SELECT *
			FROM rental_per_customer AS v
			INNER JOIN total_paid_customer AS t
			USING (customer_id))
SELECT * 
FROM average_payment;


WITH average_payment AS(
		SELECT *
			FROM rental_per_customer AS v
			INNER JOIN total_paid_customer AS t
			USING (customer_id))
SELECT *, round(total_paid/num_counts,2) AS avg_payment
FROM average_payment;

# the join:
SELECT *
FROM rental_per_customer AS v
INNER JOIN total_paid_customer AS t
USING (customer_id);
