USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    c.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary c
JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id;

-- Create a CTE to join rental and payment summaries
WITH customer_summary AS (
    SELECT
        v.customer_name,
        v.email,
        v.rental_count,
        p.total_paid
    FROM
        customer_rental_summary v
    JOIN
        customer_payment_summary p ON v.customer_id = p.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM
    customer_summary;




    

