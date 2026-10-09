# Step 1: Create a View

CREATE OR REPLACE VIEW customer_rental_summary AS  
SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS name, email, COUNT(rental_ID) as rental_count 
FROM customer 
JOIN rental  
ON customer.customer_id = rental.customer_id  
GROUP BY customer.customer_id;

# Step 2: Create a Temporary Table
CREATE OR REPLACE VIEW customer_rental_summary AS  
SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS name, email, COUNT(rental_ID) as rental_count 
FROM customer 
JOIN rental  
ON customer.customer_id = rental.customer_id  
GROUP BY customer.customer_id;
DROP TEMPORARY TABLE IF EXISTS total_paid;
CREATE TEMPORARY TABLE total_paid AS
SELECT SUM(amount) AS total_paid, customer_rental_summary.customer_id
FROM payment
JOIN customer_rental_summary
ON payment.customer_id = customer_rental_summary.customer_id
GROUP BY customer_rental_summary.customer_id;

# Step 3: Create a CTE and the Customer Summary Report

# Step 3: Create a CTE and the Customer Summary Report

CREATE OR REPLACE VIEW customer_rental_summary AS  
SELECT customer.customer_id, CONCAT(first_name, ' ', last_name) AS name, email, COUNT(rental_ID) as rental_count 
FROM customer 
JOIN rental  
ON customer.customer_id = rental.customer_id  
GROUP BY customer.customer_id;

DROP TEMPORARY TABLE IF EXISTS total_paid;
CREATE TEMPORARY TABLE total_paid AS
SELECT SUM(amount) AS total_paid, customer_rental_summary.customer_id
FROM payment
JOIN customer_rental_summary
ON payment.customer_id = customer_rental_summary.customer_id
GROUP BY customer_rental_summary.customer_id;

WITH Cte_Customer_Summary_Report AS (    
    SELECT 
        customer_rental_summary.customer_id,
        customer_rental_summary.name,
        customer_rental_summary.email,
        customer_rental_summary.rental_count,
        total_paid.total_paid,
        (total_paid.total_paid / customer_rental_summary.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary
    JOIN total_paid 
    ON customer_rental_summary.customer_id = total_paid.customer_id
)
SELECT * FROM Cte_Customer_Summary_Report;