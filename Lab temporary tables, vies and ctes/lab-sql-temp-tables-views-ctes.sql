USE sakila;


-- Ejercicio1 Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_rental_summary AS
SELECT
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email,
    (
        SELECT COUNT(rental.rental_id)
        FROM rental
        WHERE rental.customer_id = customer.customer_id
    ) AS rental_count
FROM customer ;
SELECT *
FROM customer_rental_summary;

-- Ejercicio2Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
    crs.customer_id,
    crs.first_name,
    crs.last_name,
    crs.email,
    crs.rental_count,
    (
        SELECT SUM(p.amount)
        FROM payment AS p
        WHERE p.customer_id = crs.customer_id
    ) AS total_paid
FROM customer_rental_summary AS crs;

-- Ejercicio 3. 

WITH customer_summary AS (
    SELECT
        crs.customer_id,
        crs.first_name,
        crs.last_name,
        crs.email,
        crs.rental_count,
        (
            SELECT cps.total_paid
            FROM customer_payment_summary AS cps
            WHERE cps.customer_id = crs.customer_id
        ) AS total_paid
    FROM customer_rental_summary AS crs
)

SELECT
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
FROM customer_summary;