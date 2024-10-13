use sakila;

--Create a View
--First, create a view that summarizes rental information for each customer. 
--The view should include the customer's ID, name, email address, 
-- and total number of rentals (rental_count).

-- cutsomer, rental

SELECT * FROM rental;


CREATE VIEW rental_information AS
SELECT c.first_name, c.last_name, c.email, c.customer_id, COUNT(r.customer_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY customer_id;

--Create a Temporary Table
--Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
--The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
--and calculate the total amount paid by each customer.

--payment, rental_information

SELECT * FROM rental_information;

CREATE TEMPORARY TABLE total_paid AS
SELECT ri.customer_id, ri.first_name, ri.last_name ,SUM(p.amount) AS total_amount
FROM rental_information ri
JOIN payment p ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id;


--Create a CTE and the Customer Summary Report
--Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
--The CTE should include the customer's name, email address, rental count, and total amount paid.

--

WITH customer_summary AS (
		SELECT 
        ri.first_name,
        ri.last_name,
        ri.email,
        ri.rental_count,
        tp.total_amount
    FROM rental_information ri
    JOIN total_paid tp ON ri.customer_id = tp.customer_id
)
SELECT 
    first_name,
    last_name,
    email,
    rental_count,
    total_amount
FROM customer_summary;
