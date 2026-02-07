USE sakila;

CREATE VIEW customer_rental_summary AS
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
    
CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

WITH customer_summary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        IFNULL(tcp.total_paid, 0) AS total_paid
    FROM customer_rental_summary crs
    LEFT JOIN temp_customer_payments tcp
        ON crs.customer_id = tcp.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(
        total_paid / NULLIF(rental_count, 0),
        2
    ) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC