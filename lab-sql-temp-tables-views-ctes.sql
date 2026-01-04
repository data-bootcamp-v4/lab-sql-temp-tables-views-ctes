USE sakila;

-- =========================================================
-- Step 1) Create a VIEW: rental summary per customer
-- =========================================================
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

-- =========================================================
-- Step 2) Create a TEMPORARY TABLE: total amount paid per customer
-- =========================================================
DROP TEMPORARY TABLE IF EXISTS temp_customer_payment_summary;

CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT
  v.customer_id,
  ROUND(IFNULL(SUM(p.amount), 0), 2) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p
  ON v.customer_id = p.customer_id
GROUP BY v.customer_id;

-- =========================================================
-- Step 3) Create a CTE joining the VIEW + TEMP table
-- =========================================================
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
  JOIN temp_customer_payment_summary t
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
