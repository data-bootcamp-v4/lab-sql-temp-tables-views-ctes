-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create view customer_rental_info as 
(select first_name, last_name, c.customer_id, email, count(1) as rental_count
from customer c
inner join rental r
on c.customer_id = r.customer_id
group by 1, 2, 3, 4
order by 5 desc);

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table customer_total_payments as
(select first_name, last_name, c.customer_id, sum(amount) as total_paid from customer_rental_info c
inner join payment p
on c.customer_id = p.customer_id
group by 1, 2, 3
order by sum(amount) desc);

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. 

with customer_summary as 
(select c.first_name, c.last_name, c.email, c.customer_id, rental_count, total_paid 
from customer_rental_info c
inner join customer_total_payments ct
on c.customer_id = ct.customer_id)

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

select *, round(total_paid/rental_count, 2) as average_payment_per_rental
from customer_summary;
