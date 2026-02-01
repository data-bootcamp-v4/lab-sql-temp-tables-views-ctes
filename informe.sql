USE sakila;

-- 1 creación tabla en vista

CREATE VIEW clientes_summary AS
SELECT 
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS Nombre,
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

-- 2 creación tabla temporal 

CREATE TEMPORARY TABLE temp_pago_cliente AS
SELECT 
cl.customer_id,
SUM(p.amount) AS total_paid
FROM clientes_summary AS cl
INNER JOIN payment AS p 
ON cl.customer_id = p.customer_id
GROUP BY cl.customer_id;

SELECT * 
FROM temp_pago_cliente 
LIMIT 1000;

-- creacion CTE

WITH cte_customer_report AS (
    SELECT 
       t.Nombre, 
		cl.email, 
        cl.Arriendos, 
        t.total_paid
    FROM clientes_summary AS cl
    inner JOIN temp_pago_cliente AS t
    ON cl.customer_id = t.customer_id
    )
SELECT 
    CONCAT(first_name, ' ', last_name) AS Nombre,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS pago_promedio
FROM cte_customer_report
ORDER BY total_paid DESC;

WITH cte_resumen_final AS (
    SELECT 
        cl.first_name, 
        cl.last_name, 
        cl.email, 
        cl.rental_count, 
        t.total_paid
    FROM clientes_summary AS cl
    JOIN temp_pago_cliente AS t 
    ON cl.customer_id = t.customer_id
)
SELECT 
    CONCAT(first_name, ' ', last_name) AS Nombre,
    email,
    rental_count,
    total_paid,
    CASE 
        WHEN rental_count > 0 
        THEN ROUND(total_paid / rental_count, 2) 
        ELSE 0 
    END AS prom_pago_renta
FROM cte_resumen_final
ORDER BY total_paid DESC;
