#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, 
#and total number of rentals (rental_count).

CREATE VIEW customer_summary AS
SELECT 
c.customer_id, 
CONCAT(c.first_name, " ", c.last_name) AS customer_name,
c.email,
COUNT(r.rental_id) AS rental_count
FROM 
	sakila.customer AS c
JOIN 
	sakila.rental AS r ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id;
    
SELECT *
FROM customer_summary;


#create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to 
#join with the payment table and calculate the total amount paid by each customer.

SELECT *
FROM sakila.payment;

DROP TABLE sakila.table_paid;

CREATE TEMPORARY TABLE table_paid AS
SELECT cs.customer_id, cs.customer_name, cs.email, cs.rental_count, SUM(payment.amount) AS total_paid
FROM customer_summary cs
JOIN sakila.payment ON payment.customer_id = cs.customer_id
GROUP BY cs.customer_id
ORDER BY total_paid DESC;

SELECT *
FROM table_paid;
		
		
#create a CTE and the Customer Summary Report

WITH customer_rental_summary AS (
    SELECT *
    FROM customer_summary )
SELECT 
	crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    table_paid.total_paid
FROM 
	customer_rental_summary crs
JOIN
	table_paid ON table_paid.customer_id = crs.customer_id;
       
