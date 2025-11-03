USE sakila;

DROP VIEW IF EXISTS vw_customer_rental_summary;
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payment_summary;

-- =========================
-- STEP 1: VISTA (resumen de alquileres por cliente)
-- Salida: customer_id, customer_name, email, rental_count
-- =========================
CREATE VIEW vw_customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
  ON r.customer_id = c.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
    
-- =========================
-- STEP 2: TABLA TEMPORAL (pagos totales por cliente)
-- Salida: customer_id, total_paid
-- =========================
CREATE TEMPORARY TABLE tmp_customer_payment_summary AS
SELECT
    v.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM vw_customer_rental_summary AS v
LEFT JOIN payment AS p
  ON p.customer_id = v.customer_id
GROUP BY v.customer_id;


-- =========================
-- STEP 3: CTE + INFORME FINAL
-- Columnas finales:
--  customer_name, email, rental_count, total_paid, average_payment_per_rental
-- =========================
WITH customer_cte AS (
    SELECT
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM vw_customer_rental_summary AS v
    LEFT JOIN tmp_customer_payment_summary AS t
      ON t.customer_id = v.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    CASE
        WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
        ELSE NULL
    END AS average_payment_per_rental
FROM customer_cte
ORDER BY total_paid DESC, rental_count DESC, customer_name ASC;