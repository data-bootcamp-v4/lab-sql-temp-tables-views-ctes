# Create a view that summarizes rental information for each customer - customer's ID, name, email address, and total number of rentals (rental_count).
    
CREATE VIEW rental_info AS
SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name, 
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer.email;



# Create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# Temporary Table should use the rental summary view created in Step 1 to join with the payment 
# table and calculate the total amount paid by each customer


CREATE TEMPORARY TABLE total_paid ASCREATE TEMPORARY TABLE total_paid AS
SELECT customer.customer_id, 
       customer.first_name, 
       customer.last_name, 
       customer.email, 
       SUM(payment.amount) AS total_amount_spent
FROM customer 
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, customer.email;

        
WITH avg_salary AS (
    SELECT AVG(salary) AS average
    FROM employees
)
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT average FROM avg_salary);

