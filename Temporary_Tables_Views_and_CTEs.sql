USE sakila;

-- STEP 1: Create a view summarizing rentals per customer
CREATE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

-- STEP 2: Create a temporary table for payment totals
CREATE TEMPORARY TABLE payment_summary AS
SELECT
    customer_id,
    SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;

-- STEP 3: Create a CTE and generate the final report
WITH customer_summary AS (
    SELECT
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM rental_summary rs
    LEFT JOIN payment_summary ps
        ON rs.customer_id = ps.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;