-- create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
USE sakila;

SHOW TABLES;

SELECT * FROM rental;

SELECT * FROM customer;

CREATE VIEW customer_summary AS
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer as c
JOIN rental as r
ON c.customer_id = r.customer_id
GROUP BY 
c.customer_id,
c.first_name,
c.last_name,
c.email;

SELECT * FROM customer_summary
LIMIT 10;


-- create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

DESCRIBE payment;

CREATE TEMPORARY TABLE customer_payment AS
	SELECT
		cs.customer_id,
		SUM(p.amount) AS total_paid
	FROM customer_summary AS cs
	JOIN payment AS p
		ON cs.customer_id = p.customer_id
	GROUP BY cs.customer_id;
    
    SELECT * FROM customer_payment
    LIMIT 10;
    
    SELECT COUNT(*) 
    FROM customer_payment;
    
  -- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
  -- generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental.
  
  DESCRIBE customer_summary;
  DESCRIBE customer_payment;
    
    WITH customer_report AS (
    SELECT
        CONCAT(cs.first_name, ' ', cs.last_name) AS customer_name,
        cs.email,
        cs.rental_count,
        cp.total_paid
    FROM customer_summary AS cs
    JOIN customer_payment AS cp
        ON cs.customer_id = cp.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_report
ORDER BY total_paid DESC;
    


 