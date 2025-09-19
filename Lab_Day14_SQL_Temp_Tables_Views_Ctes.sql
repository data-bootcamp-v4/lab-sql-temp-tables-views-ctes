-- Step 1: Create a view summarizing rental info per customer
CREATE OR REPLACE VIEW customer_rental_summary AS
SELECT 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer.email;

-- Step 2: Create a temporary table with total amount paid per customer
CREATE TEMPORARY TABLE customer_payment_summary
SELECT 
    customer_rental_summary.customer_id,
    SUM(payment.amount) AS total_paid
FROM customer_rental_summary
JOIN payment ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;

-- Step 3: Create CTE and generate final customer summary report
WITH customer_summary AS (
    SELECT 
        rental_view.first_name,
        rental_view.last_name,
        rental_view.email,
        rental_view.rental_count,
        payment_temp.total_paid,
        ROUND(payment_temp.total_paid / rental_view.rental_count, 2) AS average_payment_per_rental
    FROM customer_rental_summary AS rental_view
    JOIN customer_payment_summary AS payment_temp
        ON rental_view.customer_id = payment_temp.customer_id
)
SELECT * FROM customer_summary;
