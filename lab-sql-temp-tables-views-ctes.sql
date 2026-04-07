USE sakila;

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, 
-- and total number of rentals (rental_count).
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r 
    ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;
    
SELECT * FROM rental_summary;
   
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment table and calculate the total amount paid by each customer.   
CREATE TEMPORARY TABLE total_paid AS
SELECT 
    rs.customer_id,
    rs.name,
    rs.email,
    SUM(p.amount) AS total_paid
FROM rental_summary AS rs
JOIN payment AS p 
    ON rs.customer_id = p.customer_id
GROUP BY 
    rs.customer_id, rs.name, rs.email;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_total_paid AS (
SELECT 
    rs.customer_id,
    rs.name,
    rs.email,
    SUM(p.amount) AS total_paid
FROM rental_summary AS rs
JOIN payment AS p 
    ON rs.customer_id = p.customer_id
GROUP BY 
    rs.customer_id, rs.name, rs.email
)
SELECT ctp.name, ctp.email, ctp.total_paid
FROM cte_total_paid AS ctp;
    
-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.
WITH cte_total_paid AS (
    SELECT 
        rs.customer_id,
        rs.name,
        rs.email,
        SUM(p.amount) AS total_paid
    FROM rental_summary AS rs
    JOIN payment AS p 
        ON rs.customer_id = p.customer_id
    GROUP BY 
        rs.customer_id, rs.name, rs.email
)
SELECT 
    ctp.name,
    ctp.email,
    rs.rental_count,
    ctp.total_paid,
    (ctp.total_paid / NULLIF(rs.rental_count, 0)) AS average_payment_per_rental
FROM cte_total_paid AS ctp
JOIN rental_summary AS rs 
    ON ctp.customer_id = rs.customer_id;