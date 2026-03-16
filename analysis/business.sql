-- Rank products by revenue within each category.
select category,product_name,sum(final_price) as total_Revenue,
dense_rank() over(partition by category order by sum(final_price)desc) as rn
from products 
join order_items on products.product_id = order_items.product_id
group by category,product_name;

-- Calculate month-over-month revenue growth.
select month,revenue,
lag(revenue) over(order by month) as previous_month,
((revenue - LAG(revenue) OVER (ORDER BY month)) 
        / LAG(revenue) OVER (ORDER BY month)) * 100 AS mom
from 
(select date_format(order_Date,'%y-%m') as month,
sum(total_amount) as revenue
from orders group by date_format(order_Date,'%y-%m')) t;

-- Find the first order placed by each customer.
select c.full_name, min(o.order_Date) as first_order
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.full_name;

-- Identify the top 3 customers by total spending.
with cte as(
select c.full_name as f_name, sum(total_amount) as total_spending,
dense_rank() over(order by sum(total_amount) desc) as rn
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.full_name)
select f_name,total_spending
from cte
where rn<=3;

-- Divide customers into 4 spending tiers using NTILE(4)
WITH spending AS (
SELECT 
customer_id,
SUM(total_amount) AS total_spending
FROM orders
GROUP BY customer_id
)
SELECT *,
NTILE(4) OVER(ORDER BY total_spending DESC) AS spending_tier
FROM spending;

