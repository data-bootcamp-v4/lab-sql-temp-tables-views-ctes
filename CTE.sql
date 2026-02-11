CREATE VIEW customer_rental_summary AS
SELECT 
    customer.customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
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


CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    customer_rental_summary.customer_id,
    SUM(payment.amount) AS total_paid
FROM customer_rental_summary
LEFT JOIN payment 
    ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;


WITH customer_summary_cte AS (
    SELECT
        customer_rental_summary.customer_name,
        customer_rental_summary.email,
        customer_rental_summary.rental_count,
        customer_payment_summary.total_paid
    FROM customer_rental_summary
    LEFT JOIN customer_payment_summary
        ON customer_rental_summary.customer_id = customer_payment_summary.customer_id
)

SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(
        CASE 
            WHEN rental_count = 0 THEN 0
            ELSE total_paid / rental_count
        END
    , 2) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;
