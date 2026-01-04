-- 1
CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.email;

-- 2 
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

-- 3 
WITH customer_summary_cte AS (
    SELECT
        c.first_name,
        c.last_name,
        crs.email,
        crs.rental_count,
        IFNULL(cps.total_paid, 0) AS total_paid
    FROM customer c
    JOIN customer_rental_summary crs
        ON c.customer_id = crs.customer_id
    LEFT JOIN customer_payment_summary cps
        ON c.customer_id = cps.customer_id
 ); 
 

WITH customer_summary_cte AS (
    SELECT
        c.first_name,
        c.last_name,
        crs.email,
        crs.rental_count,
        IFNULL(cps.total_paid, 0) AS total_paid
    FROM customer c
    JOIN customer_rental_summary crs
        ON c.customer_id = crs.customer_id
    LEFT JOIN customer_payment_summary cps
        ON c.customer_id = cps.customer_id
)
SELECT *
FROM customer_summary_cte
ORDER BY total_paid DESC;
