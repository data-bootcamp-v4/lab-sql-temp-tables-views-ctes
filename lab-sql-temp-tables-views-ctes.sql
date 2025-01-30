-- Challenge
-- Creating a Customer Summary Report

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
use sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
-- customer_ID as c.c_id, customer.first_name as cust.fn, last_name as cust.ln, email, count(rental_id) as rental_count

-- testing out query first and then put it in the view
select 
	customer.customer_ID as c_id, 
    customer.first_name as fname,  
    customer.last_name as lname,  
    customer.email as email,  
    COUNT(rental.rental_id) as rental_count
from customer 
inner join rental
using (customer_id)
group by c_id, fname, lname, email
order by rental_count;
-- view 
create view rental_count as (
select 
	customer.customer_ID as c_id, 
    customer.first_name as fname,  
    customer.last_name as lname,  
    customer.email as email,  
    COUNT(rental.rental_id) as rental_count
from customer 
inner join rental
using (customer_id)
group by c_id, fname, lname, email
order by rental_count);

select * from rental_count;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
select customer_id, sum(amount) as total_pd
from payment 
group by customer_id;

-- temp table
create temporary table total_paid_1 as
select rc.* , sum(p.amount) 
from rental_count as rc
inner join payment p
on rc.c_id = p.customer_id
group by rc.c_id;

select * from total_paid_1;

-- Step 3: Create a CTE and the Customer Summary Report:
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH cte_total_paid AS (
    SELECT rc.*, SUM(p.amount) AS total_paid
    FROM rental_count AS rc
    INNER JOIN payment p 
	ON rc.c_id = p.customer_id
    GROUP BY rc.c_id)
SELECT * FROM total_paid_1;


SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT average FROM avg_salary)
WITH avg_salary AS (
    SELECT AVG(salary) AS average
    FROM employees
);
