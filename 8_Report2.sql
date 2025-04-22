/*
==============================================================================================
Product Report 
==============================================================================================
Purpose:
  - This report consolidates key product metrices and behaviours.

Highlights:
  1. Gathers essential fields such as product name, category, subcategory, and cost.
  2. Segments products by revenue to identify High-Performance, Mid-Range, or Low-Performers.
  3. Aggregates product-level metrics:
    - total orders
	- total sales
	- total quantity sold
	- total customers(unique)
	- lifespan (in months)
  4. Calculates valuable KPIs:
    - recency (months since last sale)
	- average order revenue (AOR)
	- average monthly revenue
==============================================================================================
*/

CREATE OR REPLACE VIEW gold.report_products AS
WITH base_query AS (
/*
----------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
----------------------------------------------------------------------------------------------
*/
	SELECT
	  p.product_name AS product_name,
	  p.category AS category,
	  p.subcategory AS subcategory,
	  f.quantity AS quantity,
	  f.customer_key AS customer,
	  p.cost AS product_cost,
	  f.order_number AS order_number,
	  f.order_date AS order_date,
	  f.shipping_date AS shipping_date,
	  f.due_date AS due_date,
	  f.sales_amount AS sales_amount
	FROM
	  gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
	WHERE
	  f.order_date IS NOT NULL
)
, product_aggregation AS (
/*
----------------------------------------------------------------------------------------------
2) Product Aggregation: Summarize key metrics at the customer level
----------------------------------------------------------------------------------------------
*/
	SELECT
	  product_name,
	  category,
	  subcategory,
	  product_cost,
	  COUNT(DISTINCT customer) AS total_customers,
	  SUM(quantity) AS total_quantity,
	  COUNT(order_number) AS total_orders,
	  MAX(order_date) AS last_sale,
	  Extract('YEAR' FROM AGE(MAX(order_date),MIN(order_date)))*12 + EXTRACT('MONTH' FROM AGE(MAX(order_date),MIN(order_date))) AS lifespan,
	  SUM(sales_amount) AS total_revenue
	FROM
	  base_query
	GROUP BY 
	  product_name,
	  category,
	  subcategory,
	  product_cost
)

SELECT
  product_name,
  category,
  subcategory,
  product_cost,
  total_customers,
  total_quantity,
  total_orders,
  lifespan||' '||'Months' AS lifespan,
  total_revenue,
  CASE
    WHEN total_revenue < 70000 THEN 'Low-Performers'
	WHEN total_revenue BETWEEN 70000 AND 200000 THEN 'Mid-Range'
	ELSE 'High-Performance'
  END AS product_segment,
  EXTRACT('YEAR' FROM AGE(CURRENT_DATE,last_sale))*12 + EXTRACT('MONTH' FROM AGE(CURRENT_DATE,last_sale))||' '||'Months' AS recency_since_last_sale,
  CASE
    WHEN total_orders = 0 THEN 0
	ELSE total_revenue / total_orders
  END AS avg_order_revenue,
  CASE 
    WHEN lifespan = 0 THEN total_revenue
	ELSE ROUND(total_revenue / lifespan,1)
  END AS average_monthly_revenue
FROM
  product_aggregation

--Using the view 
SELECT
  product_segment,
  SUM(total_revenue) AS total_sales
FROM
  gold.report_products
GROUP BY 
  product_segment
