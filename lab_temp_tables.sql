use sakila;

CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.customer_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;
    
    
    CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    c.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer c
LEFT JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id;
    
    WITH customer_summary_cte AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        CASE
            WHEN crs.rental_count > 0 THEN cps.total_paid / crs.rental_count
            ELSE 0
        END AS average_payment_per_rental
    FROM
        customer_rental_summary crs
    LEFT JOIN
        customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary_cte;