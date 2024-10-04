USE sakila;

-- QUESTION 1:

CREATE VIEW cust_rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer AS c
INNER JOIN rental AS r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

-- QUESTION 2: 

CREATE TEMPORARY TABLE cust_total_paid AS
SELECT crs.customer_id, crs.customer_name, crs.email, crs.rental_count, SUM(p.amount) AS total_paid 
FROM customer_rental_summary AS crs
INNER JOIN payment AS p
ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.customer_name, crs.email, crs.rental_count;

-- QUESTION 3:

WITH cust_payment_summary AS (
    SELECT crs.customer_name, crs.email, crs.rental_count, ctp.total_paid
    
    FROM cust_rental_summary AS crs
    JOIN cust_total_paid AS ctp
    ON crs.customer_id = ctp.customer_id
)
SELECT customer_name, email, rental_count, total_paid, (total_paid/rental_count) AS average_payment_per_rental
FROM cust_payment_summary;


