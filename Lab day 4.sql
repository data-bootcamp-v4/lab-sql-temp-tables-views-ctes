use sakila;
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
#Step 3: Create a CTE ad the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, 
#total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

#1
create view  customer_rental_summary as
select customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, count(rental.rental_id) as rental_count
from customer
inner join rental ON customer.customer_id = rental.customer_id
group by customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id;
    
    
#2
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

create temporary table customer_total_paid as
select crs.customer_id, crs.first_name, crs.last_name, crs.email, sum(p.amount) as total_paid
from customer_rental_summary as crs 
inner join rental r on crs.customer_id = r.customer_id
inner join payment p on r.rental_id = p.rental_id
GROUP BY crs.customer_id, crs.first_name, crs.last_name, crs.email;

#3 
WITH customer_payment_summary AS (
    select crs.customer_id, crs.first_name, crs.last_name, crs.email, crs.rental_count, ctp.total_paid
    from customer_rental_summary as crs
    inner join customer_total_paid ctp on  crs.customer_id = ctp.customer_id
)
select first_name, last_name as customer_name , email, rental_count, total_paid, round(total_paid / rental_count, 2)  as average_payment_per_rental
from customer_payment_summary
order by customer_name;


