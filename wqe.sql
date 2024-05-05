USE sakila;

CREATE OR REPLACE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
LEFT JOIN 
    rental r 
ON 
    c.customer_id = r.customer_id
GROUP BY 
    c.customer_id;
    
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM 
    rental_summary rs
LEFT JOIN 
    rental r 
ON 
    rs.customer_id = r.customer_id
LEFT JOIN 
    payment p 
ON 
    r.rental_id = p.rental_id
GROUP BY 
    rs.customer_id;

WITH customer_report AS (
    SELECT 
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid,
        cps.total_paid / rs.rental_count AS average_payment_per_rental
    FROM 
        rental_summary rs
    LEFT JOIN 
        customer_payment_summary cps 
    ON 
        rs.customer_id = cps.customer_id
)
SELECT 
    customer_name, 
    email, 
    rental_count, 
    total_paid, 
    ROUND(average_payment_per_rental, 2) AS average_payment_per_rental  -- Round to 2 decimal places
FROM 
    customer_report;

WITH customer_report AS (
    SELECT 
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid,
        cps.total_paid / rs.rental_count AS average_payment_per_rental
    FROM 
        rental_summary rs
    LEFT JOIN 
        customer_payment_summary cps 
    ON 
        rs.customer_id = cps.customer_id
)
SELECT 
    customer_name, 
    email, 
    rental_count, 
    total_paid, 
    ROUND(average_payment_per_rental, 2) AS average_payment_per_rental  -- Round to 2 decimal places
FROM 
    customer_report;
