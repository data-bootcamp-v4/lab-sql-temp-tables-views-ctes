USE sakila;
-- 1 Create a View
create or replace view customer_rental_summary AS 
select c.customer_id,c.first_name, c.last_name,c.email,COUNT(r.rental_id) AS rental_count
from customer c
join rental r
    ON c.customer_id = r.customer_id

GROUP BY

    c.customer_id,

    c.first_name,

    c.last_name,

    c.email;

-- 2 Create a Temporary Table

CREATE TEMPORARY TABLE customer_payment_summary AS
select crs.customer_id,

    crs.first_name,crs.last_name,crs.email,crs.rental_count,

    ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_paid
    FROM customer_rental_summary crs

LEFT JOIN payment p

    ON crs.customer_id = p.customer_id

GROUP BY

    crs.customer_id,crs.first_name,crs.email,crs.rental_count;

-- 3 Create a CTE and the Customer Summary Report

WITH customer_summary_cte AS (
    SELECT
        crs.customer_id,
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        cps.total_paid
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps
        ON crs.customer_id = cps.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;