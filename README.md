-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE OR REPLACE VIEW rental_information as SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) as rental_count
FROM sakila.customer as c
JOIN sakila.rental as r 
on c.customer_id = r.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name;
-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment table and calculate the total amount paid by each customer.
DROP TEMPORARY TABLE IF EXISTS total_paid; 
CREATE TEMPORARY TABLE total_paid AS
SELECT r.rental_count, r.customer_id, r.email, SUM(p.amount) as total_paid FROM rental_information as r 
JOIN sakila.payment as p
on r.customer_id = p.customer_id 
GROUP BY r.customer_id, r.rental_count ; 

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid. 
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.

WITH Customer_Summary_Report AS 
(SELECT re.rental_count, re.first_name, re.last_name, t.total_paid, t.email
FROM rental_information as re
JOIN total_paid as t 
on re.customer_id = t.customer_id) 
SELECT first_name, last_name, email, rental_count, total_paid, total_paid / rental_count as average_payment_per_rental FROM Customer_Summary_Report; 



-- Complete the challenge in this readme in a `.sql` file.



