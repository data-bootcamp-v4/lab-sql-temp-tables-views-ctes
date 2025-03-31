use sakila;

create view customer_data as(
select customer_id, first_name, last_name, email, count(rental_date) as rental_count
from customer
inner join rental
using (customer_id)
group by customer_id);



create temporary table rental_sumary
select customer_id, sum(amount) as total_paid
from customer_data
inner join payment
using (customer_id)
group by customer_id;


with cte_report (first_name, last_name, email, rental_count, total_paid, (total_paid/rental_count) as average_payment_per_rental) as (
select customer_data
inner join rental_sumary
using customer_id)
select * from report