#Challenge
Use sakila;
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

DROP VIEW if exists view_rental_customer;

CREATE VIEW view_rental_customer as 
SELECT c.customer_id, c.first_name, c.email, COUNT(rental.customer_id) as count_rental
FROM rental 
JOIN customer as c
ON rental.customer_id = c.customer_id
GROUP BY c.customer_id;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
#and calculate the total amount paid by each customer.

SELECT *
FROM view_rental_customer as view1
JOIN payment 
ON view1.customer_id = payment.customer_id
JOIN temp_total_paid_customer as temporal
ON temporal.customer_id = payment.customer_id
;

SELECT * FROM view_rental_customer;

CREATE TEMPORARY TABLE temp_total_paid_customer( 
SELECT customer_id, SUM(amount) as suma_amount
FROM payment
GROUP BY customer_id);

#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.


WITH cte_CSR as 
(
	SELECT view2.first_name, view2.email, count_rental, temporal2.suma_amount
	FROM view_rental_customer AS view2
	JOIN temp_total_paid_customer as temporal2
	ON view2.customer_id = temporal2.customer_id
)

SELECT * FROM cte_CSR;

#Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH cte_CSR as 
(
	SELECT view2.first_name, view2.email, count_rental, temporal2.suma_amount, temporal2.suma_amount/view2.count_rental as avg_payment_per_rental
	FROM view_rental_customer AS view2
	JOIN temp_total_paid_customer as temporal2
	ON view2.customer_id = temporal2.customer_id
)

SELECT * FROM  cte_CSR;

