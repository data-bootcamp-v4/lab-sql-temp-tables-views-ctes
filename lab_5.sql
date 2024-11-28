-- Question 1
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;

-- Question 2
CREATE TEMPORARY TABLE customer_total_payment AS
SELECT 
    crs.customer_id,
    crs.full_name,
    crs.email,
    SUM(p.amount) AS total_paid
FROM 
    customer_rental_summary crs
JOIN 
    payment p ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id, crs.full_name, crs.email;

-- Question 3

WITH customer_rental_payment_summary AS (
    SELECT 
        crs.full_name,
        crs.email,
        crs.rental_count,
        ct.total_paid
    FROM 
        customer_rental_summary crs
    JOIN 
        customer_total_payment ct ON crs.customer_id = ct.customer_id
)
SELECT * 
FROM customer_rental_payment_summary;

-- part 2
WITH customer_rental_payment_summary AS (
    SELECT 
        crs.full_name,
        crs.email,
        crs.rental_count,
        ct.total_paid
    FROM 
        customer_rental_summary crs
    JOIN 
        customer_total_payment ct ON crs.customer_id = ct.customer_id
)
SELECT 
    full_name,
    email,
    rental_count,
    total_paid,
    CASE 
        WHEN rental_count > 0 THEN total_paid / rental_count
        ELSE 0
    END AS average_payment_per_rental
FROM 
    customer_rental_payment_summary;
