USE sakila;

CREATE VIEW info_rent AS
SELECT customer.customer_id, CONCAT(customer.first_name," ",customer.last_name), customer.email, COUNT(rental_id)
FROM customer
INNER JOIN rental
ON rental.customer_id = customer.customer_id;

CREATE TEMPORARY TABLE total_paid AS
SELECT SUM(payment.amount)
FROM payment
GROUP BY payment.customer_id;

SELECT * FROM total_paid;
DROP TABLE total_paid;

CREATE TEMPORARY TABLE total_paid AS
SELECT SUM(payment.amount), payment.customer_id
FROM payment
GROUP BY payment.customer_id;

WITH breakdown AS 
SELECT
info_rent.CONCAT(customer.first_name, " ", customer.last_name),
info_rent.email, 
info_rent.COUNT(info_rent.rental_id), 
total_paid.SUM(payment.amount),
FROM info_rent
INNER JOIN total_paid 
ON info_rent.customer_id = total_paid.customer_id
GROUP BY 
full_name, info_rent.email;