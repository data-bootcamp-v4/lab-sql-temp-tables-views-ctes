use sakila;

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    crs.full_name,
    crs.email,
    crs.rental_count,
    IFNULL(SUM(p.amount), 0) AS total_paid
FROM customer_rental_summary AS crs
LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.full_name, crs.email, crs.rental_count;

WITH customer_cte AS (
  SELECT
    crs.customer_id,
    crs.full_name,
    crs.email,
    crs.rental_count,
    IFNULL(cps.total_paid, 0) AS total_paid
  FROM customer_rental_summary AS crs         -- View from Step 1
  LEFT JOIN customer_payment_summary AS cps    -- TEMP TABLE from Step 2
    ON cps.customer_id = crs.customer_id
)

SELECT
  full_name AS customer_name,
  email,
  rental_count,
  total_paid,
  ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_cte
ORDER BY total_paid DESC, rental_count DESC, customer_name;
