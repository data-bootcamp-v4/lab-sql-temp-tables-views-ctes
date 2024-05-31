/*
Challenge
Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.



Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
*/


/* Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
*/

ALTER VIEW summary_rental_info AS
    SELECT 
        customer.customer_id,
        customer.first_name,
        customer.last_name,
        customer.email,
        COUNT(rental.customer_id) as total_rentals
    FROM
        sakila.customer
	JOIN
        rental ON customer.customer_id = rental.customer_id
    GROUP BY customer_id
;

select * from summary_rental_info;

/* 
Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
*/

create temporary table total_paid_customer as
select
	summary_rental_info.cutomer_id ,
    sum(payment.amount) as total
from
	summary_rental_info
join
	sakila.payment on summary_rental_info.customer_id = payment.customer_id
group by customer_id
;

select * from total_paid_customer;

/*
Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
*/

create 
