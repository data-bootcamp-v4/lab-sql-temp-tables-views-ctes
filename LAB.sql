use sakila;

CREATE VIEW customer_rental_summary AS  
SELECT c.customer_id,CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, COUNT(*) AS rental_count 
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY rental_count DESC;

CREATE TEMPORARY TABLE customer_payment_summary AS (
    SELECT crs.customer_id, SUM(p.amount) AS total_paid
    FROM customer_rental_summary AS crs
    JOIN rental AS r ON crs.customer_id = r.customer_id
    JOIN payment AS p ON r.rental_id = p.rental_id
    GROUP BY crs.customer_id
);

WITH cte_customer_table AS(
    SELECT csr.*,tc.total_amount AS total_paid, (tc.total_amount / csr.rental_count) AS average_payment_per_rental
    FROM sakila.customer_summary_report AS csr
    JOIN sakila.temp_customer_table AS tc
    ON csr.customer_id = tc.customer_id
)
SELECT * FROM cte_customer_table;