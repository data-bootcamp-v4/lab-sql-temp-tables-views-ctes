# step 1

create view customer_rental_summary as 
select r.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       count(r.rental_id) as rental_count
from customer c
join rental r
on c.customer_id = r.customer_id
group by r.customer_id,r.customer_id,c.last_name,c.email;

# step 2
create temporary table customer_payment_summary as
select crs.customer_id,
       crs.first_name,
       crs.last_name,
       crs.email,
       sum(p.amount) as total_paid
from customer_rental_summary crs
join payment p
on crs.customer_id = p.customer_id
group by crs.customer_id, crs.first_name, crs.last_name,crs.email;

# step 3
with customer_CTE AS (
select crs.first_name, crs.last_name, crs.email,crs.rental_count, cps.total_paid
from customer_rental_summary crs
join customer_payment_summary cps
on crs.customer_id = cps.customer_id
)

select first_name,
       last_name,
       email,
       rental_count,
       total_paid,
       round(total_paid/rental_count,2) as average_payment_per_rental
from customer_CTE;

