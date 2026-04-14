USE sakila;
#Step 1: Create a View.
CREATE VIEW customer_rental_summary AS
SELECT 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM customer
LEFT JOIN rental 
    ON customer.customer_id = rental.customer_id
GROUP BY 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email;
    
#Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    customer_rental_summary.customer_id,
    customer_rental_summary.first_name,
    customer_rental_summary.last_name,
    customer_rental_summary.email,
    customer_rental_summary.rental_count,
    SUM(payment.amount) AS total_paid
FROM customer_rental_summary
LEFT JOIN payment 
    ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY 
    customer_rental_summary.customer_id,
    customer_rental_summary.first_name,
    customer_rental_summary.last_name,
    customer_rental_summary.email,
    customer_rental_summary.rental_count;
    
#- Step 3: Create a CTE and the Customer Summary Report
WITH customer_summary_cte AS (
    SELECT 
        customer_rental_summary.customer_id,
        customer_rental_summary.first_name,
        customer_rental_summary.last_name,
        customer_rental_summary.email,
        customer_rental_summary.rental_count,
        customer_payment_summary.total_paid
    FROM customer_rental_summary
    JOIN customer_payment_summary
        ON customer_rental_summary.customer_id = customer_payment_summary.customer_id
)
SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid
FROM customer_summary_cte;

##Last step
WITH customer_summary_cte AS (
    SELECT 
        customer_rental_summary.customer_id,
        customer_rental_summary.first_name,
        customer_rental_summary.last_name,
        customer_rental_summary.email,
        customer_rental_summary.rental_count,
        customer_payment_summary.total_paid
    FROM customer_rental_summary
    JOIN customer_payment_summary
        ON customer_rental_summary.customer_id = customer_payment_summary.customer_id
)

SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    total_paid / NULLIF(rental_count, 0) AS average_payment_per_rental
FROM customer_summary_cte;











