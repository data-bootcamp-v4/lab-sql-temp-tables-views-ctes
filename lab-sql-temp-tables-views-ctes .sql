use sakila;

-- Creating a Customer Summary Report
-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
-- including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
-- Step 1: Create a View

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).


CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(rental.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental ON c.customer_id = rental.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment 
-- table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid AS
SELECT customer_rental_summary.customer_id,
    SUM(payment.amount) AS total_paid
    FROM customer_rental_summary
JOIN payment 
ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary_cte AS (
    SELECT 
        customer_rental_summary.customer_id,
        customer_rental_summary.first_name,
        customer_rental_summary.last_name,
        customer_rental_summary.email,
        customer_rental_summary.rental_count,
        total_paid.total_paid
    FROM customer_rental_summary
    JOIN total_paid 
        ON customer_rental_summary.customer_id = total_paid.customer_id
)
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;





    

