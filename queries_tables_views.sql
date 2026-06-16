USE sakila;
CREATE VIEW rental_summary AS
(SELECT 
	r.customer_id, 
	concat(c.first_name,' ',c.last_name) as name, 
    c.email, count(r.rental_id) as rental_count 
FROM rental as r 
inner join customer as c 
	on r.customer_id=c.customer_id 
group by r.customer_id, name, c.email);

select * from rental_summary;

CREATE TEMPORARY TABLE total_paid_per_customer AS
SELECT 
	rs.customer_id, 
    sum(p.amount) as total_paid 
from rental_summary as rs 
join payment as p 
	on rs.customer_id=p.customer_id 
group by rs.customer_id;

WITH cte_summary_per_cust AS(
SELECT 
	rs.name as name, 
    rs.email as email, 
    rs.rental_count as rental_count, 
    tp.total_paid as total_paid 
FROM rental_summary as rs 
join total_paid_per_customer as tp 
	on rs.customer_id=tp.customer_id
)
SELECT 
	name, 
    email, 
    rental_count, 
    total_paid, 
    round(total_paid/rental_count,2) as average_payment_per_rental 
FROM cte_summary_per_cust;
