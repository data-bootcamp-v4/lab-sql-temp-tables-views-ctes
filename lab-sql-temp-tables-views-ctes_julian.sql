use sakila;


## Step 1 : 
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).


create view customer_rental_summary as 
select r.customer_id,
	concat(c.first_name, " ", c.last_name) as Customer_name,
    c.email,
    count(r.rental_id) as rental_count
from rental r
left join customer c on r.customer_id = c.customer_id
group by r.customer_id
;


-- call view
select *
from customer_rental_summary
;


#Step 2:
# create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
# and calculate the total amount paid by each customer.



create temporary table customer_payment_summary_v2 as
select crs.customer_id,
		crs.Customer_name,
        crs.email,
        crs.rental_count,
        sum(p.amount) as total_paid
from customer_rental_summary crs
left join payment p on crs.customer_id = p.customer_id
group by crs.customer_id
;



## call temporary table 
select * 
from customer_payment_summary_v2
limit 10
;




## Step 3: Create a CTE and customer summary Report 
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

with cte_customer_summary as (
select crs.Customer_name,
		crs.email,
        crs.rental_count,
        cps.total_paid
from customer_rental_summary crs
left join customer_payment_summary_v2 cps on crs.customer_id = cps.customer_id
)
select ctecs.Customer_name,
		ctecs.email,
        ctecs.rental_count,
        ctecs.total_paid,
        round(ctecs.total_paid / ctecs.rental_count, 2) as avg_per_rental
from cte_customer_summary ctecs
order by ctecs.total_paid DESC
;









