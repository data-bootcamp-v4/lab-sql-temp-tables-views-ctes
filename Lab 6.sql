
--  Create the Rental Summary View

Use Sakila;

drop view if exists customer_rental_summary;

Create view customer_rental_Summary as 
select customer.customer_id,
       customer.first_name,
       customer.last_name,
       customer.email,
       count(rental.rental_id) as rental_count
from customer
inner join rental on customer.customer_id = rental.customer_id
group by customer.customer_id,
       customer.first_name,
       customer.last_name,
       customer.email;
       
	-- verify 
    select * from customer_rental_summary;
    
    
    -- create the Temporary Table 
    
  DROP TEMPORARY TABLE IF EXISTS temp_customer_payment_summary;

CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT 
    customer_rental_summary.customer_id,
    SUM(payment.amount) AS total_paid
FROM customer_rental_summary
INNER JOIN payment ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;

-- Verify the temporary table works
SELECT * FROM temp_customer_payment_summary;

-- create CTE and final customer summary report

-- Define the modular CTE framework block

WITH master_customer_cte AS (
    SELECT 
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary AS crs
    INNER JOIN temp_customer_payment_summary AS cps 
        ON crs.customer_id = cps.customer_id
)
-- Generate the final analytics business report from the CTE data
SELECT 
    master_customer_cte.first_name,
    master_customer_cte.last_name,
    master_customer_cte.email,
    master_customer_cte.rental_count,
    master_customer_cte.total_paid,
    -- Calculate the average cost paid per rental transaction item
    ROUND((master_customer_cte.total_paid / master_customer_cte.rental_count), 2) AS average_payment_per_rental
FROM master_customer_cte
ORDER BY master_customer_cte.total_paid DESC;

    
    
    
    