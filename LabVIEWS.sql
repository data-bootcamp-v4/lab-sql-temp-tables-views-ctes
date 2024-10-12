USE sakila;

#1. Step First, create a view that summarizes rental information.

#CREATE VIEW rental_information AS
SELECT customer_id, first_name, last_name, email, COUNT(rental_id) 
FROM customer 
JOIN rental  
USING (customer_id)
GROUP BY customer_id, first_name, last_name, email;


# 2.Create a Temporary Table

#CREATE TEMPORARY TABLE total_paid AS
SELECT customer_id, first_name, last_name, email, COUNT(rental_id) AS rental_count, SUM(amount) AS total_paid
FROM rental_information
JOIN payment
USING (customer_id)
GROUP BY customer_id, first_name, last_name, email
ORDER BY total_paid;
SELECT * FROM total_paid;

#3.Step 3: Create a CTE and the Customer Summary Report

WITH CustomerRentalInfo AS (
    SELECT 
        c.first_name,
        c.last_name,
        c.email,
        COUNT(r.rental_id) AS rental_count,
        SUM(p.amount) AS total_paid
    FROM 
        customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
)
SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    (total_paid / rental_count) AS average_pay_per_rental
FROM 
    CustomerRentalInfo
ORDER BY 
    average_pay_per_rental DESC;


