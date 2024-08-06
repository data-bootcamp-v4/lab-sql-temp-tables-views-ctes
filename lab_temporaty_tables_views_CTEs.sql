#Creating a Customer Summary Report

#In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history
#and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, 
#and total number of rentals(rental_count).

CREATE VIEW customer_info AS
SELECT c.customer_id, first_name, last_name, email,  count(rental_id) AS rental_count
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
GROUP BY customer_id;

#Step 2: Create a Temporary Table
	#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
	#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE top_customers AS
SELECT p.customer_id , concat(first_name, " " ,last_name ) AS customer_name , SUM(amount) AS paid_amount
FROM payment p
JOIN customer_info ci
ON ci.customer_id = p.customer_id
group by p.customer_id
ORDER BY paid_amount DESC;


#Step 3: Create a CTE and the Customer Summary Report

#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's 
#name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email,
# rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH cte_customer AS (
	SELECT customer_name, email,rental_count, paid_amount
    FROM customer_info ci
    JOIN top_customers tc
    ON Ci.customer_id = tc.customer_id)
    
    SELECT customer_name, email,rental_count, paid_amount FROM cte_customer;
    