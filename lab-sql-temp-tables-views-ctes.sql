/*
Creating a Customer Summary Report
In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database,
including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
*/

USE sakila;

SELECT * FROM customer;
DROP VIEW IF EXISTS customer_rent_summary;
CREATE VIEW customer_rent_summary AS
SELECT c.customer_id, 
CONCAT(c.first_name, ' ' , c.last_name) AS customer_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM
customer c
JOIN 
rental r ON c.customer_id= r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
SELECT * FROM customer_rent_summary;

/* 
Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
and calculate the total amount paid by each customer.
*/

CREATE TEMPORARY TABLE customer_payment_summary AS 
SELECT
crs.customer_id,
crs.customer_name,
crs.email,
SUM(p.amount) AS total_paid
FROM
customer_rent_summary crs
JOIN 
payment p ON crs.customer_id= p.customer_id
GROUP BY 
crs.customer_id, crs.customer_name, crs.email;

SELECT * FROM customer_payment_summary;

/*
Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.
*/

WITH customer_summary_cte AS (
SELECT 
crs.customer_name,
crs.email,
crs.rental_count,
cps.total_paid
FROM
customer_rent_summary crs
JOIN
customer_payment_summary cps ON crs.customer_id= cps.customer_id
)
SELECT * FROM customer_summary_cte;

/* 
Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, 
this last column is a derived column from total_paid and rental_count.
*/

WITH customer_summary_cte AS (
SELECT
crs.customer_name,
crs.email,
crs.rental_count,
cps.total_paid
FROM 
customer_rent_summary crs
JOIN 
customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT
customer_name,
email,
rental_count,
total_paid,
CASE
WHEN rental_count > 0 
THEN total_paid / rental_count
ELSE 0
END AS average_payment_per_rental
FROM
customer_summary_cte;



