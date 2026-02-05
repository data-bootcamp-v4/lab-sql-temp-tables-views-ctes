

-- 1: 

CREATE VIEW customer_rental AS 
SELECT c.customer_id,
       c.first_name, 
       c.last_name,
       c.email,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id 
GROUP BY c.customer_id;

--  2: 
CREATE TEMPORARY TABLE customer_payment AS
SELECT cr.customer_id,
       SUM(p.amount) AS total_paid
FROM customer_rental AS cr
JOIN payment AS p ON cr.customer_id = p.customer_id
GROUP BY cr.customer_id;

--  3:
WITH cte_summary AS ( 
    SELECT cr.first_name,
           cr.last_name,
           cr.email,
           cr.rental_count,
           cp.total_paid
    FROM customer_rental AS cr
    JOIN customer_payment AS cp ON cr.customer_id = cp.customer_id
)
SELECT first_name,
       last_name,
       email,
       rental_count,
       total_paid,
       total_paid / rental_count AS average_payment_per_rental
FROM cte_summary;
