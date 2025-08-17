USE sakila;

-- 1. View : Rental information for each customer
-- customer's ID, name, email address, and total number of rentals (rental_count)

CREATE VIEW rental_information AS
SELECT c.customer_id,
	   c.first_name,
       c.last_name,
	   c.email,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS R
	ON c.customer_id = r.customer_id
GROUP BY 
	c.customer_id, c.first_name, c.last_name, c.email;



-- 2. Temporary Table : total amount by each customer (total_paid)
-- use the rental summary view created in Step 1 to join with the payment table 
-- calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_customer_payment_summary AS
SELECT 
	ri.customer_id, 
    ri.first_name,
    ri.last_name,
    ri.email, 
    ri.rental_count,
    IFNULL(SUM(p.amount), 0) AS total_paid
FROM rental_information AS ri
LEFT JOIN payment AS p
	ON ri.customer_id = p.customer_id
GROUP BY 
	ri.customer_id, ri.first_name, ri.last_name, ri.email, ri.rental_count;



-- 3. CTE and the Customer Summary Report
-- CTE joins the rental summary View with the customer payment summary Temporary Table. 
-- CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary_cte AS (
	SELECT 
		ri.first_name,
		ri.last_name,
		ri.email, 
		ri.rental_count,
        tcps.total_paid
	FROM rental_information AS ri
    JOIN temp_customer_payment_summary AS tcps
		ON ri.customer_id = tcps.customer_id
)
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    rental_count,
    total_paid,
    CASE 
        WHEN rental_count > 0 THEN ROUND(total_paid / rental_count, 2)
        ELSE 0
    END AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY customer_name;





