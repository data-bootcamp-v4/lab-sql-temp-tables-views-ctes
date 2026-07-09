USE sakila;

-- 1. Create a view that summarizes rental information for each customer.
-- The view should include the customer's ID, name, email address, 
-- and total number of rentals (rental_count).

-- create the view
CREATE VIEW rents_per_customer AS
SELECT cu.customer_id, cu.first_name, cu.last_name, cu.email, COUNT(re.rental_id) AS rental_count
FROM customer cu
JOIN rental re
	ON cu.customer_id = re.customer_id
GROUP BY customer_id;

-- use the view
SELECT *
FROM rents_per_customer;

-- 2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid).
-- The Temporary Table should use the rental summary view created in Step 1 to join with
-- the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_total_payment_per_customer AS
SELECT 
	SUM(pa.amount) AS total_paid,
    rents.*
FROM payment pa
JOIN rents_per_customer AS rents
	ON rents.customer_id = pa.customer_id
GROUP BY
	rents.customer_id,
    rents.first_name,
    rents.last_name;


-- 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table
-- created in Step 2. The CTE should include the customer's name, email address, rental count, and 
-- total amount paid.
WITH cte_rental_count_n_total_payment AS( 
	SELECT
		rents.first_name,
        rents.last_name,
        rents.email,
        rents.customer_id,
        rents.rental_count,
        temp.total_paid
	FROM rents_per_customer AS rents
    JOIN temp_total_payment_per_customer AS temp
		ON rents.customer_id = temp.customer_id
)
SELECT *
FROM cte_rental_count_n_total_payment;

--  Using the CTE, create the query to generate the final customer summary report, which should include:
-- customer name, email, rental_count, total_paid and average_payment_per_rental,
-- this last column is a derived column from total_paid and rental_count.

WITH cte_rental_count_n_total_payment AS (
    SELECT
        rents.customer_id,
        rents.first_name,
        rents.last_name,
        rents.email,
        rents.rental_count,
        temp.total_paid
    FROM rents_per_customer AS rents
    JOIN temp_total_payment_per_customer AS temp
        ON rents.customer_id = temp.customer_id
)

SELECT
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM cte_rental_count_n_total_payment
ORDER BY total_paid DESC;