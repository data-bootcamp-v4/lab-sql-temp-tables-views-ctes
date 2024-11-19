/* 
Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, 
and total number of rentals (rental_count). 
*/

CREATE VIEW customer_info AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS name, c.email, COUNT(r.rental_id) as rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY customer_id;

/*
Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 
to join with the payment table and calculate the total amount paid by each customer.
*/

CREATE TEMPORARY TABLE total_paid AS
SELECT ci.customer_id, SUM(p.amount) AS total_paid
FROM customer_info ci
JOIN payment p
ON ci.customer_id = p.customer_id
GROUP BY ci.customer_id;

SELECT * FROM total_paid;

/*
Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment 
summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, 
which should include: customer name, email, rental_count, total_paid 
and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
*/

WITH cte_rental AS (
    SELECT 
		ci.name, 
        ci.email, 
        ci.rental_count, 
        tp.total_paid 
    FROM customer_info ci
    JOIN total_paid tp
    ON ci.customer_id = tp.customer_id
)
SELECT 
    name, 
    email, 
    rental_count, 
    total_paid, 
    (total_paid / rental_count) AS average_payment_per_rental
FROM cte_rental;