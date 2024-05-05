# Step 1: Create a View
# First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_count AS
SELECT c.customer_id, concat(first_name," ", last_name) as name , email, count(r.customer_id) as rental
from customer c
inner join rental r
on c.customer_id = r.customer_id
group by c.customer_id;

# Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid AS
select rc.customer_id, sum(amount) as total_amount
from rental_count rc
inner join payment p
on rc.customer_id = p.customer_id
group by customer_id;

select * from rental_count;
select * from total_paid;
#Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
with cte as (
select name, email, rental, total_amount
 from rental_count rc
 inner join total_paid tp
 on rc.customer_id = tp.customer_id)
 select name, rental, total_amount, round(total_amount/rental,2) as average_payment_per_rental
 from cte
 
 
 
 