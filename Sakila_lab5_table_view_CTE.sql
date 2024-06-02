use sakila;
-- 1 : 

create view  cust_info as 
select 
ct.customer_id,
first_name,
last_name,
email,
count(distinct rental_id) as nb_rental
from customer as ct
left join rental rt on ct.customer_id = rt.customer_id
group by ct.customer_id, first_name, last_name, email ;

-- 2 : 
-- drop temporary table tt_avg_total_cust;
create temporary table tt_avg_total_cust as 
select ci.customer_id,
sum(amount) as total_paid
from cust_info ci
Left join payment py on ci.customer_id = py.customer_id 
group by ci.customer_id;

-- 3 : Créez un CTE qui joint la vue récapitulative de la location au tableau temporaire du récapitulatif des paiements du client créé à l'étape 2. 
-- Le CTE doit inclure le nom du client, son adresse e-mail, le nombre de locations et le montant total payé
WITH 
nb_rentals as (
SELECT *
from cust_info
),
total_amount as (
select * 
from tt_avg_total_cust
)
select
nr.first_name,
nr.email,
nr.nb_rental,
ta.total_paid,
ta.total_paid / nr.nb_rental as avg_amount_per_rental
from nb_rentals nr
left join total_amount ta on ta.customer_id = nr.customer_id