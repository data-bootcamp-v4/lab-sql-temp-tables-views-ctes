use sakila;

#Solution_1

drop view rental_information;
create view rental_information as 
				select 
					customer.customer_id,
					customer.first_name,
					customer.last_name,
					customer.email,
					count(rental.rental_id) as rental_count
				from
					rental
					left join customer on rental.customer_id = customer.customer_id
				group by
					customer.customer_id,
					customer.first_name,
					customer.last_name,
					customer.email;
                    
                    
select * from rental_information;


#Solution_2

drop temporary table customer_payment; 
create temporary table customer_payment as 
				select 
					rental_information.customer_id,
					sum(payment.amount) as total_paid
				from 
					rental_information
					left join payment on payment.customer_id = rental_information.customer_id
				group by
					rental_information.customer_id;
                    
                    
select * from customer_payment;


#Solution_3

with customer_summary_report as (
		select 
			rental_information.customer_id,
			rental_information.first_name,
			rental_information.last_name,
			rental_information.email,
			rental_information.rental_count,
			customer_payment.total_paid
		from
			rental_information
		left join
			customer_payment 
            on customer_payment.customer_id = rental_information.customer_id)
            
select 
	concat(first_name, last_name) as customer_name,
    email,
    rental_count,
    total_paid,
    round(total_paid/rental_count,2) as average_payment_per_rental
from 
	customer_summary_report;
