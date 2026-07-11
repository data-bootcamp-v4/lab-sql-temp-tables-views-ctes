USE sakila;

-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_summary AS
SELECT
c.customer_id,
c.first_name,
c.last_name,
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

SELECT * 
FROM rental_summary
LIMIT 20;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

-- DROP TEMPORARY TABLE IF EXISTS total_paid;

CREATE TEMPORARY TABLE total_paid AS 
SELECT 
rs.customer_id,
rs.first_name,
rs.last_name,
rs.email,
SUM(p.amount) AS total_paid
FROM rental_summary rs
LEFT JOIN payment p
ON rs.customer_id = p.customer_id
GROUP BY 
rs.customer_id;

SELECT * 
FROM total_paid
LIMIT 20;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary AS (
    SELECT
    rs.customer_id,
	rs.first_name,
	rs.last_name,
	rs.email,
    rs.rental_count,
    tp.total_paid
    FROM 
    rental_summary rs
    LEFT JOIN total_paid tp
    ON rs.customer_id = tp.customer_id
)
SELECT 
first_name,
last_name,
email,
rental_count,
total_paid,
ROUND((total_paid / rental_count), 2) AS avg_per_rental
FROM customer_summary;
