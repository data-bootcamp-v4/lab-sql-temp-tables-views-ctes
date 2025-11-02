use sakila;

-- First, create a view that summarizes rental information for each customer.
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

create or replace view summary as
select c.customer_id, c.first_name, c.last_name, c.email, count(r.customer_id) as rental_count
from customer c
join rental r
on c.customer_id = r.customer_id
group by r.customer_id;

select* from summary;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
-- and calculate the total amount paid by each customer.

create temporary table total_paid
select s.customer_id, s.first_name, s.last_name, s.email, s.rental_count, sum(p.amount)
from summary s
join payment p
on s.customer_id = p.customer_id
group by s.customer_id;

select * from total_paid;


-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH rental_payment_summary AS (
    SELECT s.customer_id, s.first_name, s.last_name, s.email, s.rental_count, SUM(p.amount) AS total_paid
    FROM summary s
    JOIN payment p
    ON s.customer_id = p.customer_id
    GROUP BY 
        s.customer_id
)
SELECT 
    customer_id, 
    first_name, 
    last_name, 
    email, 
    rental_count, 
    total_paid
FROM rental_payment_summary;


-- Next, using the CTE, create the query to generate the final customer summary report, which should include:
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a
-- derived column from total_paid and rental_count.

WITH rental_payment_summary AS (
    SELECT 
        s.customer_id, 
        s.first_name, 
        s.last_name, 
        s.email, 
        s.rental_count, 
        SUM(p.amount) AS total_paid
    FROM summary s
    JOIN payment p ON s.customer_id = p.customer_id
    GROUP BY 
        s.customer_id, 
        s.first_name, 
        s.last_name, 
        s.email, 
        s.rental_count
)
SELECT 
    first_name, 
    last_name, 
    email, 
    rental_count, 
    total_paid, 
    (total_paid / rental_count) AS average_paid_per_rental
FROM rental_payment_summary;