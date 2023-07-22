/*1 */
CREATE VIEW customers_rental_info AS
SELECT client_info.customer_id, client_info.full_name, email, address, COUNT(rental_id) as "rental_count"
FROM sakila.rental
INNER JOIN
	(SELECT customer_id, CONCAT(customer.first_name," ", customer.last_name) AS Full_Name, email, address
	FROM sakila.customer
	INNER JOIN sakila.address
	ON address.address_id = customer.address_id) client_info
ON rental.customer_id = client_info.customer_id
GROUP BY customer_id;

SELECT * 
FROM customers_rental_info;

/*2*/
CREATE TEMPORARY TABLE customer_spent AS
SELECT customers_rental_info.customer_id, SUM(amount) AS money_spent
FROM payment
INNER JOIN customers_rental_info
ON payment.customer_id = customers_rental_info.customer_id
GROUP BY customer_id;


SELECT * 
FROM customer_spent;

/*3*/
WITH cte as
	(SELECT customers_rental_info.customer_id, customers_rental_info.full_name, email, address, COUNT(rental_id) as "rental_count", SUM(amount) AS money_spent
	FROM payment
	INNER JOIN customers_rental_info
	ON payment.customer_id = customers_rental_info.customer_id
	GROUP BY customer_id)

    
SELECT * , ROUND(money_spent/rental_count,2) AS average_payment_per_rental
FROM cte;
    







