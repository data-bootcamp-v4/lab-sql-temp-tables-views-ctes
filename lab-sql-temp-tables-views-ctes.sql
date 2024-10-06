USE sakila;

#Creating a Customer Summary Report
#In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
#The report will be generated using a combination of views, CTEs, and temporary tables.


#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_summary_info AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    c.email,
    (SELECT COUNT(r.rental_id)
     FROM rental AS r
     WHERE r.customer_id = c.customer_id) AS rental_count
FROM 
    customer AS c;

SELECT * FROM rental_summary_info;


#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE temp_total_amount_paid_customer_1 AS
SELECT rsi.name, SUM(p.amount) AS total_paid
FROM rental_summary_info AS rsi
INNER JOIN payment AS p
ON p.customer_id = rsi.customer_id
GROUP BY rsi.customer_id;

SELECT * FROM temp_total_amount_paid_customer_1;


#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

 WITH joint_summary AS (
	SELECT rsi.name, rsi.email, rsi.rental_count, tta.total_paid
	FROM rental_summary_info AS rsi
    INNER JOIN temp_total_amount_paid_customer_1 AS tta 
    ON rsi.name = tta.name)
    
SELECT name, email, rental_count, total_paid, (total_paid / rental_count) AS average_payment_per_rental
FROM joint_summary;

select * from temp_total_amount_paid_customer_1    
    


