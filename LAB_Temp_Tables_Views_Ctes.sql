-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_information AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) as rental_count
FROM customer c
JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id,c.first_name, c.last_name, c.email; 
SELECT * FROM rental_information;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_paid AS
SELECT r.customer_id, SUM(amount) as total_amount
FROM payment p
JOIN rental_information r
ON r.customer_id = p.customer_id
GROUP BY r.customer_id;

SELECT * FROM total_paid;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


WITH customer_summary AS 
(SELECT first_name, last_name, email, ri.rental_count, tp.total_amount
FROM rental_information ri
JOIN total_paid tp ON ri.customer_id = tp.customer_id)

SELECT first_name, last_name, email, rental_count, total_amount, total_amount / rental_count AS average_payment_per_rental 
FROM customer_summary;