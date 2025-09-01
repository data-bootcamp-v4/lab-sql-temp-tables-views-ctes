USE sakila;

-- Step 1: VIEW = rentals per customer
DROP VIEW IF EXISTS vw_customer_rental_summary;
CREATE VIEW vw_customer_rental_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count   -- total rentals
FROM customer AS c
LEFT JOIN rental AS r
    ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- quick peek
SELECT * FROM vw_customer_rental_summary
ORDER BY rental_count DESC
LIMIT 10;


-- Step 2: TEMP TABLE = total paid per customer
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payment_summary;
CREATE TEMPORARY TABLE tmp_customer_payment_summary AS
SELECT
    p.customer_id,
    ROUND(SUM(p.amount), 2) AS total_paid
FROM payment AS p
GROUP BY p.customer_id;

-- quick peek
SELECT * FROM tmp_customer_payment_summary
ORDER BY total_paid DESC
LIMIT 10;


-- Step 3: CTE = final customer summary report
WITH customer_summary AS (
    SELECT
        v.customer_id,
        CONCAT(v.first_name, ' ', v.last_name) AS customer_name,
        v.email,
        v.rental_count,
        COALESCE(t.total_paid, 0) AS total_paid,
        -- avoid divide-by-zero; NULL if no rentals
        ROUND(COALESCE(t.total_paid, 0) / NULLIF(v.rental_count, 0), 2) AS average_payment_per_rental
    FROM vw_customer_rental_summary AS v
    LEFT JOIN tmp_customer_payment_summary AS t
        ON t.customer_id = v.customer_id
)
SELECT *
FROM customer_summary
ORDER BY total_paid DESC, rental_count DESC;

