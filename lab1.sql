CREATE VIEW customer_rental_summary AS
SELECT 
  c.customer_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.email,
  COUNT(*) AS rental_count
FROM 
  customer AS c
  JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY 
  c.customer_id;


CREATE TEMPORARY TABLE customer_payment_summary AS (
  SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
  FROM 
    customer_rental_summary AS crs
    JOIN rental AS r ON crs.customer_id = r.customer_id
    JOIN payment AS p ON r.rental_id = p.rental_id
  GROUP BY 
    crs.customer_id
);

WITH customer_summary_report AS (
  SELECT 
    crs.customer_name,
    crs.email,
    crs.rental_count,
    cps.total_paid
  FROM 
    customer_rental_summary AS crs
    JOIN customer_payment_summary AS cps ON crs.customer_id = cps.customer_id
)

SELECT 
  *,
  total_paid / rental_count AS average_payment_per_rental
FROM 
  customer_summary_report
ORDER BY 
  rental_count DESC;


