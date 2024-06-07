USE sakila;
-- Creating a Customer Summary Report :In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
-- Step 1: Create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_summary AS WITH rental_count AS (
    SELECT customer.customer_id,
        COUNT(rental_id) AS rental_count
    FROM customer
        LEFT JOIN rental ON customer.customer_id = rental.customer_id
    GROUP BY customer.customer_id
)
SELECT customer.customer_id,
    customer.first_name,
    customer.last_name,
    customer.email,
    customer.rental_count.rental_count
FROM customer
    LEFT JOIN rental_count ON customer.customer_id = rental_count.customer_id;
-- Step 2: Create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid
SELECT rental_summary.customer_id,
    rental_summary.first_name,
    rental_summary.last_name,
    rental_summary.email,
    SUM(payment.amount) AS total_paid
FROM rental_summary
    LEFT JOIN payment ON rental_summary.customer_id = payment.customer_id
GROUP BY rental_summary.customer_id,
    rental_summary.first_name,
    rental_summary.last_name,
    rental_summary.email;
-- Step 3: Create a CTE and the Customer Summary Report : 
--     Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
--     Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
WITH cte AS (
    SELECT rental_summary.first_name,
        rental_summary.last_name,
        rental_summary.email,
        rental_summary.rental_count,
        total_paid.total_paid
    FROM rental_summary
        LEFT JOIN total_paid ON rental_summary.customer_id = total_paid.customer_id
)
SELECT *,
    total_paid / rental_count AS average_payment_per_rental
FROM cte;