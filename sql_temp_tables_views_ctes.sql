# First, create a create view that summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_count AS
			SELECT customer_id, last_name, email, count(rental_id) AS rental_count
			FROM customer
			INNER JOIN rental
			USING(customer_id)
			GROUP BY customer_id;

SELECT * FROM rental_count;

# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 
# to join with the payment table and calculate the total amount paid by each customer.
DROP TABLE IF EXISTS total_pai;
CREATE TEMPORARY TABLE total_pai AS
			SELECT customer_id, last_name, email, SUM(amount) AS total_pai
            FROM payment
			INNER JOIN rental_count
			USING(customer_id)
			GROUP BY customer_id;

SELECT * FROM total_pai;

# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.
#WITH summary AS (SELECT *
				#FROM rental_count
				#INNER JOIN total_pai
				#USING(customer_id))

# Next, using the CTE, create the query to generate the final customer summary report, which should include: 
# customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH summary AS (SELECT *
				FROM rental_count
				INNER JOIN total_pai
				USING(customer_id))
SELECT customer_id, last_name, email, total_pai, rental_count, total_pai/rental_count AS average_payment_per_rental
FROM summary;
