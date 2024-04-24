use sakila;
create view top_customers AS
select customer_id , sum(amount) total_spent
from payment
group by customer_id
having total_spent > 125;

create view customer_rental_summary as
select customer_id, concat (first_name, " ", last_name) as customer_name, email , count(rental_id), total_rental
from customer
inner join rental 
using(customer_id)
group by customer_id, customer_name,email;

select * from customer_rental_summary;
CREATE TEMPORARY TABLE payment_summary AS
select customer_id ,customer_name, sum(payment.amount) as total_amount_paid
from customer_rental_summary
inner join payment
using(customer_id)
group by customer_id, customer_name;

select * from payment_summary;

with sakilas_cte as (
select cr.customer_id,cr.customer_name, cr.email, ps.total_amount_paid, cr.total_rental
from customer_rental_summary cr
inner join payment_summary ps
on cr.customer_id = ps.customer_id)
select customer_name, email, total_rental ,total_amount_paid, total_amount_paid/total_rental as appr
from sakilas_cte;
