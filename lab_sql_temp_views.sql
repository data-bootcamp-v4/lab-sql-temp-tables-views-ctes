use sakila;

#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
create view rental_info as
select c.customer_id, c.first_name, c.last_name, c.email, count(r.rental_id) as rental_count
from customer c
right join rental r
on c.customer_id = r.customer_id
group by c.customer_id;

#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
create temporary table total_paid as
select ri.customer_id, ri.first_name, ri.last_name, ri.email, ri.rental_count, sum(p.amount) as total_paid
from rental_info ri
right join payment p
on ri.customer_id = p.customer_id
group by ri.customer_id, ri.first_name, ri.last_name, ri.email, ri.rental_count;

#The CTE should include the customer's name, email address, rental count, and total amount paid.
with cte as
(select first_name, last_name, email, rental_count, total_paid
from total_paid)

select first_name, last_name, email, rental_count, total_paid, round(total_paid/rental_count,2) as avg_payment_per_rental
from cte;