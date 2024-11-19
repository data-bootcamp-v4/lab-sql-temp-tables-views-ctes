use sakila;

create view info_customer_rental as (

select a.customer_id, b.first_name, b.email, count(a.rental_id) as rental_count
from rental a
left outer join customer b
on a.customer_id = b.customer_id
group by a.customer_id
);

select *
from info_customer_rental