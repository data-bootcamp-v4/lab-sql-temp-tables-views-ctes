USE sakila;
#1 First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
SELECT * FROM customer;
SELECT * FROM rental;
CREATE VIEW total_paid AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id)
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id;
#2 Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the 
#payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid_temp AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, SUM(p.amount) AS total_amount_paid
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
#3 Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, 
#which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
#this last column is a derived column from total_paid and rental_count.
WITH total_paid AS (
    SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
    FROM customer c
    INNER JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email),
total_paid_temp AS (
    SELECT c.customer_id, c.first_name, c.last_name, c.email, SUM(p.amount) AS total_amount_paid
    FROM customer c
    INNER JOIN rental r ON c.customer_id = r.customer_id
    INNER JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email)
SELECT 
    total_paid.first_name, 
    total_paid.last_name, 
    total_paid.email, 
    total_paid.rental_count, 
    total_paid_temp.total_amount_paid,
    ROUND(total_paid_temp.total_amount_paid / total_paid.rental_count, 2) AS average_payment_per_rental
FROM total_paid
LEFT JOIN total_paid_temp ON total_paid.customer_id = total_paid_temp.customer_id;
