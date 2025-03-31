use sakila;


select * from rental;
select * from customer;


CREATE VIEW rental_info AS
SELECT
	c.customer_id,
	concat(c.last_name," ",last_name) as full_name,
	c.email,
    count(r.rental_id) as rental_count
FROM sakila.customer as c
join sakila.rental as r on c.customer_id = r.customer_id
group by c.customer_id;

 select * from rental_info;
 
 
 
 
 
 
select * from rental;
select * from customer;
select * from payment;
 
 
 
 
CREATE TEMPORARY TABLE total_pay as 
SELECT
	c.customer_id,
	concat(c.last_name," ",last_name) as full_name,
    sum(p.amount) as total_amount
FROM sakila.customer as c
join sakila.rental as r on c.customer_id = r.customer_id
join sakila.payment as p on r.customer_id = p.customer_id
group by c.customer_id;

select * from total_pay;


WITH customer_report AS (
    SELECT
		tp.customer_id,
        tp.full_name,
        tp.total_amount,
        ri.email,
        ri.rental_count
    FROM 
		total_pay as tp
	JOIN
		rental_info as ri on tp.customer_id = ri.customer_id
)
SELECT
	cr.full_name,
    cr.email,
	cr.rental_count,
	cr.total_amount,
    cr.total_amount / cr.rental_count as average_per_rental
FROM 
customer_report as cr
order by
	average_per_rental desc;


 