USE sakila;

### view ###

create view rental_info as
select c.customer_id, c.first_name, c.last_name, c.email, count(r.customer_id) as rental_count
from customer c
join rental r
on c.customer_id = r.customer_id
group by r.customer_id;

select * from rental_info;

### temporary table ###

create temporary table temp_total_paid
select ri.customer_id, ri.first_name, ri.last_name, ri.email, ri.rental_count, sum(p.amount) as total_paid
from rental_info as ri
join payment as p
on ri.customer_id = p.customer_id
group by ri.customer_id;

select * from temp_total_paid;

### cte ###

WITH customer_summary AS (
    SELECT first_name, last_name, email, rental_count, total_paid
    FROM temp_total_paid
)
SELECT 
    first_name, 
    last_name, 
    email, 
    rental_count, 
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
FROM customer_summary;


