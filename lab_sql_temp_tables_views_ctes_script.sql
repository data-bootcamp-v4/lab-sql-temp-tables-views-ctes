Use Sakila;
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include 
#the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW Customer_renter_information As
SELECT 
Customer.customer_id, Customer.first_name, Customer.last_name, Customer.email, COUNT(Rental.rental_id) As rental_count
From customer
JOIN Rental ON customer.Customer_id = Rental.Customer_id
GROUP BY customer_id;

SELECT * 
FROM Customer_renter_information ;

#2 Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the 
#payment table and calculate the total amount paid by each customer.

Create Temporary Table total_amount_paid
Select 
cri.customer_id,
cri.first_name,
cri.last_name,
cri.Email,
cri.rental_count,
    Sum(Payment.amount) As total_paid
    From Customer_renter_information cri
    JOIN Payment ON cri.Customer_id = payment.customer_id
    GROUP BY customer_id;
    
SELECT *
FROM total_amount_paid;

#3 Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created
#in Step 2.The CTE should include the customer's name, email address, rental count, and total amount paid
##Next, using the CTE, create the query to generate the final customer summary report, which should 
#include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last 
#column is a derived column from total_paid and rental_count.

WITH Customer_summary As (
						SELECT
						cri.first_name,
						cri.last_name,
						cri.Email,
						cri.rental_count,
						tap.total_paid
						From Customer_renter_information as cri
						JOIN total_amount_paid as tap
						ON cri.customer_id = tap.customer_id)
                        
SELECT *
FROM Customer_summary
order by total_paid DESC;



#Next, using the CTE, create the query to generate the final customer summary report, which should 
#include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last 
#column is a derived column from total_paid and rental_count.




