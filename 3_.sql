/* Analyze the yearly performance of products by comparing their sales to both
the average sales performance of the product and the previous year's sales */ 

WITH yearly_product_sales AS ( 
	SELECT
	  TO_CHAR(f.order_date,'YYYY') AS ORDER_YEAR,
	  p.product_name,
	  SUM(f.sales_amount) AS CURRENT_SALES
	FROM
	  gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p 
	ON f.product_key = p.product_key 
	WHERE 
	  TO_CHAR(f.order_date,'YYYY') IS NOT NULL
	GROUP BY
	  TO_CHAR(f.order_date,'YYYY'),
	  p.product_name
)

SELECT
  order_year,
  product_name,
  current_sales,
  ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) AS avg_sales,
  current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) AS DIFF_AVG,
  CASE 
    WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) > 0 THEN 'Above Avg'
	WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) < 0 THEN 'Below Avg'
	ELSE 'Avg'
  END AS AVG_CHANGE,
  --Year-Over-Year-Analysis
  LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS PY_SALES,
  current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS DIFF_PY,
  CASE 
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	ELSE 'No Change'
  END AS PY_CHANGE
FROM
  yearly_product_sales
ORDER BY
  product_name,
  order_year

