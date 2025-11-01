
CREATE TEMPORARY TABLE customer_summary_temp AS
SELECT cs.customer_id, cs.first_name, cs.last_name, cs.email, cs.rental_count, SUM(p.amount) AS total_paid FROM rental_summary cs
LEFT JOIN payment p 
ON cs.customer_id=p.customer_id
GROUP BY cs.customer_id
;
SELECT * FROM customer_summary_temp;