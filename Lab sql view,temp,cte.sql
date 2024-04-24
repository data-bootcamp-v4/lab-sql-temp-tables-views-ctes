# Step 1: Create a View
# First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
use sakila;
CREATE VIEW CustomerRentalSummary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS email_address,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
    
# Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE CustomerPaymentSummary AS
SELECT
    crs.customer_id,
    crs.customer_name,
    crs.email_address,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM
    CustomerRentalSummary crs
LEFT JOIN
    rental r ON crs.customer_id = r.customer_id
LEFT JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY
    crs.customer_id, crs.customer_name, crs.email_address, crs.rental_count;
    
# Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

CREATE VIEW CustomerRentalSummary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS email_address,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;