USE sakila;
SHOW TABLES;


# First, create a view that summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

SELECT *
FROM customer;

SELECT *
FROM rental;

CREATE VIEW customer_rental_summary AS
SELECT
c.customer_id,
c.first_name,
c.last_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name,
c.email;

SELECT *
FROM customer_rental_summary

# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in 
# Step 1 to join with the payment table and calculate the total amount paid by each customer.

SELECT *
FROM payment;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
crs.customer_id,
SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p
ON crs.customer_id = p.customer_id
GROUP BY
crs.customer_id;

SELECT *
FROM customer_rental_summary


# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.


WITH customer_summary AS (
SELECT
crs.first_name,
crs.last_name,
crs.email,
crs.rental_count,
cps.total_paid
FROM customer_rental_summary AS crs
JOIN customer_payment_summary AS cps
ON crs.customer_id = cps.customer_id
)
SELECT *
FROM customer_summary;
