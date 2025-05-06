use sakila;

#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_summaries AS
SELECT 
    c.customer_id, 
    concat(c.first_name," ", 
    c.last_name) as name , 
    c.email, 
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

select * from rental_summaries;
    
#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
drop table total_paid;
create temporary table total_paid as
	select rental_summaries.* , sum(amount) as total_amount
    from payment
	INNER JOIN rental_summaries
    USING(customer_id)
	group by customer_id;
    
SELECT * FROM total_paid;


#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 
WITH report AS (
    SELECT total_paid.*
    FROM total_paid
    INNER JOIN rental_summaries
    USING(customer_id)
)
SELECT * FROM report;


#2. The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include:
# customer name, email, rental_count, total_paid and average_payment_per_rental,
# this last column is a derived column from total_paid and rental_count.
WITH report AS (
    SELECT total_paid.*, total_amount/ total_paid.rental_count as average_payment_per_rental
    FROM total_paid
    INNER JOIN rental_summaries
    USING(customer_id)
)
SELECT * FROM report;

