USE sakila;

# 1

SELECT * FROM customer;
SELECT * FROM rental;

CREATE VIEW rental_summary AS
SELECT 
	c.customer_id, 
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email, 
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY rental_count DESC;

SELECT * FROM rental_summary;

# 2

SELECT * FROM payment;

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
	rs.customer_id,
	rs.first_name,
    rs.last_name,
    rs.email,
    rs.rental_count,
    SUM(amount) as total_paid
FROM rental_summary AS rs
LEFT JOIN payment AS p
ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id, rs.first_name, rs.last_name, rs.email, rs.rental_count
ORDER BY total_paid DESC;


# 3 

WITH customer_summary_report AS(
SELECT 
	CONCAT(cp.first_name, ' ', cp.last_name) AS name,
    cp.email,
    rs.rental_count,
    cp.total_paid,
    ROUND(cp.total_paid / rs.rental_count, 2) AS avg_payment_per_rental
FROM temp_customer_payments AS cp
JOIN rental_summary AS rs
ON cp.customer_id = rs.customer_id
ORDER BY avg_payment_per_rental DESC
);



