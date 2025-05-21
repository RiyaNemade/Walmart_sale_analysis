CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
	total DECIMAL(10 ,6),
    date DATE NOT NULL,
    time TIME NOT NULL,
	payment VARCHAR(30),
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12 ,4) NOT NULL,
    rating FLOAT
);

--time_of_day


SELECT time,
	CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day
FROM sales

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day=(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END );
	
DROP TABLE sales;

SELECT * FROM sales;

--day_name

SELECT date, TO_CHAR(date, 'Day') AS day_name
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = (TO_CHAR(date, 'Day')) ;

--month_name

SELECT date, TO_CHAR(date, 'Month') AS month_name
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = (TO_CHAR(date, 'Month'))

SELECT * FROM sales;

-- Top & Bottom Performing Branches

SELECT branch,SUM(total) AS total_sale
FROM sales
GROUP by branch
ORDER BY total_sale DESC;

--Branch B generated $112,000 in revenue, outperforming Branch C by $110,568.

--Product Line Profitability

SELECT product_line,SUM(gross_income) AS total_profit
FROM sales
GROUP by product_line
ORDER BY total_profit DESC;

--Food & Beverages brought in the highest profit of $2673.56.

-- Monthly Revenue Trend (MoM Growth)

SELECT 
    Month_name,
    ROUND(SUM(Total), 2) AS Monthly_Revenue
FROM sales
GROUP BY Month_name
ORDER BY Monthly_Revenue;

--January contributed the highest revenue with 38.35% of total sales and 
--February sales decreased by approximately 16.4% compared to January

--Peak Business time

SELECT 
    time_of_day,
    SUM(total) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC
limit 5;

SELECT EXTRACT(HOUR FROM time) AS hours ,SUM(total) AS total_sales
FROM sales
GROUP BY hours
ORDER BY total_sales DESC
LIMIT 5;

--Evening hours(17h-20h) generated $138,370.92, which is 123.90% higher than Morning sales and 12.6% more than Afternoon.

--Peak Business day

SELECT 
    day_name,
    SUM(total) AS total_sales
FROM sales
GROUP BY day_name
ORDER BY total_sales DESC;

--Saturday contributed $56,120.81, the highest sales day of the week.

--Customer Type Contribution

SELECT customer_type,ROUND(SUM(total),2) AS total_sale
FROM sales
GROUP BY customer_type;

--Member customers contributed 50.85% of total revenue despite being 49.15% of total shoppers.

--Payment Mode Distribution

SELECT 
    Payment,
    COUNT(*) AS Transactions,
    ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY Payment
ORDER BY Revenue DESC;

--345 transactions were made via eWallets (the highest), yet revenue is slightly lower than cash.
--Cash payments generated $112,206.57, which is the highest revenue among all methods.
--Gender-Based Purchase Patterns

SELECT 
    Gender,
    COUNT(*) AS Transactions,
    ROUND(SUM(Total), 2) AS Total_sale
FROM sales
GROUP BY Gender;

--Female customers spend about $24.31 more per transaction, or +7.8% higher.

--Customer Satisfaction by Branch

SELECT 
    branch,
    AVG(Rating) AS Avg_Rating
FROM sales
GROUP BY Branch
ORDER BY Avg_Rating DESC;

--Branch B has the lowest average rating of 6.8, while Branch C has 7.07.

--Customer Satisfaction by Product

SELECT 
    Product_line,
    AVG(Rating) AS Avg_Rating
FROM sales
GROUP BY Product_line
ORDER BY Avg_Rating DESC;

--Food and Beverage has highest rating than anyone else.


--High-Value Customers (Top Invoices)

SELECT 
    invoice_id,
    gender,
    customer_type,
    branch,ROUND(Total, 2) AS Invoice_Amount
FROM sales
ORDER BY Invoice_Amount DESC
LIMIT 10;

--6 out of 10 top-paying customers are Female, and 4 out of 10 are Members.
--Tax Collected by Product Line

SELECT 
    Product_line,
    SUM(vat) AS Total_Tax,
    ROUND(SUM(gross_income), 2) AS Total_Profit
FROM sales
GROUP BY Product_line
ORDER BY Total_Tax DESC;

----Food and Beverages generated the highest profit and tax contribution:
--Profit: 2673.56 | Tax: 2673.564

--January generated the highest revenue: ₹116,291.87.
--Evening hours accounted for ₹138,370.92, the highest sales.
--Saturday leads with ₹56,120.81, making it the most profitable day.
--Female customers contributed ₹167,882.93, 8.3% more than males.
--Food and Beverages is the top-performing line:
--

