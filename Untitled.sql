USE sakila;

# Create a View
CREATE VIEW customer_rental_summary AS
SELECT customer_id,CONCAT(first_name, ' ', last_name) AS customer_name, email, COUNT(rental_id) AS rental_count
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer_id, customer_name, email;

# now the table would be in the sakila and we can access it. this table would be permanent inside sakila except we drop it out.
SELECT *
FROM customer_rental_summary;

#Create a Temporary Table    
CREATE TEMPORARY TABLE payment_summary AS
SELECT customer_id, customer_name, SUM(payment.amount) AS total_ampount_paid
FROM customer_rental_summary
INNER JOIN payment
USING (customer_id)
GROUP BY customer_id, customer_name;

SELECT *
FROM payment_summary;

# Create a CTE and the Customer Summary Report
WITH payment_summary AS (
    SELECT customer_name, email, rental_count, total_amount_paid, total_amount_paid / rental_count AS average_payment_per_rental
    FROM customer_rental_salary
    INNER JOIN payment_summary
    USING (customer_id)
)
SELECT customer_name, email, rental_count, total__amount_paid, average_payment_per_rental
FROM customer_summary;


-- Step 3: Create a CTE and the Customer Summary Report

-- Create a CTE to join the rental summary view with the payment summary temporary table
WITH sakila_cte AS (
    SELECT cr.customer_id,cr.customer_name, cr.email, cr.total_rental, ps.total_amount_paid,
    FROM customer_rental_summary cr
    INNER JOIN payment_summary ps 
    ON crs.customer_id = ps.customer_id)
-- Generate the final customer summary report
SELECT customer_name, email, total_rental, total_amount_paid, total_amount_paid / total_rental AS average_payment_per_rental
FROM sakila_cte;


