--Question 1 : Total quantity sold for all products

SELECT details.product_name, SUM(sales.qty) AS total_sales_qty
FROM sales 
JOIN product_details AS details
ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY total_sales_qty DESC

--Question 2 : Total revenue generated before discounts for all products

SELECT SUM(price*qty) AS total_revenue_without_discount
FROM sales

--Question 3 : Total revenue generated after discounts for all products

SELECT SUM((price - discount)*qty) AS total_revenue_with_discount
FROM sales

--Question 4 : Total discounts for all products
SELECT SUM(price*qty*discount)/100 AS total_discount
FROM sales 

--Question 4 : Unique Transactions
SELECT COUNT(DISTINCT txn_id) AS unique_transactions
FROM sales


--Question 5 : What are average unique products purchased in each transaction

WITH CTE_transaction_products AS(
  SELECT COUNT(DISTINCT prod_id) AS unique_product_count, txn_id
  FROM sales
  GROUP BY txn_id
) 
SELECT ROUND(AVG(unique_product_count), 2) AS average_unique_product FROM cte_transaction_products



--Question 6 : Average discount value per transaction
WITH CTE_transaction_discount AS(
  SELECT SUM(price*qty*discount)/100 AS total_discount, txn_id
  FROM sales
  GROUP BY txn_id
) 
SELECT ROUND(AVG(total_discount), 2) AS average_discount_product FROM CTE_transaction_discount


--Question 7 : Average revenue for member transactions and non member transactions

WITH CTE_member_revenue AS (
 SELECT member, txn_id, SUM(price*qty) as revenue
 FROM sales
 GROUP BY member , txn_id
)
SELECT member, ROUND(AVG(revenue),2) AS average_revenue FROM CTE_member_revenue
GROUP BY member

--Question 8 : top 3 products by total revenue before discount


SELECT TOP 3 product_details.product_name, SUM(sales.price*sales.qty) AS total_revenue_without_discount
FROM sales
JOIN product_details
ON sales.prod_id = product_details.product_id
GROUP BY product_details.product_name
ORDER BY total_revenue_without_discount DESC

--Question 9 : total quantity, revenue and discount for each segment
SELECT product_details.segment_name, product_details.segment_id, SUM(sales.qty) AS total_sales, SUM(sales.price*sales.qty) AS total_revenue, SUM(sales.price*sales.qty*sales.discount)/100 AS total_discount
FROM sales 
JOIN product_details
ON sales.prod_id = product_details.product_id
GROUP BY product_details.segment_name, product_details.segment_id

--Question 10 : top selling product for each segment
SELECT TOP 5 details.segment_id, details.segment_name, details.product_id, details.product_name, SUM(sales.qty) AS product_quantity
FROM sales
JOIN product_details AS details
ON sales.prod_id = details.product_id
GROUP BY details.segment_name, details.segment_id,  details.product_id, details.product_name
ORDER BY product_quantity DESC

--Question 11 : total quantity, revenue and discount for each category
SELECT product_details.category_name, product_details.category_id, SUM(sales.qty) AS total_sales, SUM(sales.price*sales.qty) AS total_revenue, SUM(sales.price*sales.qty*sales.discount)/100 AS total_discount
FROM sales 
JOIN product_details
ON sales.prod_id = product_details.product_id
GROUP BY product_details.category_name, product_details.category_id

--Question 12 : total quantity, revenue and discount for each category

SELECT TOP 5 details.category_name, details.category_id, details.product_id, details.product_name, SUM(sales.qty) AS product_quantity
FROM sales
JOIN product_details AS details
ON sales.prod_id = details.product_id
GROUP BY details.category_name, details.category_id,  details.product_id, details.product_name
ORDER BY product_quantity DESC
