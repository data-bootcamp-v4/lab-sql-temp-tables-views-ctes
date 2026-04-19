USE sakila;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Challenge
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creating a Customer Summary Report
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--  1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS name, c.email, COUNT(r.rental_id) AS total_no_of_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT * FROM customer_rental_summary;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to 
-- join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE rental_summary AS
SELECT crs.customer_id, crs.name, crs.email, crs.total_no_of_rentals, SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.name, crs.email, crs.total_no_of_rentals;

SELECT * FROM rental_summary;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, 
-- rental count, and total amount paid.
WITH cte AS (
SELECT rs.name, rs.email, rs.total_no_of_rentals, rs.total_paid
FROM rental_summary rs
JOIN customer_rental_summary crs ON crs.customer_id = rs.customer_id
)
SELECT * FROM cte; 

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, 
-- total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH cte AS (
    SELECT rs.name, rs.email, rs.total_no_of_rentals, rs.total_paid,
           ROUND(rs.total_paid / rs.total_no_of_rentals, 2) AS average_payment_per_rental
    FROM rental_summary rs
    JOIN customer_rental_summary crs ON crs.customer_id = rs.customer_id
)
SELECT name, email, total_no_of_rentals, total_paid, average_payment_per_rental
FROM cte;


