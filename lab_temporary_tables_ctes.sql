USE sakila; 
-- alquiler de películas table rental, film 

-- 1 Creación de un informe de resumen del cliente - VIEW
-- historial de alquiler rental y detalles de pago payment 

CREATE VIEW info_alquiler AS 
SELECT
c.customer_id,
c.first_name,
c.last_name, 
c.email, 
COUNT(r.rental_id) AS rental_count
FROM customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY rental_count;

-- 2 Tabla temporal 
-- total_paid por cada cliente payment 

CREATE TEMPORARY TABLE info_pago AS
SELECT 
ia.customer_id, 
SUM(p.amount) AS total_paid
FROM info_alquiler ia
INNER JOIN payment p 
ON ia.customer_id=p.customer_id
GROUP BY ia.customer_id 
ORDER BY total_paid; 

-- 3 CTE. Nombre cliente , email , total_paid 

WITH info_customer AS (
	SELECT 
    ia.first_name,
    ia.last_name,
    ia.email,
    ia.rental_count, 
    ip.total_paid,
    ROUND(ip.total_paid/ia.rental_count,2) AS media_pago
    FROM info_alquiler ia
    INNER JOIN info_pago ip
    ON ia.customer_id=ip.customer_id
)
SELECT
first_name, 
last_name,
email, 
rental_count,
total_paid, 
media_pago
FROM info_customer
ORDER BY total_paid DESC; 

