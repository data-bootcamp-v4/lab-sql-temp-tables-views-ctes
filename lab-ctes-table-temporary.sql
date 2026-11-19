USE sakila;

-- =========================================================
-- STEP 1: VIEW con el resumen de alquileres por cliente
-- =========================================================
CREATE OR REPLACE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM rental_summary LIMIT 10;

-- =========================================================
-- STEP 2: TABLA TEMPORAL con el total pagado por cliente
-- (usa la vista rental_summary)
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

SELECT * FROM customer_payment_summary LIMIT 10;

-- =========================================================
-- STEP 3 + 4: CTE y reporte final
-- =========================================================
WITH customer_summary AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps
        ON rs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;