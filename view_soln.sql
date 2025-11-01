
CREATE VIEW rental_summary AS
SELECT r.customer_id, c.first_name, c.last_name, c.email, count(r.rental_id) AS rental_count FROM rental r 
LEFT JOIN customer c 
ON r.customer_id=c.customer_id
GROUP BY r.customer_id;