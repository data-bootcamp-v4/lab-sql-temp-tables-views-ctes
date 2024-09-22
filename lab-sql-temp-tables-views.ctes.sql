-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_information AS
SELECT customer_id, email, (SELECT COUNT(rental_id) FROM rental)
FROM customer;

--  create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid AS
SELECT 
    c.customer_id, 
    SUM(p.amount) AS total_paid
FROM 
    customer_information c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_payment_summary AS (
    SELECT 
        c.first_name, 
        c.last_name,
        c.email, 
        (SELECT COUNT(r.rental_id) FROM rental r WHERE r.customer_id = c.customer_id) AS rental_count, 
        tp.total_paid
    FROM 
        customer c
    JOIN 
        customer_information ci ON c.customer_id = ci.customer_id
    JOIN 
        total_paid tp ON c.customer_id = tp.customer_id
)
SELECT 
    first_name, 
    last_name, 
    email, 
    rental_count, 
    total_paid
FROM 
    customer_payment_summary;

