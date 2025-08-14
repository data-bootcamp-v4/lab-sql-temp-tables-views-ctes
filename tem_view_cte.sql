USE sakila;

# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
create view  customer_rental as
select c.customer_id,c.first_name,c.last_name,c.email,
	   count(r.rental_id) as rental_count
from sakila.customer as c
inner join sakila.rental as r
on c.customer_id = r.customer_id
group by c.customer_id,c.first_name,c.last_name,c.email;


# Temporary Table shows the total amount paid by each customer (total_paid). 
create table customer_paid
select cr.*,
       cp.total_paid
from customer_rental as cr
inner join (select customer_id,sum(amount) as total_paid
			from sakila.payment
			group by customer_id) as cp
on cr.customer_id = cp.customer_id;

# the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental
with customer_rental_payment as(
								select cr.*, 
									   cp.total_paid
								from customer_rental as cr
								inner join customer_paid as cp
								on cr.customer_id = cp.customer_id)

select *,
      format(total_paid/rental_count,2) as average_payment_per_rental
from customer_rental_payment;


