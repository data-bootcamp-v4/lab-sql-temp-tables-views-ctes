
#Introduction TEMPORARY TABLES

CREATE TEMPORARY TABLE best_clients AS
SELECT p.customer_id, SUM(p.amount) AS total_amount_spent
FROM payment p
GROUP BY p.customer_id
HAVING total_amount_spent > (SELECT AVG(total_spent)
                             FROM (SELECT SUM(p.amount) AS total_spent
                                   FROM payment p
                                   GROUP BY p.customer_id) AS hund);

SELECT *
FROM best_clients;

#Create a temp table that stores the 50 most rented movies in the sakila database
CREATE TEMPORARY TABLE top_50_rented AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 50;

SELECT * FROM top_50_rented;


#Introduction to Views 

CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM tablename
WHERE condition;

CREATE VIEW actors_with_A AS
	Select * FROM actor
    WHERE first_name LIKE '%A'
    
    
#Introduction to CTE (temporary tables used like variables kinda)
#Create a CTE vsllrf zozsl<-pc, that stores the customer_id and their total amount spent 
#the main query should use this cte to filter


#Base Code
SELECT p.customer_id, SUM(p.amount) AS total_amount_spent
FROM payment p
GROUP BY p.customer_id
HAVING total_amount_spent > (SELECT AVG(total_spent)
                             FROM (SELECT SUM(p.amount) AS total_spent
                                   FROM payment p
                                   GROUP BY p.customer_id) AS hund);

#CTE
                                   
WITH customer_totals AS (
    SELECT p.customer_id, SUM(p.amount) AS total_amount_spent
    FROM payment p
    GROUP BY p.customer_id)

SELECT ct.customer_id, ct.total_amount_spent
FROM customer_totals ct
WHERE ct.total_amount_spent > (SELECT AVG(total_amount_spent) FROM customer_totals);

