USE sakila;


#1. First, create a view that summarizes rental information for each customer. 
#   The view should include the customer's ID, name, email address, and total number of rentals (rental_count)

SELECT *
FROM rental;

DROP VIEW IF EXISTS customer_rental;
CREATE VIEW customer_rental AS
SELECT rental.customer_id, CONCAT(customer.first_name, " ", customer.last_name) AS name, customer.email, COUNT(rental.rental_id) AS rental_count
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id, customer.first_name, customer.last_name, customer.email;

SELECT *
FROM customer_rental;

#2. Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#   The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
#   and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE temp_total_paid AS
SELECT customer_rental.customer_id, customer_rental.name, customer_rental.email, customer_rental.rental_count, SUM(amount) AS total_payments
FROM customer_rental
INNER JOIN payment ON customer_rental.customer_id = payment.customer_id
GROUP BY customer_rental.customer_id;

SELECT * 
FROM temp_total_paid;

#3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#   The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH sakila_cte AS (
    SELECT cr.customer_id,
           cr.name,
           cr.email,
           ttp.rental_count,
           ttp.total_payments
    FROM customer_rental cr
    INNER JOIN temp_total_paid ttp ON cr.customer_id = ttp.customer_id
)
SELECT *
FROM sakila_cte;

