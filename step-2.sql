use sakila;

create temporary table total_import
select a.customer_id, b.first_name, b.email, recuento, sum(a.amount) as total_paid
from payment a 
left outer join info_customer_rental b
on a.customer_id = b.customer_id
group by a.customer_id;

select *
from total_import;