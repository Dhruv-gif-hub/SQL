SELECT
  TO_CHAR(order_date,'YYYY') AS YEAR,
  TO_CHAR(order_date,'MM') AS MONTH,
  SUM(sales_amount) AS TOTAL_SALES,
  COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
  SUM(quantity) AS TOTAL_QUANTITY
FROM
  gold.fact_sales
WHERE 
  order_date IS NOT NULL
GROUP BY 
  TO_CHAR(order_date,'YYYY'), 
  TO_CHAR(order_date,'MM')
ORDER BY
  TO_CHAR(order_date,'YYYY'),
  TO_CHAR(order_date,'MM')


SELECT
  (DATE_TRUNC('month',order_date))::DATE AS order_date,  
  SUM(sales_amount) AS TOTAL_SALES,
  COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
  SUM(quantity) AS TOTAL_QUANTITY
FROM
  gold.fact_sales
WHERE 
  order_date IS NOT NULL
GROUP BY 
  (DATE_TRUNC('month',order_date))::DATE
ORDER BY
 (DATE_TRUNC('month',order_date))::DATE



SELECT
  (TO_CHAR(order_date,'yyyy-Mon')) AS order_date,  
  SUM(sales_amount) AS TOTAL_SALES,
  COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
  SUM(quantity) AS TOTAL_QUANTITY
FROM
  gold.fact_sales
WHERE 
  order_date IS NOT NULL
GROUP BY 
  (TO_CHAR(order_date,'yyyy-Mon'))
ORDER BY
  (TO_CHAR(order_date,'yyyy-Mon'))
















































 