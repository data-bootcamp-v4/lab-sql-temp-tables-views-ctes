create temporary table temp_cust_rentals(
select customer_id, COUNT(*) as total_rentals
from rental
group by customer_id);


-- use cte to get the sum of the rental per customer
WITH cust_rentals as (
SELECT customer_id, COUNT(*) as total_rentals
from rental
group by customer_id)
-- using the cte
 


select customer_id, COUNT(*) as total_rentals
from rental
group by customer_id;

-- create a view
CREATE VIEW customer_report AS
SELECT c.customer_id, 
		c.first_name, 
        c.last_name, 
        c.email,
        (select COUNT(*)
			from rental r
			where r.customer_id=c.customer_id) as rental_count
FROM customer c;

select *
from customer_report;



select *
from payment;


select customer_id, sum(amount)
from payment
group by customer_id;

-- create a temp table
CREATE TEMPORARY TABLE temp_money_per_cust AS
select cr.customer_id, 
		cr.first_name,
        cr.last_name,
        cr.email,
        cr.rental_count,
			(select sum(amount)
			from payment p
            where cr.customer_id = p.customer_id) as total_amount_paid
from customer_report cr;

select *
from temp_money_per_cust;

with total_join as (
select c1.first_name, 
        c1.last_name, 
        c1.email,
        c1.rental_count,
        tmp.total_amount_paid
from customer_report c1
left join temp_money_per_cust tmp on c1.customer_id = tmp.customer_id)

select first_name, last_name, email, rental_count, total_amount_paid, 
CASE WHEN total_amount_paid <> 0 THEN  total_amount_paid/rental_count ELSE NULL END AS average_payment_per_rental
from total_join;

SELECT *
FROM total_join;

select first_name, last_name, email, rental_count, total_amount_paid, 
CASE WHEN total_amount_paid <> 0 THEN rental_count / total_amount_paid ELSE NULL END AS average_payment_per_rental
from total_join;


