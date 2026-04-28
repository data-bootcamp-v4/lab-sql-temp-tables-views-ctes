# Step 1: Create a View
# First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, 
# email address, and total number of rentals (rental_count).

use sakila;

select * from rental;
select * from customer;

drop view rental_info;
create view rental_info AS
select r.customer_id, concat(c.first_name, ' ' ,c.last_name) as customer_name,email, count(r.rental_id) as rental_count
from rental r
inner join customer c
on r.customer_id = c.customer_id
group by customer_id;

select * from rental_info;

# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
# The Temporary Table should use the rental summary view created in Step 
# 1 to join with the payment table and calculate the total amount paid by each customer.

select * from payment;

create temporary table customer_payment_summary as
select  r.customer_id,r.customer_name,r.email, sum(p.amount) as total_paid
from rental_info r
inner join payment p
on r.customer_id = p.customer_id
group by r.customer_id, r.customer_name, r.email;

select * from customer_payment_summary;

# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should
# include the customer's name, email address, rental count, and total amount paid.

# Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, 
# rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with customer_cte as (
    select
        v.customer_id,
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    from rental_info v
    join customer_payment_summary t
        on v.customer_id = t.customer_id
)
select
    customer_name,
    email,
    rental_count,
    total_paid,
    case 
        when rental_count = 0 THEN 0
        else total_paid / rental_count
    end as average_payment_per_rental
FROM customer_cte;