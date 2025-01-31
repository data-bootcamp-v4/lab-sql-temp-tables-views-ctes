use sakila;

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
-- including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create view rental_count as
select customer_id, first_name, last_name, email, count(rental_id)
from customer
inner join rental
using(customer_id)
group by customer_id;

select * from rental_count;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to 
-- join with the payment table and calculate the total amount paid by each customer.

create temporary table total_paid
select customer_id, sum(amount)
from customer
inner join payment
using (customer_id)
group by customer_id
order by sum(amount) desc;

select * from total_paid

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary 
-- Temporary Table created in Step 2. The CTE should include the customer's name, 
-- email address, rental count, and total amount paid.

