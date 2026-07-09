use sakila;

create view customer_rental_summary as
select customer.customer_id, customer.first_name, customer.last_name, customer.email, count(rental.rental_id) as rental_count
from customer
join rental on customer.customer_id = rental.customer_id
group by customer.customer_id;

SELECT * FROM customer_rental_summary;

create temporary table customer_payment_summary as
select customer_rental_summary.customer_id, sum(payment.amount) as total_paid
from customer_rental_summary
join payment on customer_rental_summary.customer_id = payment.customer_id
group by customer_rental_summary.customer_id;

with customer_summary as (
select customer_rental_summary.first_name, customer_rental_summary.last_name, customer_rental_summary.email, customer_rental_summary.rental_count, customer_payment_summary.total_paid
from customer_rental_summary
join customer_payment_summary
	on customer_rental_summary.customer_id = customer_payment_summary.customer_id
)
select *, total_paid / rental_count as average_payment_per_rental
from customer_summary;

