CREATE VIEW rental_summary AS
SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email;

SELECT * FROM rental_summary
LIMIT 10;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
	rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p
	ON rs.customer_id = p.customer_id
GROUP BY
	rs.customer_id,
    rs.customer_name,
    rs.email,
    rs.rental_count;

SELECT * FROM customer_payment_summary
LIMIT 10;

WITH customer_summary_cte AS (
	SELECT
		cps.customer_name,
        cps.email,
        cps.rental_count,
        cps.total_paid
	FROM customer_payment_summary cps
    JOIN rental_summary rs
		ON cps.customer_id = rs.customer_id
)

SELECT
	customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2)	AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;