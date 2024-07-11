#LAB | Temporary Tables, Views and CTEs
#**Creating a Customer Summary Report**

#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
USE Sakila;


CREATE VIEW tot_no_rent AS(
SELECT first_name,last_name,email, customer_id,count(rental_id) As Rental_count
FROM rental
INNER JOIN customer
using (customer_id)
GRoup by customer_id, first_name,last_name,email);
    
select * from tot_no_rent;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

DROP TEMPORARY TABLE customer_total_paid_New;
CREATE TEMPORARY TABLE customer_total_paid_New AS(
SELECT customer_id,sum(amount) AS total_paid
FROM customer
INNER JOIN payment 
USING (customer_id)
GROUP BY customer_id);

select * from customer_total_paid;

#Step 3: Create a CTE and the Customer Summary Report

#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in 
#Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid

WITH Customer_Summary_Report AS(
	SELECT first_name,last_name,email, customer_id,Rental_count,total_paid
	FROM tot_no_rent
INNER JOIN customer_total_paid_New
USING (customer_id))

SELECT first_name,last_name,email, customer_id,Rental_count,total_paid,
round((total_paid/Rental_count),2) AS average_payment_per_rental
FROM Customer_Summary_Report;



