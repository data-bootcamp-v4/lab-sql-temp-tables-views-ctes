-- Primero, cree una vista que resuma la información de alquiler por cliente
create or replace view customer_summary as
select
  c.customer_id,
  c.first_name,
  c.email,
  count(rental_id) as rental_count
from sakila.customer as c
left join sakila.rental as r
using (customer_id)
group by
  c.customer_id,
  c.first_name,
  c.email;
  
  -- Paso 2: Crear una tabla temporal con pagos totales por cliente
  
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 	
    cs.customer_id,
    cs.first_name,
    cs.email,
    cs.rental_count,
    SUM(p.amount) AS total_paid
FROM sakila.customer_summary AS cs
LEFT JOIN sakila.payment AS p USING (customer_id)
GROUP BY
    cs.customer_id,
    cs.first_name,
    cs.email,
    cs.rental_count;
    
-- Crear una CTE y el reporte combinado de clientes
SELECT 
    cs.*,
    ps.total_paid
FROM customer_summary AS cs
INNER JOIN payment_summary AS ps
    ON cs.customer_id = ps.customer_id;


    
