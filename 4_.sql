--Which category contribute the most to overall sales ?
WITH category_sales AS (
	SELECT
	  p.category AS category,
	  SUM(f.sales_amount) AS TOTAL_SALES
	FROM
	  gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
	GROUP BY 
	  p.category
)

SELECT
  category,
  total_sales,
  SUM(total_sales) OVER() AS overall_sales,
  ROUND((total_sales/SUM(total_sales) OVER())*100,2) ||'%' AS PERCENTAGE_OF_TOTAL 
FROM
  category_sales
ORDER BY
  total_sales DESC