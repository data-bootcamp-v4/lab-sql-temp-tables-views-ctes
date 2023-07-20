/* Challenge */
CREATE VIEW customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
    CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    crs.customer_id,
    crs.customer_name,
    crs.email,
    crs.rental_count,
    SUM(p.amount) AS total_paid
FROM
    customer_rental_summary crs
LEFT JOIN
    rental r ON crs.customer_id = r.customer_id
LEFT JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY
    crs.customer_id, crs.customer_name, crs.email, crs.rental_count;
    WITH customer_summary_cte AS (
    SELECT
        crs.customer_name,
        crs.email,
        crs.rental_count,
        tcp.total_paid,
        tcp.total_paid / crs.rental_count AS average_payment_per_rental
    FROM
        customer_rental_summary crs
    JOIN
		temp_customer_payments tcp ON crs.customer_id = tcp.customer_id)
        SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM
    customer_summary_cte;