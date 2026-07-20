
-- Step 1: Make a view with the customer details and the number of rentals per customer.
CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;

-- Step 2: Make a temporary table with the total amount paid by each customer.
DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_paid
FROM customer_rental_summary AS crs
LEFT JOIN payment AS p
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

-- Step 3: Join the view and the temporary table in a CTE and create the final customer summary.
WITH customer_summary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary AS crs
    JOIN customer_payment_summary AS cps
        ON crs.customer_id = cps.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(
        CASE
            WHEN rental_count = 0 THEN 0
            ELSE total_paid / rental_count
        END,
        2
    ) AS average_payment_per_rental
FROM customer_summary
ORDER BY customer_name;