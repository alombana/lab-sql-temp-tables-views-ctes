
-- Step 1: Create a View:
DROP VIEW renta_info_customers;
CREATE VIEW renta_info_customers as
SELECT re.customer_id, count(re.inventory_id) as "rental_count", cu.first_name, cu.email FROM sakila.rental as re
JOIN sakila.customer as cu
ON re.customer_id = cu.customer_id
GROUP BY re.customer_id;

-- Step 2: Create a Temporary Table:
-- Total amount paid by each customer
SELECT customer_id, sum(amount) as "total_paid" FROM sakila.payment
GROUP BY customer_id;
-- Temporary table
CREATE TEMPORARY TABLE payment_customer
SELECT t1.*, t2.total_paid from renta_info_customers as t1
JOIN (SELECT customer_id, sum(amount) as "total_paid" FROM sakila.payment
GROUP BY customer_id) AS t2
on t1.customer_id = t2.customer_id;

-- Step 3: Create a CTE and the Customer Summary Report:
-- Here I used CTE as the exercise required but with the temporary table created "payment_customer" would be also posible to do the multiplication and add the new column
WITH cte_total as (SELECT customer_id, sum(amount) as "total_paid" FROM sakila.payment
GROUP BY customer_id)
SELECT ric.first_name, ric.email, ric.rental_count, ct.total_paid, (ric.rental_count*ct.total_paid) as "average_payment_per_rental" 
FROM renta_info_customers AS ric
JOIN cte_total as ct
on ct.customer_id = ric.customer_id;
