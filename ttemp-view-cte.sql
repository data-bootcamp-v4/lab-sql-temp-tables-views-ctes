#Creating a Customer Summary Report
#In this exercise, you will create a customer summary report that summarizes key 
#information about customers in the Sakila database, including their rental history
#and payment details. The report will be generated using a combination of views, CTEs,
#and temporary tables.
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer.
#The view could include the customer's ID, name, email address,
#and total number of rentals (rental_count).
#CREATE VIEW customer_rent_info AS
SELECT customer_id, last_name, email, COUNT(rental_id) AS rental_count
FROM rental
JOIN customer
USING (customer_id)
GROUP BY customer_id;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by
#each customer (total_paid). The Temporary Table should use the rental summary
#view created in Step 1 to join with the payment table and calculate the total amount
#paid by each customer.
DROP TABLE IF EXISTS customer_total_paid;
CREATE TEMPORARY TABLE customer_total_paid AS
	SELECT customer_id, SUM(amount) AS total_paid
	FROM payment
	JOIN customer_rent_info
	USING (customer_id)
	GROUP BY customer_id;

#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary
#Temporary Table created in Step 2. The CTE should include the customer's name,
#email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report,
#which should include: customer name, email, rental_count, total_paid
#and average_payment_per_rental, this last column is a derived column from
#total_paid and rental_count.
WITH final_customer_summary_report AS (
										SELECT last_name, email, rental_count, total_paid
										FROM customer_rent_info as v
										JOIN customer_total_paid as tt
										USING (customer_id))
SELECT *, ROUND(total_paid/rental_count,2) AS average_payment_per_rental
FROM final_customer_summary_report;