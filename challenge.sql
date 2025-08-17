USE sakila;
--CREATE VIEW--
CREATE VIEW customer_rental_summary AS
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    COUNT(rental_id) AS rental_count
FROM customer
LEFT JOIN rental USING (customer_id)
GROUP BY customer_id, first_name, last_name, email;


--Temporary table--
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    customer_id,
    SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;


--CTE--
WITH customer_summary AS(
    SELECT 
    r.first_name,
    r.last_name,
    r.email,
    r.rental_count,
    COALESCE(p.total_paid, 0) AS total_paid,
    CASE WHEN r.rental_count > 0 THEN COALESCE(P.total_paid, 0) / r.rental_count
ELSE 0 END AS average_payment_per_rental
    FROM customer_rental_summary r
    LEFT JOIN customer_payment_summary p USING (customer_id)

)
SELECT * FROM customer_summary
ORDER BY total_paid DESC
LIMIT 100;
