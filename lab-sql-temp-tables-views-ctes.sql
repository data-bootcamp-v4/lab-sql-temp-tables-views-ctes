# LAB | CTE, VIEWS, TEMPORARY TABLES

#1
CREATE VIEW customer_infos AS
SELECT customer.customer_id, CONCAT(first_name, " ", last_name) as full_name, email, COUNT(rental.customer_id) as rental_count
FROM sakila.customer
inner join sakila.rental
on customer.customer_id = rental.customer_id
group by customer.customer_id;

#2
CREATE TEMPORARY TABLE c_info(
SELECT cf.customer_id, cf.full_name, email, rental_count, sum(payment.amount) as total_paid FROM customer_infos as cf
inner join sakila.payment
on cf.customer_id = payment.customer_id
group by payment.customer_id);

#3
WITH customer_summary_report AS (
SELECT full_name, email, rental_count, total_paid, total_paid/rental_count as average_payment_per_rental from c_info)

SELECT * from customer_summary_report;
