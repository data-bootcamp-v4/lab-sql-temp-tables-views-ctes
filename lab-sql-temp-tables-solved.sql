USE sakila;

DROP VIEW IF EXISTS rental_summary;

CREATE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;


DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
INNER JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

WITH customer_report AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        cps.total_paid
    FROM rental_summary rs
    INNER JOIN customer_payment_summary cps
        ON rs.customer_id = cps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_report
ORDER BY total_paid DESC;