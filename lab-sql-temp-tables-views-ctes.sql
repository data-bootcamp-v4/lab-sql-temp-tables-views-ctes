USE sakila;
-- 1.
DROP VIEW IF EXISTS CustomerRentalSummary;
CREATE VIEW CustomerRentalSummary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;

-- 2. 
CREATE TEMPORARY TABLE CustomerPaymentSummary AS
SELECT
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    CustomerRentalSummary crs
JOIN
    rental r ON crs.customer_id = r.customer_id
JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY
    crs.customer_id;

-- 3.
WITH CustomerSummary AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        cps.total_paid / crs.rental_count AS average_payment_per_rental
    FROM
        CustomerRentalSummary crs
    JOIN
        CustomerPaymentSummary cps ON crs.customer_id = cps.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    CustomerSummary;
