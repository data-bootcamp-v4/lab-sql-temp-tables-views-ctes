USE sakila;
-- STEP 1 Create a View
DROP TABLE IF EXISTS customer_rental_summary; 

CREATE VIEW customer_rental_summary AS 
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
COUNT(rental_id) AS rental_count
FROM sakila.customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email 
ORDER BY 
    rental_count;
    
-- STEP 2 Create a Temporary Table
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,                             
	SUM(p.amount) AS total_paid 
FROM customer_payment_summary 
JOIN
	payment p ON c.customer_id = p.customer_id 
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
ORDER BY
total_paid;

-- STEP 3 Create a CTE and the Customer Summary Report
WITH customer_payment_rental_cte AS (
    SELECT
        crs.first_name,                        
        crs.last_name,                         
        crs.email,                            
        crs.rental_count,                      
        cps.total_paid                         
    FROM
        rental_summary crs            
    JOIN
        customer_payment_summary cps          
    ON
        crs.customer_id = cps.customer_id     
)
SELECT 
    first_name,                               
    last_name,                                 
    email,                                     
    rental_count,                             
    total_paid                                 
FROM 
    customer_payment_rental_cte; 
    