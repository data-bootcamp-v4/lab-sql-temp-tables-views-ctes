#1. Create a view that summarizes rental information for each customer. Include the customer's ID, name, email, total number of rentals (rental_count).

#CREATE VIEW rental_summary_view AS
SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    email,
    COUNT(r.customer_id) AS rental_count
FROM
	customer AS c
JOIN
	rental AS r ON c.customer_id = r.customer_id
GROUP BY
	r.customer_id;


#2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid).
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment_summmary AS
SELECT
	customer_id,
    SUM(amount) AS 'total_paid'
FROM
	payment
GROUP BY
	customer_id;
    
#3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
#The CTE should include the customer's name, email address, rental count, and total amount paid
WITH customer_summary_report AS (
    SELECT
		r.*,
        c.total_paid
	FROM
		rental_summary_view AS r
	JOIN
		customer_payment_summmary AS c ON r.customer_id = c.customer_id
        )
SELECT 
	*
FROM
	customer_summary_report;
    
#4. Using the CTE, create a query to generate the final customer summary report, which should include:
#customer name, email, rental_count, total_paid and average_payment_per_rental.
#This last column is a derived column from total_paid and rental_count
WITH final_customer_summary_report AS (
    SELECT
		r.*,
        c.total_paid
	FROM
		rental_summary_view AS r
	JOIN
		customer_payment_summmary AS c ON r.customer_id = c.customer_id
        )
SELECT 
	*,
    ROUND((CAST(total_paid AS float)/CAST(rental_count AS float)),2) AS 'average_payment_per_rental'
FROM
	final_customer_summary_report
ORDER BY
	total_paid DESC;












