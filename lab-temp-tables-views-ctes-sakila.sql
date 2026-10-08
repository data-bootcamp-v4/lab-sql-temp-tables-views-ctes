USE sakila;

-- ===========================================
-- Step 1 - View
-- ===========================================
SELECT * FROM rental; -- customer_id
SELECT * FROM customer; -- customer_id

SELECT c.customer_id, c.first_name, c.email, COUNT(r.rental_id) AS rental_count
FROM rental AS r
	JOIN customer AS c
		ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.email
;

-- Create VIEW
CREATE VIEW view_customer_rental_info AS
SELECT c.customer_id, c.first_name, c.email, COUNT(r.rental_id) AS rental_count
FROM rental AS r
	JOIN customer AS c
		ON r.customer_id = c.customer_id
GROUP BY c.cusview_customer_rental_infotomer_id, c.first_name, c.email
;

SELECT * FROM view_customer_rental_info;

-- ===========================================
-- Step 2 - Temporary table
-- ===========================================
SELECT * FROM payment;

SELECT vc.customer_id, SUM(p.amount) AS total_paid
FROM view_customer_rental_info AS vc
	JOIN payment AS p
		ON vc.customer_id = p.customer_id
GROUP BY vc.customer_id;

-- Create TEMP TABLE
CREATE TEMPORARY TABLE temp_rental_summary AS
SELECT vc.customer_id, SUM(p.amount) AS total_paid
FROM view_customer_rental_info AS vc
	JOIN payment AS p
		ON vc.customer_id = p.customer_id
GROUP BY vc.customer_id;

SELECT * FROM temp_rental_summary;


-- ===========================================
-- Step 3 - CTE
-- ===========================================
SELECT * FROM view_customer_rental_info;
SELECT * FROM temp_rental_summary;

SELECT vc.first_name, vc.email, vc.rental_count, tr.total_paid, ROUND((tr.total_paid/vc.rental_count),2) AS average_payment_per_rental
FROM view_customer_rental_info AS vc
	JOIN temp_rental_summary AS tr
		ON vc.customer_id = tr.customer_id;        

-- Create CTE
WITH cte_customer_summary AS (
	SELECT vc.first_name, vc.email, vc.rental_count, tr.total_paid, ROUND((tr.total_paid/vc.rental_count),2) AS average_payment_per_rental
	FROM view_customer_rental_info AS vc
		JOIN temp_rental_summary AS tr
			ON vc.customer_id = tr.customer_id
)
# Now we call the cte
SELECT first_name, email, rental_count, total_paid, average_payment_per_rental
FROM cte_customer_summary;



