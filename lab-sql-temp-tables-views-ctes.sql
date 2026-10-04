USE sakila;
-- VIEW
CREATE VIEW customer_rental_summary AS

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
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

-- TEMPORARY TABLE
CREATE TEMPORARY TABLE customer_payment_summary AS

SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid

FROM customer_rental_summary AS crs

LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id

GROUP BY crs.customer_id;

SELECT *
FROM customer_payment_summary;

-- CTE
WITH customer_summary AS (

    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid

    FROM customer_rental_summary AS crs

    LEFT JOIN customer_payment_summary AS cps
        ON crs.customer_id = cps.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    ROUND(total_paid, 2) AS total_paid,
    ROUND(total_paid / rental_count, 2) AS avg_payment_per_rental

FROM customer_summary
ORDER BY total_paid DESC;
