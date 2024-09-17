Challenge
Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customers ID, name, email address, and total number of rentals (rental_count).

create view rental_summary as
	select customer.customer_id, concat(customer.first_name, ' ', customer.last_name) as customer_name, customer.email,
       count(rental.rental_id) as rental_count from customer
join rental on customer.customer_id = rental.customer_id
group by customer.customer_id, customer_name, customer.email;

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table customer_payments as
select rental_summary.customer_id, sum(payment.amount) as total_paid from rental_summary
join payment on rental_summary.customer_id = payment.customer_id
group by rental_summary.customer_id;

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customers name, email address, rental count, and total amount paid.

with customer_summary as 
 (select rental_summary.customer_id, rental_summary.customer_name, rental_summary.email, rental_summary.rental_count, customer_payments.total_paid from rental_summary
  join customer_payments on rental_summary.customer_id = customer_payments.customer_id)
select customer_summary.customer_name, customer_summary.email, customer_summary.rental_count, customer_summary.total_paid from customer_summary;

Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with customer_summary as 
(select rental_summary.customer_id, rental_summary.customer_name, rental_summary.email, rental_summary.rental_count, sum(payment.amount) as total_paid from rental_summary 
  join payment on rental_summary.customer_id = payment.customer_id
  group by rental_summary.customer_id, rental_summary.customer_name, rental_summary.email, rental_summary.rental_count)
select customer_summary.customer_name, customer_summary.email, customer_summary.rental_count, customer_summary.total_paid, customer_summary.total_paid / customer_summary.rental_count as average_payment_per_rental from customer_summary;
