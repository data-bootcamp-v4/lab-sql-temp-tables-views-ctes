USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
-- calculate the total amount paid by each customer.

-- sum(payment amount), customer id, 

CREATE TEMPORARY TABLE bank.total_paid_1
SELECT p.customer_id, SUM(p.amount) AS total_amount
FROM payment AS p
JOIN rental AS r
ON p.customer_id = r.customer_id
GROUP BY p.customer_id;

select * from bank.total_paid_1;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_pay_summary AS (SELECT crs.customer_id, crs.customer_name, crs.email, crs.rental_count, total_amount
								FROM customer_rental_summary AS crs
								LEFT JOIN bank.total_paid_1 AS tp ON crs.customer_id = tp.customer_id) 
                                SELECT * FROM customer_pay_summary;
                                
-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.

WITH customer_pay_summary AS (SELECT crs.customer_id, crs.customer_name, crs.email, crs.rental_count, total_amount, AVG(total_amount/rental_count) AS avg_payment_per_rental
								FROM customer_rental_summary AS crs
								LEFT JOIN bank.total_paid_1 AS tp ON crs.customer_id = tp.customer_id) 
						SELECT * FROM customer_pay_summary;
                        
WITH customer_pay_summary AS (
    SELECT 
        crs.customer_id, 
        crs.customer_name, 
        crs.email, 
        crs.rental_count, 
        total_amount, 
        ROUND(AVG(total_amount/crs.rental_count),2) AS avg_payment_per_rental
    FROM 
        customer_rental_summary AS crs
    LEFT JOIN 
        bank.total_paid_1 AS tp ON crs.customer_id = tp.customer_id
	GROUP BY
		crs.customer_id, 
        crs.customer_name, 
        crs.email, 
        crs.rental_count, 
        total_amount) 
SELECT * FROM customer_pay_summary;



