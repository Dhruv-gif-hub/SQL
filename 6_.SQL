/* Group customers into three segments based on their spending behavior:
  - VIP: Customers with at least 12 months of history and spending more than $5,000.
  - Regular: Customers with at least 12 months of history of spending $5,000 or less.
  - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_spending AS (
	SELECT
	  c.customer_key,
	  SUM(f.sales_amount) AS TOTAL_SPENDING,
	  MIN(order_date) AS FIRST_ORDER,
	  MAX(order_date) AS LAST_ORDER,
	  AGE(MAX(order_date),MIN(order_date))  AS LIFESPAN
	FROM
	  gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
	GROUP BY 
	  c.customer_key
)

SELECT
  CUSTOMER_SEGMENTS,
  COUNT(customer_key) AS TOTAL_CUSTOMERS
FROM(
	SELECT
	  customer_key,
	  total_spending,
	  lifespan,
	  CASE
	    WHEN lifespan >= INTERVAL'12 MONTHS' AND TOTAL_SPENDING > 5000 THEN 'VIP'
		WHEN lifespan >= INTERVAL'12 MONTHS' AND TOTAL_SPENDING <= 5000 THEN 'Regular'
		ELSE 'New'
	  END AS CUSTOMER_SEGMENTS
	FROM
	  customer_spending
) 
GROUP BY 
  CUSTOMER_SEGMENTS
ORDER BY
  TOTAL_CUSTOMERS DESC