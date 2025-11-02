# LAB Temprary tables, views, CTEs > customer summary report (rental history + payment details)
#step 1 create a view: create a customer summary report 
create view customer_rental_info as
select c.customer_id, c.first_name, c.last_name, c.email, count(r.rental_id) as rental_count
from customer as c 
left join rental as r on c.customer_id=r.customer_id
group by customer_id
order by rental_count desc; 
#step 2 - create temporary table that calculates total amount paid by each customer
create temporary table customer_payment_summary as 
select p.customer_id, cri.first_name, cri.last_name, sum(p.amount) as total_paid
from payment as p
inner join customer_rental_info as cri on cri.customer_id=p.customer_id
group by customer_id
order by total_paid desc; 
select * from customer_payment_summary;
#Step 3.1: Create a CTE that joins the RSV and the CPS
#include customer_name, email, rental count and total amount paid. 
with customer_summary_report AS (
select cri.first_name, cri.last_name, cri.email, cri.rental_count, cps.total_paid
from customer_rental_info as cri
JOIN customer_payment_summary as cps on cri.customer_id=cps.customer_id)
select *
from customer_summary_report
order by total_paid desc; 
#Step 3.2 include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
#this last column is a derived column from total_paid and rental_count.
with customer_summary_report AS (
select cri.first_name, cri.last_name, cri.email, cri.rental_count, cps.total_paid
from customer_rental_info as cri
JOIN customer_payment_summary as cps on cri.customer_id=cps.customer_id)
select first_name, last_name, email, rental_count, total_paid, (total_paid/rental_count) as average_payment_per_rental
from customer_summary_report
order by  average_payment_per_rental desc; 
