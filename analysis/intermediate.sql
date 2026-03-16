-- Find customers who placed more than 2 orders.
select c.customer_id , c.full_name,count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id , c.full_name 
having count(o.order_id) >2;

-- Calculate profit margin per product.
select product_name, (unit_price-cost_price) as profit_anount,
round((unit_price-cost_price)/unit_price * 100,2) as profit_margin_pct
from products;

-- List all orders with customer name and product name.
select o.order_id,c.full_name,p.product_name
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id =oi.product_id
order by o.order_id;

-- Find the top 5 cities by total revenue.
select city, sum(total_amount) as total_revenue
from orders
group by city
order by total_revenue limit 5;

-- Find customers who registered in 2023 but placed an order in 2024.
select distinct c.customer_id,c.full_name
from customers c
join orders o on c.customer_id = o.customer_id
where year(c.registration_date) = '2023' and year(o.order_date) = '2024';

