-- 1. Create a view that summarizes rental information for each customer. The view should include the customer's ID, name, 
-- email address, and total number of rentals (rental_count).
USE sakila;
SELECT * FROM customer;
SELECT * FROM rental;

CREATE VIEW v_rental_info_customer AS (
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer AS c
JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
);

SELECT * FROM v_rental_info_customer;

-- 2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use 
-- the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
SELECT * FROM payment;
SELECT * FROM v_rental_info_customer;

CREATE TEMPORARY TABLE tt_total_payment_by_customer AS (
SELECT ric.customer_id, SUM(p.amount) AS total_paid
FROM v_rental_info_customer AS ric
LEFT JOIN payment AS p
ON ric.customer_id = p.customer_id
GROUP BY ric.customer_id
);

SELECT * FROM v_rental_info_customer;
SELECT * FROM tt_total_payment_by_customer;

-- 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
SELECT * FROM v_rental_info_customer;

WITH cte_rental_payment_summary AS (
SELECT ric.first_name, ric.last_name, ric.email, ric.rental_count, pbc.total_paid
FROM v_rental_info_customer AS ric
LEFT JOIN tt_total_payment_by_customer AS pbc
ON ric.customer_id = pbc.customer_id
)

-- 4. Summary report
SELECT *, total_paid / rental_count AS avg_payment_per_rental
FROM cte_rental_payment_summary;
