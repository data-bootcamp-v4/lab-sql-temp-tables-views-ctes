USE sakila;
#Creating a Customer Summary Report
#In this exercise, you will create a customer summary report that summarizes key 
#information about customers in the Sakila database, including their rental history and payment details. 
#The report will be generated using a combination of views, CTEs, and temporary tables.

# Step 1: Create a View
# First, create a view that summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info_of_customer AS
	SELECT customer_id, first_name, email, COUNT(rental_id) AS rental_count
    FROM customer
    LEFT JOIN rental
    USING(customer_id)
    GROUP BY customer_id,first_name, email;
    
SELECT * FROM rental_info_of_customer;   
 
# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment 
# table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid_by_customer AS
	   SELECT customer_id, SUM(amount) AS total_paid
       FROM payment
	   INNER JOIN rental_info_of_customer
       USING(customer_id)
       GROUP BY customer_id;
       
SELECT * FROM total_paid_by_customer;
    
# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary
# Temporary Table created in Step 2. The CTE should include the customer's name, email address, 
# rental count, and total amount paid.
# Next, using the CTE, create the query to generate the final customer summary report, 
# which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
# this last column is a derived column from total_paid and rental_count.    
WITH customer_summary AS ( 
                          SELECT c.customer_id,c.first_name,c.email,
                          COUNT(r.rental_id) AS rental_count, 
                          SUM(p.amount) AS total_paid
						  FROM customer c
						  LEFT JOIN rental r 
                          ON c.customer_id = r.customer_id  
                          LEFT JOIN payment p 
                          ON c.customer_id = p.customer_id  
                          GROUP BY c.customer_id, c.first_name, c.email 
)

SELECT cs.first_name, cs.email, cs.rental_count, cs.total_paid,
    CASE 
        WHEN cs.rental_count > 0 THEN cs.total_paid / cs.rental_count
        ELSE 0 
    END AS average_payment_per_rental
FROM 
    customer_summary cs;
