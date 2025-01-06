#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id;
    
    #Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

USE sakila;

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_paid
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;
    
    #Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

#
USE sakila;

-- Define the CTE
WITH CustomerSummaryCTE AS (
    SELECT 
        crs.customer_id,
        crs.full_name,
        crs.email,
        crs.rental_count,
        tcp.total_paid
    FROM 
        customer_rental_summary crs
    JOIN 
        temp_customer_payments tcp ON crs.customer_id = tcp.customer_id
)

-- Generate the final customer summary report
SELECT 
    full_name,
    email,
    rental_count,
    total_paid,
    (CASE WHEN rental_count > 0 THEN total_paid / rental_count ELSE 0 END) AS average_payment_per_rental
FROM 
    CustomerSummaryCTE;    