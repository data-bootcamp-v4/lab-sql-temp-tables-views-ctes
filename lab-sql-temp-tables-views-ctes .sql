use sakila;
-- task 1

select * from rental;

CREATE OR REPLACE VIEW customers AS
SELECT customer.customer_id, first_name, last_name, email, COUNT(rental_id) as 'rental_count'
FROM customer
JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

select * from customers;

-- task 2

select * from payment;

DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT customers.customer_id, customers.first_name, customers.last_name, SUM(payment.amount) AS total_paid
FROM customers
JOIN payment
ON customers.customer_id = payment.customer_id
GROUP BY customers.customer_id, customers.first_name, customers.last_name;

SELECT * FROM customer_payment_summary;

-- task 3
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

WITH customer_summary AS (
    SELECT customers.first_name, customers.last_name, customers.email,
           customers.rental_count, customer_payment_summary.total_paid
    FROM customers
    JOIN customer_payment_summary
    ON customers.customer_id = customer_payment_summary.customer_id
)
SELECT first_name, last_name, email, rental_count, total_paid,
       ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_summary;