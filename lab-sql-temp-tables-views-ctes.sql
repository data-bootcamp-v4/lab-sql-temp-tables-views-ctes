USE sakila;

-- Challenge
-- Creating a Customer Summary Report

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. 
-- The report will be generated using a combination of views, CTEs, and temporary tables.

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

SELECT * FROM customer;
SELECT * FROM rental;

SELECT c.customer_ID, concat(c.first_name, " " , c.last_name) AS name, c.email, count(r.rental_id) AS total_number_rentals
FROM customer AS c
JOIN rental AS r 
ON r.customer_id = c.customer_id
GROUP BY c.customer_ID;

CREATE VIEW rental_customer_information AS (SELECT c.customer_ID, concat(c.first_name, " " , c.last_name) AS name, c.email, count(r.rental_id) AS total_number_rentals
FROM customer AS c
JOIN rental AS r 
ON r.customer_id = c.customer_id
GROUP BY c.customer_ID);

SELECT * FROM rental_customer_information;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

SELECT * FROM payment;

CREATE TEMPORARY TABLE temp_amount_customer1 AS (
	SELECT customer_id, SUM(amount) AS total_paid
    FROM payment
GROUP BY customer_id);
    
SELECT rc.*, t.total_paid
FROM rental_customer_information AS rc
JOIN temp_amount_customer1 AS t
ON rc.customer_id = t.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_customer_summary AS (
	SELECT rc.*, t.total_paid
	FROM rental_customer_information AS rc
	JOIN temp_amount_customer1 AS t
	ON rc.customer_id = t.customer_id
)
SELECT *
FROM cte_customer_summary;

-- REMOVING THE CUSTOMER_ID

WITH cte_customer_summary AS ( 
    SELECT
        rc.name,
        rc.email,
        rc.total_number_rentals,
        t.total_paid
    FROM rental_customer_information AS rc
    JOIN temp_amount_customer1 AS t
        ON rc.customer_id = t.customer_id
)
SELECT *
FROM cte_customer_summary;



-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.