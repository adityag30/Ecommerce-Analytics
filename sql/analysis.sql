CREATE DATABASE ecommerce_analytics;

USE ecommerce_analytics;

CREATE TABLE transactions (
    InvoiceNo VARCHAR(30),
    StockCode VARCHAR(30),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DOUBLE,
    CustomerID BIGINT,
    Country VARCHAR(100),
    Revenue DOUBLE,
    Month VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'C:/Users/adity/OneDrive/Desktop/Ecommerce-Analytics/data/processed/transactions_cleaned.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity,
 InvoiceDate, UnitPrice, CustomerID, Country, Revenue, Month);
 
SELECT COUNT(*) AS total_rows
FROM transactions;

SELECT *
FROM transactions
LIMIT 5;

#total revenue
SELECT ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions;

#total orders
SELECT COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM transactions;

#total customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM transactions
WHERE CustomerID IS NOT NULL;

#average order value
SELECT
    ROUND(
        SUM(Revenue) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS Average_Order_Value
FROM transactions;

#monthly revenue
SELECT
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue
FROM transactions
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year,Month;
    
#top products
SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions
WHERE Description IS NOT NULL
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10;

#top 10 countries
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;

#top 10 customers
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    ROUND(SUM(Revenue), 2) AS Total_Spending
FROM transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Spending DESC
LIMIT 10;

#repeat customers
SELECT COUNT(*) AS Repeat_Customers
FROM (
    SELECT CustomerID
    FROM transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) AS customer_orders;

#revenue by customers
SELECT
    CustomerID,
    MIN(InvoiceDate) AS First_Purchase,
    MAX(InvoiceDate) AS Last_Purchase,
    COUNT(DISTINCT InvoiceNo) AS Purchase_Frequency,
    ROUND(SUM(Revenue), 2) AS Monetary_Value
FROM transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Monetary_Value DESC;

#rank countries by revenue
WITH country_revenue AS (
    SELECT
        Country,
        ROUND(SUM(Revenue), 2) AS Total_Revenue
    FROM transactions
    GROUP BY Country
)
SELECT Country,Total_Revenue, RANK() OVER (
	ORDER BY Total_Revenue DESC
) AS Revenue_Rank
FROM country_revenue
ORDER BY Revenue_Rank;

#monthly ranking
WITH monthly_revenue AS (
    SELECT
        YEAR(InvoiceDate) AS Year,
        MONTH(InvoiceDate) AS Month,
        ROUND(SUM(Revenue), 2) AS Revenue
    FROM transactions
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
)
SELECT Year,Month,Revenue,RANK() OVER (
	ORDER BY Revenue DESC
) AS Revenue_Rank
FROM monthly_revenue
ORDER BY Year, Month;



CREATE TABLE customer_segments (
    CustomerID BIGINT,
    Recency INT,
    Frequency INT,
    Monetary DOUBLE,
    Cluster INT,
    CustomerSegment VARCHAR(50)
);

LOAD DATA LOCAL INFILE
'C:/Users/adity/OneDrive/Desktop/Ecommerce-Analytics/data/processed/customer_rfm_segments.csv'
INTO TABLE customer_segments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, Recency, Frequency, Monetary, Cluster, CustomerSegment);

SELECT COUNT(*) AS total_customers
FROM customer_segments;

SELECT *
FROM customer_segments
LIMIT 10;

SELECT
    CustomerSegment,
    COUNT(*) AS Customers,
    ROUND(AVG(Recency), 2) AS Avg_Recency,
    ROUND(AVG(Frequency), 2) AS Avg_Frequency,
    ROUND(AVG(Monetary), 2) AS Avg_Monetary
FROM customer_segments
GROUP BY CustomerSegment
ORDER BY Avg_Monetary DESC;

#revenue contribution by segment
SELECT
    CustomerSegment,
    COUNT(*) AS Customers,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(
        100 * SUM(Monetary) /
        (SELECT SUM(Monetary)
         FROM customer_segments),
        2
    ) AS Revenue_Percentage
FROM customer_segments
GROUP BY CustomerSegment
ORDER BY Total_Revenue DESC;

#identify high value customers
SELECT
    CustomerID,
    Recency,
    Frequency,
    ROUND(Monetary, 2) AS Monetary,
    CustomerSegment
FROM customer_segments
ORDER BY Monetary DESC
LIMIT 10;

#high-value customers who are becoming inactive
SELECT
    CustomerID,
    Recency,
    Frequency,
    ROUND(Monetary, 2) AS Monetary,
    CustomerSegment
FROM customer_segments
WHERE Recency > 90
  AND Monetary > 1000
ORDER BY Monetary DESC;

#best segment
SELECT
    CustomerSegment,
    ROUND(AVG(Frequency), 2) AS Avg_Frequency,
    ROUND(AVG(Monetary), 2) AS Avg_Monetary
FROM customer_segments
GROUP BY CustomerSegment
ORDER BY Avg_Monetary DESC
LIMIT 1;

#how much transaction revenue comes from each customer segment
SELECT
    cs.CustomerSegment,
    COUNT(DISTINCT t.CustomerID) AS Customers,
    ROUND(SUM(t.Revenue), 2) AS Transaction_Revenue
FROM transactions t
JOIN customer_segments cs
    ON t.CustomerID = cs.CustomerID
GROUP BY cs.CustomerSegment
ORDER BY Transaction_Revenue DESC;

#revenue by segmnet and country
SELECT
    cs.CustomerSegment,
    t.Country,
    ROUND(SUM(t.Revenue), 2) AS Revenue
FROM transactions t
JOIN customer_segments cs
    ON t.CustomerID = cs.CustomerID
GROUP BY
    cs.CustomerSegment,
    t.Country
ORDER BY Revenue DESC
LIMIT 20;


#segment summary
SELECT
    CustomerSegment,
    COUNT(*) AS Customers,
    ROUND(AVG(Recency), 2) AS Avg_Recency,
    ROUND(AVG(Frequency), 2) AS Avg_Frequency,
    ROUND(AVG(Monetary), 2) AS Avg_Monetary
FROM customer_segments
GROUP BY CustomerSegment
ORDER BY Avg_Monetary DESC;

#revenue contribution
SELECT
    CustomerSegment,
    COUNT(*) AS Customers,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(
        100 * SUM(Monetary) /
        (SELECT SUM(Monetary) FROM customer_segments),
        2
    ) AS Revenue_Percentage
FROM customer_segments
GROUP BY CustomerSegment
ORDER BY Total_Revenue DESC;

#segment + transaction revenue
SELECT
    cs.CustomerSegment,
    COUNT(DISTINCT t.CustomerID) AS Customers,
    ROUND(SUM(t.Revenue), 2) AS Transaction_Revenue
FROM transactions t
JOIN customer_segments cs
    ON t.CustomerID = cs.CustomerID
GROUP BY cs.CustomerSegment
ORDER BY Transaction_Revenue DESC;
