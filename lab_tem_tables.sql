# Create View 

CREATE VIEW rental_summary AS
SELECT 
	customer.customer_id, 
    customer.first_name,
    customer.last_name,
    customer.email,
    COUNT(rental.rental_id) AS total_rentals
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY 
	customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email;

# Create a temporary table

CREATE TEMPORARY TABLE payment_report_summary AS
SELECT 
	payment.customer_id,
	SUM(payment.amount) as total_payments
FROM payment
JOIN rental_summary ON payment.customer_id = rental_summary.customer_id
GROUP BY payment.customer_id;

# Create CTE

WITH customer_summary_report AS (
	SELECT
		rental_summary.customer_id, 
		rental_summary.first_name,
		rental_summary.last_name,
		rental_summary.email,
		rental_summary.total_rentals,
		payment_report_summary.total_payments,
        ROUND(payment_report_summary.total_payments / rental_summary.total_rentals, 2) AS average_payment_per_rental
    FROM rental_summary
    JOIN payment_report_summary ON rental_summary.customer_id = payment_report_summary.customer_id
    )
SELECT * FROM customer_summary_report;