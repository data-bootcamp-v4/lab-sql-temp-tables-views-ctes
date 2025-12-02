/*Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to 
join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental 
count, and total amount paid.
Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental,
this last column is a derived column from total_paid and rental_count.*/


USE sakila;

-- STEP 1: CREATE VIEW 

CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    
    -- STEP 2: TEMPORARY TABLE 

CREATE TEMPORARY TABLE tmp_customer_payment_summary2 AS
SELECT 
    crs.customer_id,
    crs.customer_name,                
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p
    ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id,
    crs.customer_name;
    
    SELECT *
FROM tmp_customer_payment_summary2
LIMIT 10;

-- STEP 3: CTE + FINAL CUSTOMER SUMARY REPORT

WITH customer_summary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        t.total_paid
    FROM customer_rental_summary crs
    LEFT JOIN tmp_customer_payment_summary t
        ON crs.customer_id = t.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE 
        WHEN rental_count > 0 THEN total_paid / rental_count
        ELSE NULL
    END AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;