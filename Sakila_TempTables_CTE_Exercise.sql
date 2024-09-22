
-- Step 1: Crear una vista que resuma la información de alquiler para cada cliente
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Step 2: Crear una tabla temporal que calcule el monto total pagado por cada cliente
CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

-- Step 3: Crear un CTE que combine la vista y la tabla temporal para generar el informe final
WITH customer_summary AS (
    SELECT 
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM rental_summary rs
    JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT * FROM customer_summary;
