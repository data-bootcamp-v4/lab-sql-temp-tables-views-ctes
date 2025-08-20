USE sakila;

-- create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count)

SELECT * 
FROM customer; -- customer_id, first_name, last_name, email

SELECT *
FROM rental; -- customer_id, rental_date

CREATE VIEW customer_rental_count AS (
SELECT c.customer_id, 
	   c.first_name, 
       c.last_name, 
       email, 
       COUNT(r.rental_date) AS rental_count
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email);

SELECT * FROM customer_rental_count;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 
-- to join with the payment table and calculate the total amount paid by each customer.


CREATE TEMPORARY TABLE customer_total_payment
SELECT p.customer_id, SUM(p.amount) AS total_paid, c.first_name, c.last_name
FROM payment AS p
INNER JOIN customer_rental_count AS c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name; 

SELECT * FROM customer_total_payment
ORDER BY total_paid DESC;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

-- using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.

SELECT * FROM customer_rental_count;
SELECT * FROM customer_total_payment;

WITH cte_customer_info AS (
SELECT cr.first_name, 
	   cr.last_name, 
       cr.email, 
       cr.rental_count, 
       ct.total_paid
FROM customer_rental_count as cr
INNER JOIN customer_total_payment as ct
ON cr.customer_id = ct.customer_id)


SELECT first_name, 
	   last_name, 
       email, 
       rental_count, 
       total_paid, 
       total_paid / rental_count AS avg_payment
FROM cte_customer_info;
