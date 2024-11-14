USE sakila;

-- Creating the view for rental summary
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM sakila.customer AS c
JOIN sakila.rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

-- Checking the contents of the view
SELECT * FROM customer_rental_summary;
#2
-- Creating a temporary table for customer payments
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary AS crs
JOIN sakila.payment AS p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

-- Checking the contents of the temporary table
SELECT * FROM customer_payment_summary;

#3
-- Creating the CTE for the final report
WITH customer_summary AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        ROUND(cps.total_paid / crs.rental_count, 2) AS average_payment_per_rental
    FROM customer_rental_summary AS crs
    JOIN customer_payment_summary AS cps ON crs.customer_id = cps.customer_id
)

-- Generating the final customer summary report
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM customer_summary
ORDER BY customer_name;


