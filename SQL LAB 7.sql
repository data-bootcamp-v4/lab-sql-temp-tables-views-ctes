USE sakila;
SHOW TABLES;
-- Paso 1: Crear una Vista (View)
CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, customer_name, c.email;

-- Paso 2: Crear una Tabla Temporal (Temporary Table)
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary crs  -- Usamos la Vista del Paso 1
JOIN
    payment p ON crs.customer_id = p.customer_id
GROUP BY
    crs.customer_id;

-- Paso 3: Crear una CTE (Common Table Expression) y el Informe Final
WITH customer_summary_report AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM
        customer_rental_summary crs  -- La Vista
    JOIN
        customer_payment_summary cps ON crs.customer_id = cps.customer_id -- La Tabla Temporal
)
-- Generar el informe de resumen del cliente final
SELECT
    csr.customer_name,
    csr.email,
    csr.rental_count,
    csr.total_paid,
    -- Columna derivada: total_paid / rental_count
    ROUND(csr.total_paid / csr.rental_count, 2) AS average_payment_per_rental
FROM
    customer_summary_report csr
ORDER BY
    csr.customer_name;
    
-- Opcional: Eliminar la Vista y la Tabla Temporal
DROP VIEW IF EXISTS customer_rental_summary;
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

