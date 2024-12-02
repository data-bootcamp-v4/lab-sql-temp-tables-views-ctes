USE sakila;

CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;


CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM 
    rental_summary rs
JOIN 
    payment p ON rs.customer_id = p.customer_id
GROUP BY 
    rs.customer_id;


WITH customer_report AS (
    SELECT 
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM 
        rental_summary rs
    JOIN 
        payment_summary ps ON rs.customer_id = ps.customer_id
)

SELECT 
    cr.customer_name,
    cr.email,
    cr.rental_count,
    cr.total_paid,
    CASE 
        WHEN cr.rental_count > 0 THEN cr.total_paid / cr.rental_count
        ELSE 0 
    END AS average_payment_per_rental
FROM 
    customer_report cr;
