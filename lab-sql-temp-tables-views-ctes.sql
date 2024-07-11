#lab-sql-temp-tables-views-ctes

USE sakila;

#Step 1: Create a View
#rental_info : customer's ID, name, email, and total COUNT(rental).
CREATE VIEW rental_info AS 
SELECT customer.customer_id, 
CONCAT(first_name, " ", last_name) as customer_name,
email, COUNT(rental_id) as n_rental
FROM customer
INNER JOIN rental
USING (customer_id)
GROUP BY customer.customer_id
ORDER BY n_rental;

SELECT * FROM rental_info;

#Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE total_paid AS (
SELECT rental_info.customer_id, rental_info.customer_name,
rental_info.n_rental, SUM(amount) as total_p
FROM payment
INNER JOIN rental_info
USING (customer_id)
GROUP BY customer_id
ORDER BY total_p DESC);

SELECT * FROM total_paid;

#Step 3: Create a CTE and the Customer Summary Report
WITH customer_rental AS (
SELECT rental_info.customer_name, rental_info.email, 
rental_info.n_rental, total_paid.total_p
FROM rental_info
INNER JOIN total_paid
USING (customer_id))
#add average_payment_per_rental
SELECT *, (total_p / n_rental) AS average_payment_per_rental
FROM customer_rental;

