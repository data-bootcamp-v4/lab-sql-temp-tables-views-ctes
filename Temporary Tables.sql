USE sakila;


-- =========================================================
-- CHALLENGE 1
-- CREATE A VIEW FOR CUSTOMER RENTAL SUMMARY
-- =========================================================

DROP VIEW IF EXISTS customer_rental_summary;

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


-- Check the view

SELECT *
FROM customer_rental_summary
ORDER BY customer_id;


-- =========================================================
-- CHALLENGE 2
-- CREATE A TEMPORARY TABLE FOR CUSTOMER PAYMENTS
-- =========================================================

DROP TEMPORARY TABLE IF EXISTS temp_customer_payment_summary;

CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT
    crs.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary AS crs
LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;


-- Check the temporary table

SELECT *
FROM temp_customer_payment_summary
ORDER BY customer_id;


-- =========================================================
-- CHALLENGE 3
-- CREATE A CTE AND FINAL CUSTOMER SUMMARY REPORT
-- =========================================================

WITH customer_summary AS
(
    SELECT
        crs.customer_id,
        crs.customer_name,
        crs.email,
        crs.rental_count,
        COALESCE(tcps.total_paid, 0) AS total_paid
    FROM customer_rental_summary AS crs
    LEFT JOIN temp_customer_payment_summary AS tcps
        ON crs.customer_id = tcps.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    ROUND(total_paid, 2) AS total_paid,
    ROUND(
        total_paid / NULLIF(rental_count, 0),
        2
    ) AS average_payment_per_rental
FROM customer_summary
ORDER BY customer_name;