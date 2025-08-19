USE sakila;

-- =========================
-- Step 1: View (rental summary per customer)
-- =========================
DROP VIEW IF EXISTS v_customer_rental_summary;
CREATE VIEW v_customer_rental_summary AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  COUNT(r.rental_id) AS rental_count           -- includes 0 if no rentals
FROM customer c
LEFT JOIN rental r
  ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- Quick check (optional)
-- SELECT * FROM v_customer_rental_summary ORDER BY rental_count DESC LIMIT 5;


-- =========================
-- Step 2: Temporary table (total paid per customer)
-- =========================
DROP TEMPORARY TABLE IF EXISTS tmp_customer_payments;
CREATE TEMPORARY TABLE tmp_customer_payments AS
SELECT
  v.customer_id,
  ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p
  ON p.customer_id = v.customer_id
GROUP BY v.customer_id;

-- Quick check (optional)
-- SELECT * FROM tmp_customer_payments ORDER BY total_paid DESC LIMIT 5;


-- =========================
-- Step 3: CTE + Final Customer Summary Report
-- =========================
WITH customer_summary AS (
  SELECT
    v.customer_id,
    CONCAT(v.first_name, ' ', v.last_name) AS customer_name,
    v.email,
    v.rental_count,
    COALESCE(t.total_paid, 0) AS total_paid
  FROM v_customer_rental_summary v
  LEFT JOIN tmp_customer_payments t
    ON t.customer_id = v.customer_id
)
SELECT
  customer_name,
  email,
  rental_count,
  total_paid,
  ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, customer_name;
