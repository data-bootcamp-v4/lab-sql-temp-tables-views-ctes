-- Active: 1721290975934@@127.0.0.1@3306@sakila
USE sakila

--In this exercise, you will create a customer summary report that summarizes key information about customers 
--in the Sakila database, including their rental history and payment details. The report will be generated using a 
--combination of views, CTEs, and temporary tables.

--Step 1: Create a View
--First, create a view that summarizes rental information for each customer. The view should include 
--the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE OR REPLACE VIEW rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
    LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;


--Step 2: Create a Temporary Table
--Next, create a Temporary Table that calculates the total amount paid by each 
--customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 
--to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE payment_summary AS
SELECT
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary  AS rs
    JOIN payment AS p 
    ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;


--Step 3: Create a CTE and the Customer Summary Report
--Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in 
--Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary AS (
    SELECT
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid,
        CASE
            WHEN rs.rental_count > 0 THEN ps.total_paid / rs.rental_count
            ELSE 0
        END AS average_payment_per_rental
    FROM
        rental_summary rs
        LEFT JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary
ORDER BY
    customer_name;


--Next, using the CTE, create the query to generate the final customer summary report, which 
--should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this 
--last column is a derived column from total_paid and rental_count.