-- Average Days to Delivery
SELECT AVG(DATEDIFF(day, order_purchase_timestamp,order_delivered_customer_date)) days_delivery  
FROM dbo.orders
SELECT  
    order_delivered_customer_date - order_purchcase_timestamp
FROM dbo.orders

--Total Sales and Avg Sales for each Order

SELECT 
    SUM(sq.order_total) total_revenue,
    AVG(sq.order_total) avg_order
FROM (SELECT
    SUM(price) order_total
    FROM dbo.order_items
    GROUP BY order_id
    ) sq;

-- Profit per Order with Freight Cost
WITH profit as (
SELECT
    SUM(price) - SUM(freight_value) profit
FROM dbo.order_items
GROUP BY order_id)
SELECT AVG(profit)
FROM profit

-- Total Sales by Year
SELECT
    year(o.order_purchase_timestamp) year,
        sum(i.price) sales
    FROM dbo.orders o
    LEFT JOIN dbo.order_items i
    ON o.order_id = i.order_id
    GROUP BY year(o.order_purchase_timestamp)

-- Total Sales by Month (for Visualization)
SELECT
    year(o.order_purchase_timestamp) year,
    month(order_purchase_timestamp) month,
    sum(i.price) sales
FROM dbo.orders o
LEFT JOIN dbo.order_items i
ON o.order_id = i.order_id
GROUP BY year(o.order_purchase_timestamp), month(order_purchase_timestamp)
ORDER BY year, month

--Total sales for each product category
SELECT TOP 15
    t.translation product_category,
    SUM(o.price) total_sales,
    ROUND(SUM(o.price) / (SELECT SUM(price) FROM dbo.order_items) * 100,2) perc_sales
FROM dbo.order_items o
LEFT JOIN dbo.products p
ON o.product_id = p.product_id
LEFT JOIN dbo.category_translation t
ON p.product_category_name = t.product_category_name
GROUP BY t.translation
ORDER BY total_sales DESC

-- Registrations by Month

WITH registrations AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) reg_date
    FROM dbo.orders
    GROUP BY customer_id
)
SELECT 
    year(reg_date) year,
    month(reg_date) month,
    COUNT(DISTINCT customer_id) registrations
FROM registrations
GROUP BY year(reg_date), month(reg_date)
ORDER BY year(reg_date), month(reg_date)


-- Monthly Active Users and Growth Between Months

WITH mau AS (
    SELECT
        year(order_purchase_timestamp) year,
        month(order_purchase_timestamp) month,
        COUNT(DISTINCT customer_id) mau
    FROM orders
    GROUP BY year(order_purchase_timestamp), month(order_purchase_timestamp)
),

mau_lag AS (
    SELECT 
        year,
        month,
        mau,
        LAG(mau) OVER (ORDER BY year, month ASC) last_mau
    FROM mau
)

SELECT 
    year,
    month,
    mau,
    ROUND(CAST(mau - last_mau AS NUMERIC) / last_mau, 2) growth
FROM mau_lag

-- Retention Rate for each Month
WITH users AS (
    SELECT DISTINCT 
        month(order_purchase_timestamp) month,
        customer_id
    FROM dbo.orders
    WHERE year(order_purchase_timestamp) = 2018
)


SELECT *
FROM users AS previous
LEFT JOIN users AS c
ON previous.customer_id = c.customer_id AND previous.month+1= c.month 
ORDER BY previous.month ASC

-- Average Orders per User (Means that dataset does not have multiple orders from one client)
WITH order_count AS (
    SELECT 
        COUNT(DISTINCT o.order_id) orders,
        COUNT(DISTINCT c.customer_unique_id) users
    FROM dbo.orders o
    LEFT JOIN dbo.customers c 
    ON o.customer_id = c.customer_id
)

SELECT 
    ROUND(orders / users, 5) aopu
FROM order_count


-- Top Customer Lifetime Values

WITH order_totals AS (
SELECT
    o.customer_id,
    i.order_id,
    SUM(i.price) order_total
FROM dbo.order_items i
LEFT JOIN dbo.orders o ON i.order_id = o.order_id
GROUP BY o.customer_id, i.order_id
)

SELECT TOP 20
    customer_id,
    SUM(order_total) lifetime_value
FROM order_totals
GROUP BY customer_id
ORDER BY lifetime_value DESC

-- Customer Sales Amount Histogram

WITH user_revenues AS (
    SELECT
        o.customer_id,
        SUM(i.price) sales
    FROM dbo.order_items i
    LEFT JOIN dbo.orders o
    ON i.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT  
    ROUND(sales, -2) sales_hist,
    COUNT(DISTINCT customer_id) users
FROM user_revenues
GROUP BY ROUND(sales, -2)
ORDER BY ROUND(sales, -2) asc

-- Sales Histogram Looking at Values <= 300

WITH user_revenues AS (
    SELECT
        o.customer_id,
        SUM(i.price) sales
    FROM dbo.order_items i
    LEFT JOIN dbo.orders o
    ON i.order_id = o.order_id
    GROUP BY o.customer_id
)

SELECT  
    ROUND(sales, -1) sales_hist,
    COUNT(DISTINCT customer_id) users
FROM user_revenues
WHERE ROUND(sales, -1) <= 300
GROUP BY ROUND(sales, -1)
ORDER BY ROUND(sales, -1) asc

-- Sales by Region and Avg Sales per Customer in Region
SELECT
    c.customer_city,
    COUNT(DISTINCT o.customer_id) num_customers,
    SUM(i.price) total_sales,
    SUM(i.price) /COUNT(DISTINCT o.customer_id) avg_sale_per_customer
FROM dbo.order_items i
LEFT JOIN dbo.orders o 
ON i.order_id = o.order_id
LEFT JOIN dbo.customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_sales DESC

SELECT *
FROM dbo.geolocation


-- Price Ranges of Most Commonly Bought Items
SELECT TOP 10
    ROUND(price, -1) price_hist,
    COUNT(DISTINCT order_id) count
FROM dbo.order_items
GROUP BY ROUND(price, -1)
ORDER BY count DESC


-- Highest Rated Products

SELECT
    i.product_id,
    AVG(r.review_score) avg_review
FROM dbo.order_items i
LEFT JOIN dbo.order_reviews r
ON i.order_id = r.order_id
WHERE i.order_item_id = 1
GROUP BY i.product_id
ORDER BY avg_review DESC

-- Products that are in the highest grossing category (health_beauty or 'beleza_saude') and have an average rating 3 or above
SELECT *
FROM dbo.products
WHERE product_id IN 
   (SELECT product_id
    FROM dbo.products
    WHERE product_category_name = 'beleza_saude'
    INTERSECT
    SELECT product_id
    FROM dbo.order_items
    LEFT JOIN dbo.order_reviews ON dbo.order_items.order_id = dbo.order_reviews.order_id
    GROUP BY product_id
    HAVING AVG(review_score)>=3);

-- Customers Who Left Low Reviews
SELECT 
    o.customer_id,
    o.order_id,
    r.review_score
from dbo.orders o
LEFT JOIN dbo.order_reviews r 
ON o.order_id = r.order_id
WHERE 3 >
	(SELECT MIN(review_score)
	FROM dbo.order_reviews AS r
	WHERE r.order_id = o.order_id);



