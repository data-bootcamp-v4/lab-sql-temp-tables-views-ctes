-- temporary tables, views and ctes lab

use sakila;

-- step 1: create a view for rental summary
create or replace view rental_summary as
select 
    c.customer_id,
    concat(c.first_name,' ',c.last_name) as customer_name,
    c.email,
    count(r.rental_id) as rental_count
from customer c
left join rental r on c.customer_id=r.customer_id
group by c.customer_id,customer_name,c.email;

-- check the view
select * from rental_summary
limit 10;

-- step 2: create temporary table for total paid per customer
create temporary table customer_payment_summary as
select 
    rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count,
    coalesce(sum(p.amount),0) as total_paid
from rental_summary rs
left join payment p on rs.customer_id=p.customer_id
group by rs.customer_id,rs.customer_name,rs.email,rs.rental_count;

-- check temp table
select * from customer_payment_summary
limit 10;

-- step 3: create cte and final report
with customer_summary_cte as (
    select 
        customer_name,
        email,
        rental_count,
        total_paid
    from customer_payment_summary
)
select 
    customer_name,
    email,
    rental_count,
    total_paid,
    case 
        when rental_count>0 then round(total_paid/rental_count,2)
        else 0
    end as average_payment_per_rental
from customer_summary_cte
order by total_paid desc;