## Challenge

-- Creating a Customer Summary Report

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database.
-- Including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create view 
	customer_rental_summary as
select 
	c.customer_id, c.last_name, c.email, COUNT(r.rental_id) as rental_count
from 
	customer c
left join 
	rental r on c.customer_id = r.customer_id
group by 
	c.customer_id, c.last_name, c.email;
    
select *
from customer_rental_summary;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table
	temp_total_paid as
select
	crs.customer_id, SUM(p.amount) as total_paid
from 
	customer_rental_summary crs
left join 
	payment p on crs.customer_id = p.customer_id
group by
	crs.customer_id;
    
select *
from temp_total_paid;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid. 
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental.
-- This last column is a derived column from total_paid and rental_count.

with
	customer_summary_cte as (
  select crs.last_name, crs.email, crs.rental_count, ttp.total_paid,
         ttp.total_paid / crs.rental_count as average_payment_per_rental
  from customer_rental_summary crs
  left join temp_total_paid ttp on crs.customer_id = ttp.customer_id
)

-- crs = (customers rental summary) with customers rental summary tempory table
-- ttp = (temp total paid) customer payment summary temporary table basing on customer's id.

-- Generating the final customer summary report using the CTE

select
	last_name, email, rental_count, total_paid, average_payment_per_rental
from customer_summary_cte;

