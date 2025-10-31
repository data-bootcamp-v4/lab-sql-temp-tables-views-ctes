use Sakila;

-- Step 1: Create a View

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create view customer_rental_info as
select c.customer_id, c.first_name, c.last_name, c.email, count(r.rental_id) as rental_count from customer c 
join rental r 
on r.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: Create a Temporary Table

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table customer_total_amount as
select p.customer_id, sum(p.amount) as total_paid from payment p 
group by p.customer_id;

select cri.customer_id, cri.first_name, cri.last_name, cri.email, cri.rental_count, cta.total_paid from customer_rental_info cri
join customer_total_amount cta
on cta.customer_id = cri.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid. 

with customer_summary as (
select cri.customer_id, cri.first_name, cri.last_name, cri.email, cri.rental_count, cta.total_paid from customer_rental_info cri
join customer_total_amount cta
on cta.customer_id = cri.customer_id)
select first_name, last_name, email, rental_count, total_paid 
from customer_summary;

-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental,
-- this last column is a derived column from total_paid and rental_count.

with customer_summary_report as (
select cri.customer_id, cri.first_name, cri.last_name, cri.email, cri.rental_count, cta.total_paid from customer_rental_info cri
join customer_total_amount cta
on cta.customer_id = cri.customer_id)
select
first_name, last_name, email, rental_count, total_paid,
total_paid / rental_count as average_payment_per_rental
from customer_summary_report;


