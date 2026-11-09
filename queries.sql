--SECTION A

-- Q1: Retrieve all customer records
SELECT * 
FROM customers;

-- Q2: Display customer names, cities, and segments
SELECT customer_name, city, customer_segment 
FROM customers;

-- Q3: Find customers living in Nairobi
SELECT * 
FROM customers 
WHERE city = 'Nairobi';
--48 customers

-- Q4: Find customers registered after January 1, 2025
SELECT * 
FROM customers 
WHERE registration_date > '2025-01-01';
--116 customers

-- Q5: Display all unique customer cities
SELECT DISTINCT city 
FROM customers 
ORDER BY city ASC;
--10 cities

-- Q6: Retrieve the 10 most recent orders
SELECT * 
FROM orders 
ORDER BY order_date DESC 
LIMIT 10;

-- Q7: Find orders with unit prices above KSh 10,000
SELECT * 
FROM orders 
WHERE unit_price > 10000;
--529 orders

-- Q8: Find customers whose names start with A
SELECT * 
FROM customers 
WHERE customer_name ILIKE 'A%';
--26 customers

-- Q9: Retrieve orders with quantities between 2 and 5
SELECT * 
FROM orders 
WHERE quantity BETWEEN 2 AND 5;
--300 orders

-- Q10: Find orders paid through M-Pesa
SELECT * 
FROM orders 
WHERE payment_method = 'M-Pesa';
--441 orders

--SECTION B

-- Q11: Count all customers
SELECT COUNT(*) AS total_customers 
FROM customers;
--150 customers

-- Q12: Count all orders (all statuses count)
SELECT COUNT(*) AS total_orders 
FROM orders;
--800 orders

-- Q13: Calculate completed-order revenue
SELECT 
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS completed_order_revenue
FROM orders
WHERE order_status = 'Completed';
--24,155,371.7

-- Q14: Calculate the average completed-order value
SELECT 
    ROUND(AVG(quantity * unit_price * (1 - discount / 100.0)), 2) AS avg_completed_order_value
FROM orders
WHERE order_status = 'Completed';
--38,099.96

-- Q15: Find the highest and lowest product prices
SELECT 
    MAX(unit_price) AS highest_price,
    MIN(unit_price) AS lowest_price
FROM orders;
--highest - 89,999
--lowest - 1,899

-- Q16: Calculate revenue by product category
SELECT 
    product_category,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY total_revenue DESC;
--Mobile Phones - 6,942,060.65
--Computing - 6,596,221.7
--Electronics - 5,515,359.2
--Home Appliances  4,024,234.o5
--Accessories - 1,077,496.1

-- Q17: Count customers by city
SELECT 
    city,
    COUNT(customer_id) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- Q18: Calculate quantity sold by product
SELECT 
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY total_quantity_sold DESC;

-- Q19: Find categories generating more than KSh 100,000 in revenue
SELECT 
    product_category,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS category_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
HAVING SUM(quantity * unit_price * (1 - discount / 100.0)) > 100000
ORDER BY category_revenue DESC;

-- Q20: Calculate the percentage of cancelled orders
SELECT 
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_status = 'Cancelled') / COUNT(*), 2) AS cancelled_orders_percentage
FROM orders;
--11.25%


-- SECTION C

-- Q21: Display orders with customer names and cities
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city,
    o.product_name,
    o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Q22: Calculate total spending by customer (including zero-spend customers)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(COALESCE(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 0), 2) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id 
                   AND o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- Q23: Identify customers who have never ordered
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
--12 customers

-- Q24: Find the 10 highest-spending customers
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q25: Calculate revenue by customer city
SELECT 
    c.city,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Q26: Identify customers with more than five orders (all order statuses count)
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;

-- Q27: Calculate average customer spending by segment
---Compute total completed spending per purchasing customer, then average those totals per segment.
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.customer_segment,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS customer_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_segment
)
SELECT 
    customer_segment,
    ROUND(AVG(customer_spent), 2) AS avg_customer_spending
FROM customer_totals
GROUP BY customer_segment
ORDER BY avg_customer_spending DESC;

-- Q28: Identify the most popular category among VIP customers
---is evaluated by total units sold (quantity) on completed orders.
SELECT 
    o.product_category,
    SUM(o.quantity) AS total_units_bought,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_segment = 'VIP'
  AND o.order_status = 'Completed'
GROUP BY o.product_category
ORDER BY total_units_bought DESC
LIMIT 1;
--Home Appliances with 28 orders and 54 units bought

-- SECTION D

-- Q29: Find customers spending above the average total spending per purchasing customer
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;
--43 customers

-- Q30: Find products priced above the overall average unit price
SELECT DISTINCT 
    product_name,
    unit_price
FROM orders
WHERE unit_price > (SELECT AVG(unit_price) FROM orders)
ORDER BY unit_price DESC;
--8 products

-- Q31: Use a CTE to identify the three highest-revenue months
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS sales_month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    sales_month,
    revenue
FROM monthly_revenue
ORDER BY revenue DESC
LIMIT 3;

-- Q32: Find customers purchasing from at least three categories
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.product_category) AS distinct_categories_bought
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.product_category) >= 3
ORDER BY distinct_categories_bought DESC;
--55 customers

-- Q33: Use a CTE to calculate category revenue, cost, profit, and profit margin
WITH category_metrics AS (
    SELECT 
        product_category,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS total_revenue,
        SUM(quantity * cost_price) AS total_cost
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT 
    product_category,
    ROUND(total_revenue, 2) AS revenue,
    ROUND(total_cost, 2) AS cost,
    ROUND(total_revenue - total_cost, 2) AS profit,
    ROUND(((total_revenue - total_cost) / NULLIF(total_revenue, 0)) * 100.0, 2) AS profit_margin_pct
FROM category_metrics
ORDER BY profit DESC;

-- Q34: Find customers whose latest completed order is more than 90 days before the latest order date in the dataset
WITH dataset_max_date AS (
    SELECT MAX(order_date) AS max_date 
    FROM orders
),
customer_latest_order AS (
    SELECT 
        customer_id,
        MAX(order_date) AS latest_completed_order
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    clo.latest_completed_order,
    (dmd.max_date - clo.latest_completed_order) AS days_inactive
FROM customer_latest_order clo
CROSS JOIN dataset_max_date dmd
JOIN customers c ON clo.customer_id = c.customer_id
WHERE (dmd.max_date - clo.latest_completed_order) > 90
ORDER BY days_inactive DESC;
--47 customers

--SECTION E

-- Q35: Rank customers by spending using RANK()
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM customer_totals;

-- Q36: Number each customer's orders by recency using ROW_NUMBER()
SELECT 
    customer_id,
    order_id,
    order_date,
    product_name,
    order_status,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id 
        ORDER BY order_date DESC, order_id DESC
    ) AS recency_rank
FROM orders;

-- Q37: Rank products within categories using DENSE_RANK() (ranked by unit price)
SELECT DISTINCT 
    product_category,
    product_name,
    unit_price,
    DENSE_RANK() OVER (
        PARTITION BY product_category 
        ORDER BY unit_price DESC
    ) AS price_rank_in_category
FROM orders;

-- Q38: Calculate cumulative monthly revenue
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS monthly_rev
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    sales_month,
    ROUND(monthly_rev, 2) AS monthly_revenue,
    ROUND(SUM(monthly_rev) OVER (ORDER BY sales_month ASC), 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY sales_month ASC;

-- Q39: Compare monthly revenue using LAG()
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS sales_month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS current_rev
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    sales_month,
    current_rev AS current_month_revenue,
    LAG(current_rev, 1) OVER (ORDER BY sales_month ASC) AS previous_month_revenue
FROM monthly_revenue
ORDER BY sales_month ASC;

-- Q40: Calculate month-over-month revenue growth (%)
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS rev
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
mom_calc AS (
    SELECT 
        sales_month,
        rev,
        LAG(rev) OVER (ORDER BY sales_month ASC) AS prev_rev
    FROM monthly_revenue
)
SELECT 
    sales_month,
    ROUND(rev, 2) AS current_revenue,
    ROUND(prev_rev, 2) AS previous_revenue,
    ROUND(((rev - prev_rev) / NULLIF(prev_rev, 0)) * 100.0, 2) AS mom_growth_pct
FROM mom_calc
ORDER BY sales_month ASC;

-- Q41: Divide customers into four spending groups using NTILE(4)
WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id 
                       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile
FROM customer_spend;

-- Q42: Calculate each category's share of total revenue using window functions
WITH category_totals AS (
    SELECT 
        product_category,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS cat_rev
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT 
    product_category,
    ROUND(cat_rev, 2) AS category_revenue,
    ROUND(SUM(cat_rev) OVER (), 2) AS total_company_revenue,
    ROUND((cat_rev / SUM(cat_rev) OVER ()) * 100.0, 2) AS revenue_share_pct
FROM category_totals
ORDER BY revenue_share_pct DESC;

--SECTION F

-- Q43: Create a monthly_sales_summary view (month, orders, revenue, cost, profit)
-- Total orders count all statuses; revenue, cost, and profit count Completed orders only.
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT 
    DATE_TRUNC('month', order_date)::DATE AS sales_month,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(CASE WHEN order_status = 'Completed' THEN quantity * unit_price * (1 - discount / 100.0) ELSE 0 END), 2) AS revenue,
    ROUND(SUM(CASE WHEN order_status = 'Completed' THEN quantity * cost_price ELSE 0 END), 2) AS cost,
    ROUND(SUM(CASE WHEN order_status = 'Completed' THEN (quantity * unit_price * (1 - discount / 100.0)) - (quantity * cost_price) ELSE 0 END), 2) AS profit
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY sales_month ASC;

SELECT * 
FROM monthly_sales_summary;


-- Q44: Create a PostgreSQL function returning completed-order revenue for a supplied customer ID
-- Must return 0 (not NULL) for customers with no orders or non-existent IDs.
CREATE OR REPLACE FUNCTION get_customer_revenue(p_customer_id INTEGER)
RETURNS NUMERIC LANGUAGE plpgsql AS $$
DECLARE 
    v_total_revenue NUMERIC;
BEGIN
    SELECT COALESCE(SUM(quantity * unit_price * (1 - discount / 100.0)), 0)
    INTO v_total_revenue
    FROM orders
    WHERE customer_id = p_customer_id 
      AND order_status = 'Completed';
      
    RETURN ROUND(v_total_revenue, 2);
END;
$$;

-- Test Case 1: Existing customer (e.g., customer_id = 1)
SELECT get_customer_revenue(1) AS existing_customer_revenue;
--452,544.45

-- Test Case 2: Non-existent customer ID (must return 0.00, not NULL)
SELECT get_customer_revenue(999999) AS non_existent_customer_revenue;
--0


-- Q45: Segment customers into High, Medium, and Low Value
-- Justification of Thresholds:
-- - High Value (>= KSh 100,000): Represents key top-tier enterprise, corporate, or bulk tech buyers.
-- - Medium Value (KSh 30,000 to 99,999.99): Core regular retail and multi-unit electronics purchasers.
-- - Low Value (< KSh 30,000): Occasional, single-accessory, or inactive registered users.
WITH customer_total_spend AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id 
                       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    ROUND(total_spend, 2) AS total_spend,
    CASE 
        WHEN total_spend >= 100000 THEN 'High Value'
        WHEN total_spend >= 30000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_value_segment
FROM customer_total_spend
ORDER BY total_spend DESC;


-- Q46: Produce a management report
-- (Top 5 customers, top 5 products, most profitable category, lowest-revenue month)

-- 46.1: Top 5 Customers by Completed Spend
SELECT 
    'Top 5 Customers' AS report_section,
    c.customer_name AS item_name,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 2) AS metric_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_name
ORDER BY metric_value DESC
LIMIT 5;

-- 46.2: Top 5 Products by Completed Revenue
SELECT 
    'Top 5 Products' AS report_section,
    product_name AS item_name,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS metric_value
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY metric_value DESC
LIMIT 5;

-- 46.3: Most Profitable Category
SELECT 
    'Most Profitable Category' AS report_section,
    product_category AS item_name,
    ROUND(SUM((quantity * unit_price * (1 - discount / 100.0)) - (quantity * cost_price)), 2) AS metric_value
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY metric_value DESC
LIMIT 1;
--Mobile Phones - 728,760.65

-- 46.4: Lowest-Revenue Month
SELECT 
    'Lowest-Revenue Month' AS report_section,
    DATE_TRUNC('month', order_date)::DATE::TEXT AS item_name,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS metric_value
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY metric_value ASC
LIMIT 1;

-- Q46: Produce a unified management report
--Top 5 customers, top 5 products, most profitable category, lowest-revenue month

(
    SELECT 
        '1. Top Customers' AS metric_category,
        c.customer_name AS item_name,
        ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)), 2) AS amount_ksh
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_name
    ORDER BY amount_ksh DESC
    LIMIT 5
)
UNION ALL
(
    SELECT 
        '2. Top Products' AS metric_category,
        product_name AS item_name,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS amount_ksh
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_name
    ORDER BY amount_ksh DESC
    LIMIT 5
)
UNION ALL
(
    SELECT 
        '3. Most Profitable Category' AS metric_category,
        product_category AS item_name,
        ROUND(SUM((quantity * unit_price * (1 - discount / 100.0)) - (quantity * cost_price)), 2) AS amount_ksh
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
    ORDER BY amount_ksh DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 
        '4. Lowest-Revenue Month' AS metric_category,
        DATE_TRUNC('month', order_date)::DATE::TEXT AS item_name,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS amount_ksh
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
    ORDER BY amount_ksh ASC
    LIMIT 1
);