use sakila;

-- 1 Create a View
-- First, create a view that summarizes rental information for each cusomer. This view will include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


-- 2  Create a Temporary Table
--  create a temporary table that calculates the total amount paid by each customer. This temporary table will use the rental summary view created in Step 1 and join it with the payment table to calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    c.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- 3 Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary view with the customer payment summary temporary table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. Then, using the CTE, generate the final customer summary report, which includes customer name, email, rental count, total paid, and average payment per rental

WITH customer_summary AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        (cps.total_paid / crs.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM customer_summary;








