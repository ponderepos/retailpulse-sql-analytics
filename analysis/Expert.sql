-- Find customers who ordered in 2023 but not in 2024.
SELECT DISTINCT o1.customer_id
FROM orders o1
LEFT JOIN orders o2
ON o1.customer_id=o2.customer_id
AND YEAR(o2.order_date)=2024
WHERE YEAR(o1.order_date)=2023
AND o2.customer_id IS NULL;

-- Perform RFM analysis (Recency, Frequency, Monetary)
select DATEDIFF(CURDATE(), MAX(order_date)) as recency,count(*) as frequnecy,sum(total_amount) as monetary 
from orders;
-- Identify the category with the highest return rate.
with cte as(
select p.category as cat ,count(r.return_id) as return_rate
from products p
join returns r on p.product_id = r.product_id
group by p.category)
select cat, return_rate from cte 
order by return_rate desc limit 1;

-- Find the repeat purchase rate (customers with >1 order).
SELECT 
COUNT(DISTINCT CASE WHEN order_count>1 THEN customer_id END)
/ COUNT(DISTINCT customer_id) AS repeat_purchase_rate
FROM (
SELECT customer_id,
COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
) t;

-- Find products that have never been returned.
select p.product_id,p.product_name
from products p
left join returns r on p.product_id = r.product_id
where r.product_id is null
order by r.product_id;
-- Detect customers with duplicate email addresses
SELECT email,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Find the second most expensive product in each category without using LIMIT.
select category,product_name,unit_price 
from (
select category,product_name, unit_price,
dense_rank() over(partition by category order by unit_price desc) as rn
from products) t where rn =2;

-- Identify orders where calculated item total ≠ order total (data quality issue).
SELECT 
    o.order_id,
    o.total_amount AS order_total,
    SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(oi.quantity * oi.unit_price);

-- Find the longest gap between two orders for each customer.
with cte as(
select customer_id,order_date,
lag(order_date) over(partition by customer_id order by order_date) as previos_Date,
datediff(order_date,lag(order_date) over(partition by customer_id order by order_date)) as noofdays
from orders)
select customer_id,max(noofdays)
from cte 
group by customer_id;


