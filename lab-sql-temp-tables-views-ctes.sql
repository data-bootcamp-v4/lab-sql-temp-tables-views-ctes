USE sakila;
-- Create a View
-- This view aggregates the total number of rentals for each customer by joining 
-- the customer table with the rental table.

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name, -- CONCAT: Combines the first and last names into a single column named customer_name.
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id -- LEFT JOIN: Ensures that even if a customer has never rented a movie, they still show up in the report (with a count of 0).
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM customer_rental_summary;


-- Create a Temporary Table
-- This temporary table uses the view created in Step 1 and joins it with 
-- the payment table to calculate the total amount spent by each customer.

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs -- It pulls data directly from the View we just created in Step 1.
LEFT JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

SELECT * FROM customer_payment_summary;


-- Create a CTE and the Customer Summary Report
-- This final query ties everything together. The CTE joins your View and Temporary Table, and the outer query uses 
-- that data to calculate the final average_payment_per_rental.

WITH final_summary_cte AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
                 -- Avoid division by zero errors if a customer has 0 rentals
    CASE         -- This is a safety measure. If you try to divide a number by zero in SQL, 
                  -- the entire query crashes. This checks if a customer has 0 rentals first.
        WHEN rental_count = 0 THEN 0 
        ELSE ROUND(total_paid / rental_count, 2) 
    END AS average_payment_per_rental
FROM final_summary_cte
ORDER BY total_paid DESC; -- Optional: Orders by highest spending customer

