USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    
SELECT *
FROM customer_rental_summary;

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    v.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary AS v
LEFT JOIN payment AS p
    ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

SELECT *
FROM temp_customer_payments;

WITH customer_summary AS (
    SELECT
        CONCAT(v.first_name, ' ', v.last_name) AS customer_name,
        v.email,
        v.rental_count,
        p.total_paid
    FROM customer_rental_summary AS v
    INNER JOIN temp_customer_payments AS p
        ON v.customer_id = p.customer_id
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
FROM customer_summary;