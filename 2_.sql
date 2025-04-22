--Calculate the total sales per month
--and the running total of sales over time

SELECT
  order_date,
  total_sales,
  SUM(total_sales) OVER(PARTITION BY TO_CHAR(order_date,'yyyy') ORDER BY order_date) AS RUNNING_TOTAL_SALES
FROM
(
	SELECT
	  (DATE_TRUNC('month',order_date))::DATE AS order_date,
	  SUM(sales_amount) AS TOTAL_SALES
	FROM
	  gold.fact_sales
	WHERE 
	  order_date IS NOT NULL
	GROUP BY
	  (DATE_TRUNC('month',order_date))::DATE 
)



SELECT
  order_date,
  total_sales,
  SUM(total_sales) OVER(ORDER BY order_date) AS RUNNING_TOTAL_SALES
FROM
(
	SELECT
	  (DATE_TRUNC('year',order_date))::DATE AS order_date,
	  SUM(sales_amount) AS TOTAL_SALES
	FROM
	  gold.fact_sales
	WHERE 
	  order_date IS NOT NULL
	GROUP BY
	  (DATE_TRUNC('year',order_date))::DATE 
)


SELECT
  order_date,
  total_sales,
  SUM(total_sales) OVER(ORDER BY order_date) AS RUNNING_TOTAL_SALES,
  ROUND(AVG(AVG_PRICE) OVER(ORDER BY order_date),1) AS MOVING_AVG_PRICE
FROM
(
	SELECT
	  (DATE_TRUNC('year',order_date))::DATE AS order_date,
	  SUM(sales_amount) AS TOTAL_SALES,
	  AVG(price) AS AVG_PRICE
	FROM
	  gold.fact_sales
	WHERE 
	  order_date IS NOT NULL
	GROUP BY
	  (DATE_TRUNC('year',order_date))::DATE 
)

