#1. Create a View
create view rental_data_ as
select customer_id, first_name, last_name, email, count(rental_id) AS COUNT_rental
from customer 
left join rental
using(customer_id)
group by customer_id;

select * from rental_data_;

#2. Create a Temporary Table
CREATE TEMPORARY TABLE tot_paid AS
select customer_id, sum(amount) as total_amount
from rental_data_
left join payment
using(customer_id)
group by customer_id;

select * from tot_paid;

# 3. Create a CTE and the Customer Summary Report
WITH cte AS (
    SELECT 
        rental_data_.first_name, 
        rental_data_.last_name, 
        rental_data_.email, 
        tot_paid.total_amount,
        rental_data_.COUNT_rental
    FROM rental_data_
    INNER JOIN tot_paid USING(customer_id)
    GROUP BY rental_data_.first_name, rental_data_.last_name, rental_data_.email, tot_paid.total_amount, rental_data_.COUNT_rental
)
select first_name, 
        last_name, 
        email, 
        total_amount,
        (COUNT_rental/total_amount) AS avg_payment_per_rental
        from cte;