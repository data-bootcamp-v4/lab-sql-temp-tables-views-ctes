USE sakila;

CREATE VIEW rental_info AS
SELECT r.customer_id, CONCAT(c.first_name, " ", c.last_name) as name, c.email, count(r.customer_id) as rental_count
FROM rental as r
INNER JOIN customer as c
ON r.customer_id = c.customer_id
GROUP by r.customer_id, name, c.email;

CREATE TEMPORARY TABLE temp_total_paid (
SELECT ri.customer_id, sum(p.amount) as total_paid
FROM rental_info as ri
INNER JOIN payment as p
ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id);

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte_report AS (
SELECT ri.name, ri.email, ri.rental_count, ttp.total_paid
FROM rental_info as ri
INNER JOIN temp_total_paid as ttp
ON ri.customer_id = ttp.customer_id)

SELECT *, round((cte_report.total_paid/cte_report.rental_count),2) as average_payment_per_rental
FROM cte_report;