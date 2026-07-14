USE sakila;

CREATE OR REPLACE VIEW customer_inf AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer AS c
INNER JOIN rental AS r
    ON r.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;
    
    select * from customer_inf
    
USE sakila;

DROP TEMPORARY TABLE IF EXISTS tot_spent;

CREATE TEMPORARY TABLE tot_spent AS
SELECT
    cus_i.customer_id,
    cus_i.first_name,
    cus_i.last_name,
    cus_i.email,
    cus_i.rental_count,
    SUM(p.amount) AS total_paid
FROM customer_inf AS cus_i
INNER JOIN payment AS p
    ON cus_i.customer_id = p.customer_id
GROUP BY
    cus_i.customer_id,
    cus_i.first_name,
    cus_i.last_name,
    cus_i.email,
    cus_i.rental_count;
    
select * from tot_spent



WITH summary AS (
    SELECT AVG(salary) AS average
    FROM employees
)
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT average FROM avg_salary);

WITH customer_summary AS (
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.email,
        c.rental_count,
        t.total_paid
    FROM customer_inf AS c
    INNER JOIN tot_spent AS t
        ON c.customer_id = t.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / NULLIF(rental_count, 0), 2)
        AS average_payment_per_rental
FROM customer_summary
ORDER BY total_paid DESC;

