#Step 1
Use sakila;

SELECT r.customer_id, CONCAT(c.first_name, " ", c.last_name) as fullname, c.email
FROM rental r 
INNER JOIN customer c
ON r.customer_id = c.customer_id;

SELECT r.customer_id, CONCAT(c.first_name, " ", c.last_name) as fullname, c.email, COUNT(*) as rental_count
FROM rental r 
INNER JOIN customer c 
ON r.customer_id = c.customer_id
GROUP BY r.customer_id
ORDER BY rental_count DESC;

#To create a view, need to give it a name
CREATE VIEW total_rental_customer AS (
SELECT r.customer_id, CONCAT(c.first_name, " ", c.last_name) as fullname, c.email, COUNT(*) as rental_count
FROM rental r 
INNER JOIN customer c 
ON r.customer_id = c.customer_id
GROUP BY r.customer_id
ORDER BY rental_count DESC);

SELECT * FROM total_rental_customer;

#Step 2
SELECT SUM(p.amount) AS total_paid, t.fullname
FROM total_rental_customer t
INNER JOIN payment p
ON t.customer_id=p.customer_id
GROUP BY t.customer_id
ORDER BY total_paid DESC;

Create TEMPORARY TABLE total_amount_customer AS (
SELECT SUM(p.amount) AS total_paid, t.fullname
FROM total_rental_customer t
INNER JOIN payment p
ON t.customer_id=p.customer_id
GROUP BY t.customer_id
ORDER BY total_paid DESC);

/*Step 3: Create a CTE and the Customer Summary Report*/
WITH cte_summary AS (
    SELECT t.customer_id, t.fullname, t.email, t.rental_count, a.total_paid
    FROM total_rental_customer t
    INNER JOIN total_amount_customer a
    ON t.customer_id = a.customer_id)
SELECT cte_summary.fullname, cte_summary.email, cte_summary.rental_count, 
       cte_summary.total_paid, cte_summary.total_paid / cte_summary.rental_count AS average_payment_per_rental
FROM cte_summary;