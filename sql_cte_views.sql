USE sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW cust_information AS
SELECT 
	c.customer_id,
	COUNT(r.rental_id) as number_rental,
    c.first_name,
    c.email
FROM customer AS c 
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT * FROM sakila.cust_information; 

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_amount AS
SELECT ci.customer_id,
	SUM(p.amount) as total
FROM cust_information AS ci
LEFT JOIN payment AS p ON ci.customer_id = p.customer_id
GROUP BY ci.customer_id;

SELECT * FROM total_amount;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, 
-- rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH  customer_summary as (
	SELECT
		ci.first_name, 
		ci.email, 
        ci.number_rental,
        ta.total,
        ta.total / ci.number_rental as avg_payment
	FROM cust_information AS ci
    LEFT JOIN total_amount AS ta ON ci.customer_id = ta.customer_id
    )
    
SELECT * FROM customer_summary 



