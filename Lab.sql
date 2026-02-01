USE sakila;

CREATE VIEW resumen_renta_cliente AS 
SELECT
c.customer_id,
c.first_name,
c.last_name,
c.email,
COUNT(r.rental_id) AS conteo_renta
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name,
c.email;

SELECT * FROM resumen_renta_cliente
LIMIT 10;

CREATE TEMPORARY TABLE total_pagado_cliente AS
SELECT
rrs.customer_id,
SUM(amount) AS total_pagado
FROM resumen_renta_cliente rrs
LEFT JOIN payment p
ON rrs.customer_id = p.customer_id
GROUP BY
rrs.customer_id;

SELECT * FROM resumen_renta_cliente
LIMIT 10;

WITH cte_resumen_cliente AS (
SELECT 
rrs.first_name,
rrs.last_name,
rrs.email,
rrs.conteo_renta,
tpc.total_pagado
FROM resumen_renta_cliente rrs
JOIN total_pagado_cliente tpc
ON rrs.customer_id = tpc.customer_id
)
SELECT 
first_name,
last_name,
email,
conteo_renta,
total_pagado,
total_pagado/conteo_renta AS pago_alquiler_promedio
FROM cte_resumen_cliente;