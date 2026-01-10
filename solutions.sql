-- solutions.sql
-- Temporary Tables, Views and CTEs Lab (Sakila)

USE sakila;

-- Step 1: Create a View (rental summary per customer)
DROP VIEW IF EXISTS v_customer_rental_summary;

CREATE VIEW v_customer_rental_summary AS
SELECT
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.email,
  COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
  ON c.customer_id = r.customer_id
GROUP BY
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email;

-- Quick check (optional)
-- SELECT * FROM v_customer_rental_summary LIMIT 10;

-- Step 2: Create a Temporary Table (total paid per customer)
-- Uses the view from Step 1 and joins payment
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payment_summary;

CREATE TEMPORARY TABLE tmp_customer_payment_summary AS
SELECT
  v.customer_id,
  ROUND(IFNULL(SUM(p.amount), 0), 2) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p
  ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

-- Quick check (optional)
-- SELECT * FROM tmp_customer_payment_summary LIMIT 10;

-- Step 3: Create a CTE + Final Customer Summary Report
-- Includes derived column avg_payment_per_rental
WITH customer_summary AS (
  SELECT
    v.customer_name,
    v.email,
    v.rental_count,
    t.total_paid,
    CASE
      WHEN v.rental_count = 0 THEN 0
      ELSE ROUND(t.total_paid / v.rental_count, 2)
    END AS average_payment_per_rental
  FROM v_customer_rental_summary v
  JOIN tmp_customer_payment_summary t
    ON v.customer_id = t.customer_id
)
SELECT
  customer_name,
  email,
  rental_count,
  total_paid,
  average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, rental_count DESC, customer_name ASC;
