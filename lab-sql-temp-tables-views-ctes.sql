/*Creating a Customer Summary Report
In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.*/
USE sakila;

/* Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).*/
CREATE VIEW rental_information AS
SELECT c.customer_id, CONCAT(c.first_name, " ", c.last_name) as name, email, count(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate 
the total amount paid by each customer.*/
CREATE TEMPORARY TABLE total_paid AS
SELECT p.customer_id, i.name, SUM(p.amount) AS total_amount
FROM payment p 
JOIN rental_information i
ON p.customer_id = i.customer_id
GROUP BY p.customer_id;

/* Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.*/
WITH customer_summary_report AS
	(SELECT i.name, i.email, i.rental_count, t.total_paid
	FROM total_paid t
	JOIN rental_information i
	ON t.customer_id = i.customer_id)
SELECT *
FROM customer_summary_report;

/* Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column 
from total_paid and rental_count.*/

WITH customer_summary_report AS
	(SELECT i.name, i.email, i.rental_count, t.total_paid
	FROM total_paid t
	JOIN rental_information i
	ON t.customer_id = i.customer_id)
SELECT name, email, rental_count, total_paid, ROUND(total_paid/rental_count,2) AS average_payment_per_rental
FROM customer_summary_report;