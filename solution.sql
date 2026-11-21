USE sakila;

-- Paso 1: vista con el resumen de alquileres de cada cliente
-- uno customer con rental y cuento cuantos alquileres tiene cada uno
CREATE OR REPLACE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, " ", c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

-- compruebo que la vista funciona
SELECT * FROM rental_summary;

-- Paso 2: tabla temporal con el total pagado por cada cliente
-- uno la vista del paso 1 con payment por customer_id y sumo los amount
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

-- compruebo la tabla temporal
SELECT * FROM customer_payment_summary;

-- Paso 3: CTE que junta la vista (alquileres) con la tabla temporal (pagos)
-- y debajo la consulta final con el pago medio por alquiler
WITH customer_summary AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    JOIN customer_payment_summary cps ON rs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;