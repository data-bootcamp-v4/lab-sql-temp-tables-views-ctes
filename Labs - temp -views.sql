use sakila;

#1
CREATE VIEW customer_rental AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
    
    
    
    #2
    
    CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    cr.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental cr
JOIN payment p ON cr.customer_id = p.customer_id
GROUP BY cr.customer_id;

# 3

WITH customer_full_report AS (
    SELECT
        cr.first_name,
        cr.last_name,
        cr.email,
        cr.rental_count,
        cps.total_paid
    FROM
        customer_rental cr
    JOIN
        customer_payment_summary cps
        ON cr.customer_id = cps.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
FROM
    customer_full_report
ORDER BY
    last_name, first_name;
    
    
    
    
    
    
    
    
    
    