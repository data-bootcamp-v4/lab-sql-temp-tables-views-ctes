-- 1 Crear una vista
USE sakila;
DROP VIEW IF EXISTS rental_summary;

CREATE VIEW rental_summary AS
SELECT 
c.customer_id, 
CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
c.email, 
COUNT(r.rental_id) AS rental_count
FROM 
customer c
JOIN 
rental r
ON 
c.customer_id = r.customer_id
GROUP BY 
c.customer_id, c.first_name, c.last_name, c.email;

-- 2 Crear tabla temporal
DROP TEMPORARY TABLE IF EXISTS payment_summary;
CREATE TEMPORARY TABLE payment_summary AS
SELECT 
rs.customer_id, 
rs.customer_name, 
rs.email, 
rs.rental_count, 
SUM(p.amount) AS total_paid
FROM 
rental_summary rs
JOIN 
payment p
ON 
rs.customer_id = p.customer_id
GROUP BY 
rs.customer_id, rs.customer_name, rs.email, rs.rental_count;

-- 3 CTE

WITH customer_report AS (
SELECT 
ps.customer_id,
ps.customer_name,
ps.email,
ps.rental_count,
ps.total_paid,
(ps.total_paid / ps.rental_count) AS payment_per_rental
FROM 
payment_summary ps
)
SELECT 
customer_name AS name, 
email, 
rental_count, 
total_paid, 
(total_paid / rental_count) AS average_payment_per_rental 
FROM 
customer_report
ORDER BY 
total_paid DESC; 




