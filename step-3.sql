use sakila;

with cte as (
select a.first_name, a.email, a.rental_count, b.total_paid
from info_customer_rental a
left outer join total_import b
on a.customer_id = b.customer_id
)

select first_name, email, rental_count, total_paid, round((total_paid / rental_count), 2) as Average_payment_per_rental
from cte