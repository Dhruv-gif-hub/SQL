/* 
================================================================
================================================================
Customer Report
================================================================
Purpose
  - This report consolidates key customer metrices and behaviors

Highlights:
  1. Gathers essential fields such as names, ages, and transaction details.
  2. Segments customers into categories (VIP, Regular, New) and age groups.
  3. Aggregates customer-level metrices:
    - total orders
	- total sales
	- total quabtity purchased
	- total products
	- lifespan (in months)
  4. Calculates valuable KPIs:
    - recency (months since last order)
	- average order value
	- average monthly spend
================================================================
*/

CREATE OR REPLACE VIEW gold.report_customers AS
WITH base_query AS(
/*
----------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
----------------------------------------------------------------
*/
	SELECT
	  f.order_number,
	  f.product_key,
	  f.order_date,
	  f.sales_amount,
	  f.quantity,
	  c.customer_key AS customer_key,
	  c.customer_number AS customer_number,
	  c.first_name || ' ' || c.last_name AS customer_name,
	  AGE(CURRENT_DATE,c.birthdate) AS customer_age
	FROM
	  gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON c.customer_key = f.customer_key
	WHERE
	  order_date IS NOT NULL AND birthdate IS NOT NULL
)
, customer_aggregation AS(
/*
----------------------------------------------------------------
2) Customer Aggregation: Summarize key metrics at the customer level
----------------------------------------------------------------
*/
	SELECT
	  customer_key,
	  customer_number,
	  customer_name,
	  customer_age,
	  COUNT(DISTINCT order_number) AS total_orders,
	  SUM(sales_amount) AS total_sales,
	  SUM(quantity) AS total_quantity,
	  COUNT(DISTINCT product_key) AS total_products,
	  MAX(order_date) AS last_order_date,
	  MIN(order_date) AS first_order_date,
	  AGE(MAX(order_date),MIN(order_date))  AS lifespan  
	FROM
	  base_query
	GROUP BY
	  customer_key,
	  customer_number,
	  customer_name,
	  customer_age
)

SELECT
  customer_key,
  customer_number,
  customer_name,
  customer_age,
  CASE 
    WHEN customer_age < INTERVAL'20 YEARS' THEN 'Under 20'
	WHEN customer_age BETWEEN INTERVAL'20 YEARS' AND INTERVAL'29 YEARS' THEN '20-29'
	WHEN customer_age BETWEEN INTERVAL'30 YEARS' AND INTERVAL'39 YEARS' THEN '30-39'
	WHEN customer_age BETWEEN INTERVAL'40 YEARS' AND INTERVAL'49 YEARS' THEN '40-49'
	ELSE '50 and Above'
  END AS age_group,
  CASE
    WHEN lifespan >= INTERVAL'12 MONTHS' AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= INTERVAL'12 MONTHS' AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
  END AS CUSTOMER_SEGMENTS,
  AGE(CURRENT_DATE,last_order_date) AS Recency,
  total_orders,
  total_sales,
  total_quantity,
  total_products,
  first_order_date,
  last_order_date,
  lifespan,
  -- Compute average order value (AVO)
  CASE 
    WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders 
  END AS avg_order_value,
  -- Compute average monthly spend
  CASE 
    WHEN EXTRACT('YEAR' FROM lifespan)*12 + EXTRACT('MONTH' FROM lifespan) = 0 THEN total_sales
    ELSE ROUND(total_sales / (EXTRACT('YEAR' FROM lifespan)*12 + EXTRACT('MONTH' FROM lifespan)),1)
  END AS avg_monthly_spend
FROM
  customer_aggregation
  

--Using the view 
SELECT
  customer_segments,
  COUNT(customer_number) AS total_customers,
  SUM(total_sales) AS total_sales
FROM
  gold.report_customers
GROUP BY 
  customer_segments









