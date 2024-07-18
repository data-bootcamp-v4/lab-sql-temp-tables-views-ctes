#First, create a view that summarizes rental information for each customer. The view 
#should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW customer_summary as 
Select customer.customer_id, customer.first_name, customer.email, count(rental_id) as "Number of rentals"
from customer 
join rental
on customer.customer_id = rental.customer_id
group by customer.customer_id;

#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment 
#table and calculate the total amount paid by each customer.
DROP TABLE total_amount_paid_by_customer

CREATE TEMPORARY TABLE total_amount_paid_by_customer
SELECT customer_summary.customer_id, sum(payment.amount) as Total_Pay
from payment
join customer_summary
on customer_summary.customer_id = payment.customer_id
group by customer_summary.customer_id;

#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table 
#created in Step 2. The CTE should include the customer's name, email address, rental count, and total 
#amount paid.

WITH required_join AS (
	SELECT first_name, email, "Number of rentals", Total_Pay
    FROM total_amount_paid_by_customer
    join customer_summary
    on customer_summary.customer_id = total_amount_paid_by_customer.customer_id
)
SELECT *
from required_join;
	




