use sakila;

-- Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
select * from customer;
select * from rental;

create view summary_rental_total11 as (
select c.customer_id, concat(c.first_name,' ', c.last_name) as name, email, count(r.rental_id) as rental_count
from customer as c left join rental as r using (customer_id) 
GROUP BY  c.customer_id); 

select * from summary_rental_total11;



-- Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
-- and calculate the total amount paid by each customer.

select * from payment;

select p.customer_id, sum(p.amount) from payment as p group by customer_id; 

Create Temporary Table total_amount1 as 
select srt.*, sum(p.amount)
from summary_rental_total11 as srt
join payment as p
on srt.customer_id = p.customer_id
group by customer_id;

select * from total_amount1;


CREATE TEMPORARY TABLE total_amount AS 
SELECT srt.*, SUM(p.amount) AS total_amount
FROM summary_rental_total11 AS srt
JOIN payment AS p ON srt.customer_id = p.customer_id
GROUP BY srt.customer_id;

select * from total_amount;


-- Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
with customer_summary_report as 
(SELECT srt.*, SUM(p.amount) AS total_amount
FROM summary_rental_total11 AS srt
JOIN payment AS p ON srt.customer_id = p.customer_id
GROUP BY srt.customer_id)
select R.name as customer_name, R.email, R.rental_count, R.total_amount as total_paid, ROUND(R.total_amount/R.rental_count, 2) as average_payment_per_renta 
from customer_summary_report as R ; 



-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.


