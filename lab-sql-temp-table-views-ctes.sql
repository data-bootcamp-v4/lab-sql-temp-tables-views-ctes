use sakila;
-- step 1: create a view - rental information for each customer . the view should include the customers id ,name ,email adress, and total number of rental 

select c.customer_id, c.first_name , last_name ,email , count(r.rental_id) as rental_count
from customer as c join rental as r on c.customer_id = r.customer_id group by c.customer_id order by rental_count desc;

create view view_rental_information as (select c.customer_id, c.first_name , last_name ,email , count(r.rental_id) as rental_count
from customer as c join rental as r on c.customer_id = r.customer_id group by c.customer_id );

select * from view_rental_information;
-- step 2: create a temporary table-

select v.customer_id , first_name,last_name ,sum(p.amount) as total_payment from 
view_rental_information  as v join payment as p on v.customer_id = p.customer_id
group by v.customer_id;

create temporary table temp_total_paid as (select v.customer_id , first_name,last_name ,sum(p.amount) as total_payment from 
view_rental_information  as v join payment as p on v.customer_id = p.customer_id
group by v.customer_id);

select * from temp_total_paid limit 5;
-- step 3: Create a CTE and the Customer Summary Report

select v.first_name, v.last_name,v.email,v.rental_count ,t.total_payment
 from view_rental_information as v join temp_total_paid as t on v.customer_id = t.customer_id;
 
 
 
with cte_cutomers_summary_payment as 
(select v.first_name, v.last_name,v.email,v.rental_count ,t.total_payment
 from view_rental_information as v join temp_total_paid as t on v.customer_id = t.customer_id)
 select first_name,last_name,email,rental_count ,total_payment, round(total_payment/rental_count,2) as average_payment_per_rental 
 from cte_cutomers_summary_payment ;