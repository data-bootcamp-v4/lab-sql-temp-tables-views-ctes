-- LAB: Temporary Tables, Views and CTEs
-- Customer Summary Report

-- Step 1: Create a View
-- Create a view that summarizes rental information for each customer
-- Includes: customer ID, name, email address, and total number of rentals

CREATE OR REPLACE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;


-- Step 2: Create a Temporary Table
-- Create a temporary table that calculates the total amount paid by each customer
-- Uses the rental_summary view and joins with the payment table

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM
    rental_summary rs
LEFT JOIN
    rental r ON rs.customer_id = r.customer_id
LEFT JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY
    rs.customer_id, rs.customer_name, rs.email, rs.rental_count;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary view with the customer payment summary temporary table
-- Generate the final customer summary report

WITH customer_summary_cte AS (
    SELECT
        cps.customer_name,
        cps.email,
        cps.rental_count,
        cps.total_paid
    FROM
        customer_payment_summary cps
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE
        WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
        ELSE 0
    END AS average_payment_per_rental
FROM
    customer_summary_cte
ORDER BY
    customer_name;
