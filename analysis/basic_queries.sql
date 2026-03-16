-- Find the total number of customers in each city.
select city,count(*) as total_customers 
from customers 
group by city;

-- List the top 10 most expensive products by unit_price.
select product_name,unit_price 
from products
order by unit_price desc
limit 10;

-- Calculate total revenue generated from Delivered orders only.
select sum(total_amount) as total_revenue 
from orders
where status = 'delivered';

-- Find the average age of customers by segment.
select segment , round(avg(age),2) as avg_age 
from customers
group by segment;

-- Show the number of orders by payment mode.
select payment_mode , count(*) as total_orders
from orders
group by payment_mode;

