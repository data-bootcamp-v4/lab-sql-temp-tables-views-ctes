-- Challenge 1.
-- Step 1: Create a View
CREATE OR REPLACE VIEW rental_summary AS
SELECT 
    c.customer_id AS cid,
    CONCAT(c.first_name, ' ', c.last_name) AS nam,
    c.email AS eml,
    COUNT(r.rental_id) AS rct
FROM
    customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;


-- Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    rs.cid AS cid,
    SUM(p.amount) AS tpd
FROM
    rental_summary rs
    LEFT JOIN payment p ON rs.cid = p.customer_id
GROUP BY 
    rs.cid;

-- Step 3: Create a CTE and the Customer Summary Report
WITH cus AS (
    SELECT 
        rs.nam AS nam,
        rs.eml AS eml,
        rs.rct AS rct,
        cps.tpd AS tpd,
        (cps.tpd / rs.rct) AS apr
    FROM
        rental_summary rs
        LEFT JOIN customer_payment_summary cps ON rs.cid = cps.cid
)
SELECT 
    nam AS customer_name,
    eml AS emauk,
    rct AS rental_count,
    tpd AS total_paid,
    ROUND(apr, 2) AS average_payment_per_rental
FROM 
    cus;

