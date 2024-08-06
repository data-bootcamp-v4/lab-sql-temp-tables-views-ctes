USE sakila;
#step_1
CREATE VIEW rental_info AS
			SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS name, c.email, COUNT(r.rental_id) AS rental_count
            FROM customer c
            JOIN rental r
            ON c.customer_id = r.customer_id
            GROUP BY c.customer_id;
            
SELECT * FROM rental_info;

#step_2
CREATE TEMPORARY TABLE total_paid AS
			SELECT r.*, SUM(p.amount) as total_paid_amount
            FROM PAYMENT p
            JOIN rental_info r
            ON r.customer_id = p.customer_id
            GROUP BY p.customer_id;
 
 SELECT * FROM total_paid;
 
 #step_3
 WITH customer_summary_report AS
			(SELECT r.*, SUM(p.amount) as total_paid_amount
            FROM PAYMENT p
            JOIN rental_info r
            ON r.customer_id = p.customer_id
            GROUP BY p.customer_id)
SELECT *, (total_paid_amount / rental_count) AS average_payment_rental
FROM customer_summary_report;