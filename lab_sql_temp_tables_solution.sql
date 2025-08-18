USE sakila;
CREATE VIEW rental_information AS
SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS total_rentals
FROM CUSTOMER
INNER JOIN RENTAL
USING (customer_id)
GROUP BY customer_id
ORDER BY total_rentals DESC;

DROP VIEW rental_information;
SELECT *
FROM rental_information;

#STEP 2: create temporary table
CREATE TEMPORARY TABLE total_paid AS
SELECT customer_id, first_name, last_name, email, SUM(amount) AS total_payments
FROM rental_information
INNER JOIN payment
USING(customer_id)
GROUP BY (customer_id)
ORDER BY total_payments DESC;

SELECT *
FROM total_paid;

#STEP 3: CREATE CTE (WITH....)
WITH customer_summary_report AS (
    SELECT total_paid.first_name, total_paid.last_name, total_paid.email, total_payments, total_rentals
    FROM total_paid
    INNER JOIN rental_information
    USING(customer_id)
    
)
SELECT *, total_payments/total_rentals AS average_payment_per_rental
FROM customer_summary_report;

