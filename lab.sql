use sakila;

-- Script 1

CREATE OR REPLACE VIEW rental_summary AS
SELECT
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.email,
  COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

select * from rental_summary;

-- Script 2

CREATE TEMPORARY TABLE temp_payment_summary AS
SELECT
  p.customer_id,
  COALESCE(SUM(p.amount), 0) AS total_paid
FROM payment p
GROUP BY p.customer_id;

select * from temp_payment_summary;

-- Script 3

WITH rental_summary AS (
  SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
  FROM customer c
  LEFT JOIN rental r ON c.customer_id = r.customer_id
  GROUP BY c.customer_id, customer_name, c.email
),
payment_summary AS (
  SELECT
    p.customer_id,
    COALESCE(SUM(p.amount), 0) AS total_paid
  FROM payment p
  GROUP BY p.customer_id
)
SELECT
  r.customer_id,
  r.customer_name,
  r.email,
  COALESCE(r.rental_count, 0)         AS rental_count,
  COALESCE(p.total_paid, 0.00)       AS total_paid
FROM rental_summary r
LEFT JOIN payment_summary p ON r.customer_id = p.customer_id
ORDER BY r.customer_id;






