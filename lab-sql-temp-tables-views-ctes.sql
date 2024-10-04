#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the 
#customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_infos AS
SELECT 
    r.customer_ID, 
    c.first_name, 
    c.last_name, 
    c.email, 
    COUNT(*) AS rental_count
FROM 
    rental AS r
JOIN 
    customer AS c 
ON 
    r.customer_ID = c.customer_ID
GROUP BY 
    r.customer_ID, 
    c.first_name, 
    c.last_name, 
    c.email;

SELECT * FROM rental_infos;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
#and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_payments AS
SELECT 
    r.customer_ID, 
    SUM(p.amount) AS total_paid
FROM 
    rental_infos AS r
JOIN 
    payment AS p 
ON 
    r.customer_ID = p.customer_ID
GROUP BY 
    r.customer_ID;



select * from top_employees;

WITH customer_summary AS (
    SELECT 
        r.customer_ID, 
        CONCAT(r.first_name, ' ', r.last_name) AS customer_name, 
        r.email, 
        r.rental_count, 
        t.total_paid,
        (t.total_paid / r.rental_count) AS average_payment_per_rental
    FROM 
        rental_infos AS r
    JOIN 
        total_payments AS t 
    ON 
        r.customer_ID = t.customer_ID
)
SELECT 
    customer_name, 
    email, 
    rental_count, 
    total_paid, 
    ROUND(average_payment_per_rental, 2) AS average_payment_per_rental
FROM 
    customer_summary;
    
 



