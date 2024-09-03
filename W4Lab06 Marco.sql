-- Week04 Lab06
-- LAB | Temporary Tables, Views and CTEs
USE sakila;

-- Step 1: Create a View

DROP VIEW customer_rental_info;
CREATE VIEW customer_rental_info AS
SELECT 
    c.customer_id, c.first_name, c.last_name, c.email,
    COUNT(r.customer_id) AS rental_count
FROM 
    sakila.customer AS c
LEFT JOIN 
    sakila.rental AS r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id;

SELECT * FROM customer_rental_info;

-- Step 2: Create a Temporary Table

DROP TEMPORARY TABLE sakila.customer_payment;
CREATE TEMPORARY TABLE sakila.customer_payment
SELECT r.customer_id AS customer_id , COUNT(f.rental_rate) AS rental_count, SUM(f.rental_rate) AS rental_pay
FROM sakila.rental AS r
JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
JOIN sakila.film AS f
ON f.film_id = i.film_id
GROUP BY r.customer_id;

SELECT * FROM sakila.customer_payment;

-- Step 3: Create a CTE and the Customer Summary Report

WITH cte_customer AS (
  SELECT 
    cri.customer_id, cri.first_name, cri.last_name, cri.email, cp.rental_count, cp.rental_pay
    , (cp.rental_pay / cp.rental_count) AS average_pay
  FROM 
    customer_rental_info AS cri 
  JOIN 
    sakila.customer_payment AS cp 
    ON cri.customer_id = cp.customer_id 
)
SELECT * FROM cte_customer;

