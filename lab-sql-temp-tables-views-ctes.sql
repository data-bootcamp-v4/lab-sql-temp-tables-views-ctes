use sakila;

SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM payment;

-- Step 1: Create a View

CREATE VIEW view_rental_count as
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) as rental_count
    FROM customer as c
JOIN rental as r
ON c.customer_id = r.customer_id
JOIN payment as p
ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

-- Step 2: Create a Temporary Table

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment 
-- table and calculate the total amount paid by each customer.


CREATE temporary Table temp_tot_amount as
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) as rental_count,
    SUM(p.amount) as tot_amount
    FROM customer as c
JOIN rental as r
ON c.customer_id = r.customer_id
JOIN payment as p
ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

select * FROM temp_tot_amount;


-- Step 3: Create a CTE and the Customer Summary Report



WITH cte_tot_amount AS (
    SELECT 
        vie.customer_id,  -- Seleziona il customer_id UNA SOLA VOLTA
        vie.first_name,
        vie.last_name,
        vie.email,
        vie.rental_count,
        temp.tot_amount AS total_paid
    FROM view_rental_count AS vie
    JOIN temp_tot_amount AS temp
        ON vie.customer_id = temp.customer_id
)
SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM cte_tot_amount;





















