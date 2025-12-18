-- CREATE A VIEW
CREATE VIEW rental_information AS 
SELECT c.customer_id, first_name, last_name, email, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, first_name, last_name, email;
SELECT * FROM rental_information; -- CHECK -- 1

-- CREATE A TEMP TABLE
CREATE TEMPORARY TABLE total_paid AS
SELECT p.customer_id, SUM(p.amount) AS total_paid
FROM payment p
JOIN rental_information ON p.customer_id = rental_information.customer_id
GROUP BY p.customer_id;
SELECT * FROM total_paid; -- CHECK -- 2

-- CREATE A CTE
WITH customer_summary AS (
	SELECT 
		r.customer_id,
        r.first_name,
        r.last_name,
        r.email,
        r.total_rentals,
        t.total_paid
	FROM rental_information r
    JOIN total_paid t ON r.customer_id = t.customer_id
)
SELECT
	first_name,
    last_name,
    email,
    total_rentals,
    total_paid,
    total_paid / total_rentals AS average_payment_per_rental -- total amount per customer / total count of rentals by the customer
FROM customer_summary; -- 3


