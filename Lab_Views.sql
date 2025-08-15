USE sakila;

-- 1 First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW lab_view_ex1 AS
SELECT  c.customer_id, first_name, last_name, email, COUNT(rental_id) AS number_rentals
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
GROUP BY customer_id;


SELECT * FROM lab_view_ex1;

-- 2 Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE temporary table lab_temp_ex2 AS
SELECT lab_view_ex1.customer_id, SUM(amount) as total_paid
FROM lab_view_ex1 
LEFT JOIN payment p 
ON lab_view_ex1.customer_id = p.customer_id
GROUP BY lab_view_ex1.customer_id
ORDER BY total_paid desc;

SELECT* from lab_temp_ex2;

-- 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email,
 -- rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


WITH customer_summary_cte AS (
    SELECT 
        v.first_name,
        v.last_name,
        v.email,
        v.number_rentals AS rental_count,
        t.total_paid
    FROM lab_view_ex1 v
    JOIN lab_temp_ex2 t
        ON v.customer_id = t.customer_id
)
SELECT
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;
