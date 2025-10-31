USE sakila;

-- EJERCICIO 1
-- Paso 1: Crear una vista
-- Cree una vista que resuma la información de alquiler de cada cliente. La vista debe incluir el ID del cliente, el nombre, 
-- la dirección de correo electrónico y el número total de alquileres (rental_count).

CREATE VIEW rental_info AS 
SELECT 
c.customer_id,
c.first_name,
c.email,
COUNT(DISTINCT r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.email;

-- EJERCICIO 2
-- Crear una tabla temporal
-- A continuación, cree una tabla temporal que calcule el importe total pagado por cada cliente (total_paid). 
-- Esta tabla temporal debe utilizar la vista de resumen de alquileres creada en el paso 1 para combinarla con la tabla de pagos y 
-- calcular el importe total pagado por cada cliente.


CREATE TEMPORARY TABLE total_paid AS
SELECT
ri.customer_id,
CAST(SUM(p.amount) AS DECIMAL(10, 2)) AS total_paid
FROM rental_info AS ri
LEFT JOIN payment AS p
ON ri.customer_id = p.customer_id
GROUP BY 
ri.customer_id;


-- EJERCICIO 3
-- Crear un CTE y el Informe de resumen del cliente
-- Cree una CTE que una la vista de resumen de alquiler con la tabla temporal de resumen de pago del cliente creada en el paso 2. 
-- La CTE debe incluir el nombre del cliente, la dirección de correo electrónico, la cantidad de alquileres y el monto total pagado.

WITH rental_info_cte AS (
     SELECT customer_id, first_name, email, rental_count
    FROM rental_info
),
total_paid_cte AS (
    SELECT customer_id, total_paid 
    FROM total_paid
)
SELECT
    ric.first_name,
    ric.email,
    ric.rental_count,
    tpc.total_paid
FROM rental_info_cte AS ric
LEFT JOIN total_paid_cte AS tpc ON ric.customer_id = tpc.customer_id;


-- A continuación, utilizando la CTE, cree la consulta para generar el informe de resumen final del cliente, que debe incluir: 
-- nombre del cliente, correo electrónico, recuento_de_alquileres, total_pagado y pago_promedio_por_alquiler, 
-- esta última columna es una columna derivada de total_pagado y recuento_de_alquileres.

WITH rental_info_cte AS (
     SELECT customer_id, first_name, email, rental_count
    FROM rental_info
),
total_paid_cte AS (
    SELECT customer_id, total_paid 
    FROM total_paid
)
SELECT
ric.first_name AS name,
ric.email AS email,
ric.rental_count AS rental_count,
CAST(tpc.total_paid AS DECIMAL(10, 2)) AS total_paid, 
CAST((tpc.total_paid / ric.rental_count) AS DECIMAL(10, 2)) AS avg_paym_per_rent
FROM rental_info_cte AS ric
LEFT JOIN total_paid_cte AS tpc ON ric.customer_id = tpc.customer_id;









