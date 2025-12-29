use sakila;

-- Step 1: Create a View 

create view customer_rental_summary as
select 
	c.customer_id,
    concat(c.first_name, ' ' , c.last_name) as customer_name, 
    c.email, 
    count(r.rental_id) as rental_count
from customer c 
left join rental r 
	on c.customer_id = r.customer_id
group by
	c.customer_id, 
    c.first_name, 
    c.last_name,
    c.email;

-- Step 2: Create a Temporary Table

CREATE TEMPORARY TABLE IF NOT EXISTS total_paid as 
select 
	c.customer_id, 
	c.customer_name,
	c.email,
	c.rental_count,
	sum(p.amount) as total_paid

from customer_rental_summary as c
join sakila.payment as p
	on c.customer_id = p.customer_id

group by
c.customer_id,
c.customer_name,
c.email,
c.rental_count;

-- tests 
SELECT * FROM total_paid LIMIT 10;

SELECT * FROM total_paid ORDER BY total_paid DESC LIMIT 10;

-- Step 3: Create a CTE and the Customer Summary Report

with customer_cte as (select c.customer_name, c.email, c.rental_count, t.total_paid
from customer_rental_summary as c
join total_paid as t
	on c.customer_id = t.customer_id)  

select 
	customer_name,
    email,
    rental_count,
    total_paid,
    (total_paid / nullif(rental_count, 0)) as average_payment_per_rental
from customer_cte
order by customer_name;





