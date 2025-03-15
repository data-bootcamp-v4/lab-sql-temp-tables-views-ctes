USE sakila;
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, 
-- and total number of rentals (rental_count).
CREATE VIEW rental_summary AS
SELECT r.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY customer_id;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use 
-- the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE temporary_table AS
SELECT p.customer_id, SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY p.customer_id;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should 
-- include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, 
-- rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH cte AS (
	SELECT rs.first_name, rs.last_name, rs.email, rs.total_rentals, tt.total_paid
    FROM rental_summary rs
    JOIN temporary_table tt ON rs.customer_id = tt.customer_id
    )
SELECT 
    first_name, 
    last_name, 
    email, 
    total_rentals, 
    total_paid,
    total_paid / total_rentals AS average_payment_per_rental
FROM cte;

