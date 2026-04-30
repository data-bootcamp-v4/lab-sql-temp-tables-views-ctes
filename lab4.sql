-- ============================================
-- LAB: Tablas Temporales, Vistas y CTEs
-- Base de datos: Sakila
-- ============================================

-- PASO 1: Crear una Vista
-- Resumen de alquileres por cliente (customer_id, nombre, email, total alquileres)

CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


-- PASO 2: Crear una Tabla Temporal
-- Total pagado por cada cliente, uniendo con la vista del paso 1

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id, rs.customer_name, rs.email, rs.rental_count;


-- PASO 3: Crear un CTE y generar el Informe Final

WITH customer_report AS (
    SELECT 
        customer_name,
        email,
        rental_count,
        total_paid
    FROM customer_payment_summary
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_report
ORDER BY total_paid DESC;

