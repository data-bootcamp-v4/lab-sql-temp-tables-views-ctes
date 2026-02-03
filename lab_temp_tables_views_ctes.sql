USE sakila;

-- 1 -- 
DROP VIEW IF EXISTS v_customer_rental_summary;

CREATE VIEW v_customer_rental_summary AS
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
    customer_name,
    c.email;
-- use:
-- VIEW = “tabla virtual”: te simplifica el resto del trabajo.
-- COUNT(r.rental_id) cuenta alquileres por cliente.
-- LEFT JOIN para asegurar incluir a todos los clientes.
-- GROUP BY agrupa por cliente para obtener el conteo.

-- 2 --
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payment_summary;

CREATE TEMPORARY TABLE tmp_customer_payment_summary AS
SELECT
    v.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p
    ON v.customer_id = p.customer_id
GROUP BY
    v.customer_id;
-- use:
-- TEMPORARY TABLE guarda resultados intermedios solo para esta sesion 
-- Te sirve para “congelar” ese cálculo y reutilizarlo sin recalcularlo en cada query compleja.
-- COALESCE(SUM(...),0) evita NULL si no tiene pagos.

-- 3 --
WITH customer_summary AS (
    SELECT
        v.customer_name,
        v.email,
        v.rental_count,
        t.total_paid
    FROM v_customer_rental_summary v
    INNER JOIN tmp_customer_payment_summary t
        ON v.customer_id = t.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, rental_count DESC;
-- use:
-- CTE (WITH ...): te permite armar una “tabla lógica” temporal solo para esta consulta
-- El SELECT final calcula el promedio por alquiler
-- ROUND(...,2) lo deja prolijo redondeando (2 decimales)
    
    
    
