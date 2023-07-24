# First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

					CREATE VIEW rental_info AS 
					SELECT customer.customer_id, first_name, last_name, email, rental_count
					FROM sakila.customer
					INNER JOIN
                        (SELECT customer_id, COUNT(*) As rental_count
                        FROM sakila.rental
                        GROUP BY customer_id) rental_count
					ON sakila.customer.customer_id = rental_count.customer_id;
                    
                    
                    
# 2. Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment 
#table and calculate the total amount paid by each customer.

					CREATE TEMPORARY TABLE sakila.customer_total
					SELECT customer.customer_id, first_name, last_name, email, total
					FROM sakila.customer
					INNER JOIN
						(SELECT customer_id, SUM(amount) AS total
						FROM sakila.payment
						GROUP BY customer_id) total_paid
					ON sakila.customer.customer_id = total_paid.customer_id;
			
            SELECT*
            FROM sakila.customer_total;
            
#  3. Create a CTE that joins the rental summary View with the customer payment summary 
#Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, 
#and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a 
#derived column from total_paid and rental_count.


 
                
		WITH customer_summary AS (
			SELECT customer_total.customer_id, first_name, last_name, email, total, total_rental, total/total_rental
			FROM sakila.customer_total
            INNER JOIN
				(SELECT customer_id, COUNT(*) AS total_rental
				FROM sakila.rental
				GROUP BY customer_id) rental_count
			ON sakila.customer_total.customer_id = rental_count.customer_id)
            
            SELECT*
            FROM customer_summary;




  

