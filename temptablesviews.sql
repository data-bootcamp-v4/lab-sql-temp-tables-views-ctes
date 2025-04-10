/* - Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/

CREATE VIEW rental_summary AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

/* - Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.*/

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT c.customer_id,
       SUM(p.amount) AS total_paid
FROM rental_summary c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

/* - Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. 
Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/

WITH customer_summary AS (
    SELECT c.customer_id,
           c.first_name,
           c.last_name,
           c.email,
           c.rental_count,
           p.total_paid
    FROM rental_summary c
    JOIN customer_payment_summary p ON c.customer_id = p.customer_id
)

SELECT cs.first_name,
       cs.last_name,
       cs.email,
       cs.rental_count,
       cs.total_paid,
       ROUND(cs.total_paid / cs.rental_count, 2) AS average_payment_per_rental
FROM customer_summary cs;    