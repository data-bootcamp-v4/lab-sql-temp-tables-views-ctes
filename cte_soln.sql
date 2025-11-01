WITH customer_summary_cte AS (
SELECT cst.first_name, cst.last_name, cst.email, cst.rental_count, cst.total_paid FROM customer_summary_temp cst 
LEFT JOIN rental_summary rs 
ON cst.customer_id=rs.customer_id )

SELECT first_name, last_name, email, rental_count, total_paid, (total_paid/rental_count) AS average_payment_per_rental FROM customer_summary_cte
; 