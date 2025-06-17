# 📊 SQL Data Analysis Project

## 📝 Overview

This project demonstrates SQL-based data exploration, cleaning, and analysis performed on the dataset. The goal of the project was to gain actionable insights and practice advanced SQL techniques including joins, window functions, CTEs, subqueries, aggregations, and more.

## Exploring the dataset

```sql
-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema <> 'pg_catalog' AND table_schema <> 'information_schema'

--Explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

--Explore the dimensions
SELECT DISTINCT
  country
FROM
  gold.dim_customers

--Explore all categories 'The major Divisions'
SELECT DISTINCT
  category,
  subcategory,
  product_name
FROM
  gold.dim_products
ORDER BY
  1,2,3

--Date Exploration
--Find the date of the first and the last order
--How many years of sales are available
SELECT
  MIN(order_date) AS FIRST_ORDER_DATE,
  MAX(order_date) AS LAST_ORDER_DATE,
  AGE(MAX(order_date),MIN(order_date)) AS ORDER_RANGE
FROM
  gold.fact_sales


--Find the youngest and the oldest customer
SELECT
  MIN(birthdate) AS OLDEST_BIRTH_DATE,
  AGE(CURRENT_DATE,MIN(birthdate)) AS OLDEST_AGE,
  MAX(birthdate) AS YOUNGEST_BIRTH_DATE,
  AGE(CURRENT_DATE,MAX(birthdate)) AS YOUNGEST_AGE
FROM
  gold.dim_customers


--Find the Total Sales
SELECT
  SUM(sales_amount) AS TOTAL_SALES
FROM
  gold.fact_sales

  
--Find how many items are sold
SELECT
  SUM(quantity) AS TOTAL_QUANTITY
FROM
  gold.fact_sales

  
--Find the average selling price
SELECT
  ROUND(AVG(price),1) AS AVG_SELLING_PRICE
FROM
  gold.fact_sales

  
--Find the Total number of Orders
SELECT
  COUNT(DISTINCT order_number) AS total_orders
FROM
  gold.fact_sales

  
--Find the Total number of products
SELECT
  COUNT(product_key) AS TOTAL_PRODUCTS
FROM
  gold.dim_products
  

--Find the Total number of customers
SELECT
  COUNT(customer_id) AS TOTAL_CUSTOMERS
FROM
  gold.dim_customers


--Find the Total number of customers that has placed an order
SELECT 
  COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS_WITH_ORDERS
FROM
  gold.fact_sales 


--Generate a Report that shows all key metrics of the business

SELECT
  'Total Sales' AS MEASURE_NAME,
  SUM(sales_amount) AS MEASURE_VALUE
FROM
  gold.fact_sales
  
UNION ALL

SELECT
  'Total Quantity' AS MEASURE_NAME,
  SUM(quantity) AS MEASURE_VALUE
FROM
  gold.fact_sales

UNION ALL 

SELECT
  'AVG_SELLING_PRICE' AS MEASURE_NAME,
  ROUND(AVG(price),1) AS MEASURE_VALUE
FROM
  gold.fact_sales

UNION ALL

SELECT
  'total_orders' AS MEASURE_NAME,
  COUNT(DISTINCT order_number) AS MEASURE_VALUE
FROM
  gold.fact_sales

UNION ALL 

SELECT
  'total_products' AS MEASURE_NAME,
  COUNT(product_key) AS MEASURE_VALUE
FROM
  gold.dim_products

UNION ALL 

SELECT
  'total_customers' AS MEASURE_NAME,
  COUNT(customer_id) AS MEASURE_VALUE
FROM
  gold.dim_customers

UNION ALL 

SELECT 
  'total_customer_with_orders' AS MEASURE_NAME,
  COUNT(DISTINCT customer_key) AS MEASURE_VALUE
FROM
  gold.fact_sales 

```

## 🧠 Key Skills Demonstrated
- Joins (INNER, LEFT, RIGHT, FULL)

- CTEs and Subqueries

- Window Functions 

- Aggregations and Grouping

- Data Filtering & Conditional Logic

- Indexing and Performance Tweaks 

- Views


## 📚 Queries
- [First File](https://github.com/Dhruv-gif-hub/SQL/blob/main/1_.sql)

- [Second File](https://github.com/Dhruv-gif-hub/SQL/blob/main/2_.sql)

- [Third File](https://github.com/Dhruv-gif-hub/SQL/blob/main/3_.sql)

- [Fourth File](https://github.com/Dhruv-gif-hub/SQL/blob/main/4_.sql)

- [Fifth File](https://github.com/Dhruv-gif-hub/SQL/blob/main/5_.sql)

- [Sixth File](https://github.com/Dhruv-gif-hub/SQL/blob/main/6_.SQL)

- [Seventh File](https://github.com/Dhruv-gif-hub/SQL/blob/main/7_Report.sql)

- [Eight File](https://github.com/Dhruv-gif-hub/SQL/blob/main/8_Report2.sql)


## 🙋‍♂️ Author
Dhruv Bhatt

[LinkedIn](https://www.linkedin.com/in/dhruv-bhatt-820b61352/)

[Medium](https://medium.com/@dhruvbhatt938_72019)

[Twitter](https://x.com/DhruvBhatt47863)
