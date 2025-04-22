/* Segment products into cast ranges and count how many products fall into
each segment */

WITH product_segment AS (
	SELECT
	  product_key,
	  product_name,
	  cost,
	  CASE
	    WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	  END AS COST_RANGE
	FROM
	  gold.dim_products
)

SELECT
  cost_range,
  COUNT(product_key) AS TOTAL_PRODUCTS 
FROM
  product_segment
GROUP BY 
  COST_RANGE
ORDER BY 
  TOTAL_PRODUCTS DESC