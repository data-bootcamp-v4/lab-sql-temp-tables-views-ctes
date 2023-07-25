/* Create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, 
and total number of rentals (rental_count).*/

CREATE VIEW customer_rental_summary AS
SELECT customer.customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count
FROM customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, first_name, last_name, customer.email;


/* Next, create a Temporary Table that calculates the total amount paid by each 
customer (total_paid). The Temporary Table should use the rental summary view 
created in Step 1 to join with the payment table and calculate the total amount paid by each customer. */

CREATE TEMPORARY TABLE temp_total_paid AS
SELECT c.customer_id, first_name, last_name, email, rental_count, total_amount, SUM(amount) AS total_paid
FROM customer_rental_summary 
JOIN customer  ON customer_id = customer_id
LEFT JOIN payment  ON customer_id = customer_id
GROUP BY customer_id,first_name,last_name, email, rental_count, total_amount;



/* Create a CTE that joins the rental summary View with the customer payment summary 
Temporary Table created in Step 2. The CTE should include the customer's name, 
email address, rental count, and total amount paid. */

WITH rental_summary_view AS (
	SELECT customers_name, email, rental_count, total_amount_paid
    FROM temp_total_paid 
)






