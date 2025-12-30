USE sakila;

-- STEP 1: View with rental summary per customer
DROP VIEW IF EXISTS customer_rental_summary;

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


-- STEP 2: Temporary table with total amount paid per customer
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payment_summary;

CREATE TEMPORARY TABLE tmp_customer_payment_summary AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary AS crs
LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;


-- STEP 3: CTE and final customer summary report
WITH customer_summary_cte AS (
    SELECT
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        COALESCE(tcps.total_paid, 0) AS total_paid
    FROM customer_rental_summary AS crs
    LEFT JOIN tmp_customer_payment_summary AS tcps
        ON crs.customer_id = tcps.customer_id
)
SELECT
    CONCAT(cs.first_name, ' ', cs.last_name) AS customer_name,
    cs.email,
    cs.rental_count,
    cs.total_paid,
    CASE 
        WHEN cs.rental_count = 0 THEN 0
        ELSE ROUND(cs.total_paid / cs.rental_count, 2)
    END AS average_payment_per_rental
FROM customer_summary_cte AS cs
ORDER BY
    cs.last_name,
    cs.first_name;
