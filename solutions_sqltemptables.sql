USE sakila;
-- Sakila Lab: Temporary Tables, Views, and CTEs
-- Run in MySQL Workbench with the 'sakila' schema loaded.

/* =====================================================
   STEP 0 — Use the database
   ===================================================== */
USE sakila;

/* =====================================================
   STEP 1 — Create a View: customer rental summary
   - Includes: customer_id, full_name, email, rental_count
   ===================================================== */
DROP VIEW IF EXISTS v_customer_rental_summary;
CREATE VIEW v_customer_rental_summary AS
SELECT 
  cu.customer_id,
  CONCAT(cu.first_name, ' ', cu.last_name) AS full_name,
  cu.email,
  COUNT(r.rental_id) AS rental_count
FROM customer cu
LEFT JOIN rental r 
  ON r.customer_id = cu.customer_id
GROUP BY cu.customer_id, full_name, cu.email;

-- Quick check (optional):
-- SELECT * FROM v_customer_rental_summary ORDER BY rental_count DESC, full_name LIMIT 10;

/* =====================================================
   STEP 2 — Create a Temporary Table: total paid per customer
   - Uses the view from Step 1 joined to payments
   - Stores: customer_id, total_paid
   - Note: TEMPORARY tables exist only in this session
   ===================================================== */
DROP TEMPORARY TABLE IF EXISTS temp_customer_payments;
CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT 
  v.customer_id,
  COALESCE(SUM(p.amount), 0) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p 
  ON p.customer_id = v.customer_id
GROUP BY v.customer_id;

-- Quick check (optional):
-- SELECT * FROM temp_customer_payments ORDER BY total_paid DESC LIMIT 10;

/* =====================================================
   STEP 3 — CTE and Final Customer Summary Report
   - Join the View and the Temporary Table
   - Output: customer_name, email, rental_count, total_paid, average_payment_per_rental
   ===================================================== */
WITH customer_summary AS (
  SELECT 
    v.customer_id,
    v.full_name,
    v.email,
    v.rental_count,
    t.total_paid
  FROM v_customer_rental_summary v
  LEFT JOIN temp_customer_payments t
    ON t.customer_id = v.customer_id
)
SELECT
  full_name AS customer_name,
  email,
  rental_count,
  total_paid,
  CASE 
    WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
    ELSE 0
  END AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, rental_count DESC, customer_name;

-- (Optional) Create a view for the final report if you want to reuse it:
-- CREATE OR REPLACE VIEW v_customer_summary_report AS
-- SELECT
--   full_name AS customer_name,
--   email,
--   rental_count,
--   total_paid,
--   CASE 
--     WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
--     ELSE 0
--   END AS average_payment_per_rental
-- FROM customer_summary;
DROP VIEW IF EXISTS v_customer_rental_summary;

CREATE VIEW v_customer_rental_summary AS
SELECT 
  cu.customer_id,
  CONCAT(cu.first_name, ' ', cu.last_name) AS full_name,
  cu.email,
  COUNT(r.rental_id) AS rental_count
FROM customer cu
LEFT JOIN rental r 
  ON r.customer_id = cu.customer_id
GROUP BY cu.customer_id, full_name, cu.email;
DROP TEMPORARY TABLE IF EXISTS temp_customer_payments;

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT 
  v.customer_id,
  COALESCE(SUM(p.amount), 0) AS total_paid
FROM v_customer_rental_summary v
LEFT JOIN payment p 
  ON p.customer_id = v.customer_id
GROUP BY v.customer_id;
SELECT * 
FROM temp_customer_payments
ORDER BY total_paid DESC
LIMIT 10;
WITH customer_summary AS (
  SELECT 
    v.customer_id,
    v.full_name,
    v.email,
    v.rental_count,
    t.total_paid
  FROM v_customer_rental_summary v
  LEFT JOIN temp_customer_payments t
    ON t.customer_id = v.customer_id
)
SELECT
  full_name AS customer_name,
  email,
  rental_count,
  total_paid,
  CASE 
    WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
    ELSE 0
  END AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC, rental_count DESC, customer_name;
