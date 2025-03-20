-- Step 1: Create a View that summarizes rental information for each customer
-- First, create a view that summarizes rental information for each customer.
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
-- Your SQL code for creating the view goes here.
USE sakila;

CREATE VIEW rental_count_per_customer AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, count(r.customer_id) as rental_count
FROM sakila.customer c
LEFT JOIN sakila.rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Step 2: Create a Temporary Table that calculates the total amount paid by each customer
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.
-- Your SQL code for creating the temporary table goes here.
CREATE TEMPORARY TABLE payment_per_customer
SELECT r.customer_id, sum(p.amount) as total_paid FROM sakila.rental_count_per_customer as r
JOIN payment as p
ON r.customer_id = p.customer_id
GROUP BY customer_id;

-- Step 3: Create a CTE that joins the rental summary view with the customer payment summary temporary table
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Your SQL code for creating the CTE goes here.
WITH combined AS (
    SELECT 
        r.first_name, 
        r.last_name, 
        r.email, 
        r.rental_count, 
        p.total_paid
    FROM sakila.payment_per_customer AS p
    JOIN sakila.rental_count_per_customer AS r
    ON p.customer_id = r.customer_id
)
-- Now you can select from the CTE to see the results
SELECT * FROM combined;

-- Final Query to generate the customer summary report with average_payment_per_rental
-- Using the CTE, create the query to generate the final customer summary report,
-- which should include: customer name, email, rental_count, total_paid
-- and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
-- Your SQL code for the final report goes here.
WITH combined AS (
    SELECT 
        r.first_name, 
        r.last_name, 
        r.email, 
        r.rental_count, 
        p.total_paid
    FROM sakila.payment_per_customer AS p
    JOIN sakila.rental_count_per_customer AS r
    ON p.customer_id = r.customer_id
)
SELECT *, total_paid / rental_count as average_payment_per_rental
FROM combined;