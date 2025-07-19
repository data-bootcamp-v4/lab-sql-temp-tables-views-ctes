/*Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
including their rental history and payment details. 
The report will be generated using a combination of views, CTEs, and temporary tables.*/
use sakila;
/*Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/
drop view cm_rental_info;

CREATE VIEW cm_rental_info AS
select c.customer_id, c.first_name,c.last_name, c.email, count(r.rental_id) as total_rentals
from sakila.customer as c
join sakila.rental as r
on c.customer_id = r.customer_id
group by customer_id;

select * from cm_rental_info;

/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.*/
CREATE TEMPORARY TABLE cm_total_payment 
select payment.customer_id, sum(payment.amount) as total_paid
from sakila.payment
group by payment.customer_id;

select ri.customer_id, ri.first_name, ri.last_name, ri.email, ri.total_rentals, tp.total_paid, ri.total_rentals/tp.total_paid as avg_payment
from cm_rental_info as ri
join cm_total_payment as tp
on ri.customer_id = tp.customer_id
order by avg_payment desc
limit 10;

/*Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.*/

/*Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/