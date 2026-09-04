CREATE DATABASE capstone_project_2;
USE capstone_project_2;

-- 1. Create the Customers Table

CREATE TABLE Capstone2_Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    SignupDate DATE,
    AgeGroup VARCHAR(20),
    Segment VARCHAR(50)
);

EXEC sp_help Capstone2_Customers;

SELECT COUNT(*) AS Customer_Count
FROM Capstone2_Customers;

SELECT Top 10*
FROM Capstone2_Customers;



-- 2. Create the Orders Table

CREATE TABLE  Capstone2_Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(20),
    ProductCategory VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Discount DECIMAL(10,2),
    Sales DECIMAL(15,2),
    Profit DECIMAL(15,2),
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    Loss_Flag VARCHAR(20)
);

EXEC sp_help  Capstone2_Orders;

SELECT COUNT(*) AS Order_Count
FROM Capstone2_Orders;

SELECT Top 10*
FROM Capstone2_Orders;

-- Join

SELECT TOP 20
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.Sales,
    o.Profit
FROM Capstone2_Customers c
INNER JOIN Capstone2_Orders o
    ON c.CustomerID = o.CustomerID;

    -- Group By

SELECT
    c.Region,
    SUM(o.Sales) AS Total_Sales,
    SUM(o.Profit) AS Total_Profit,
    COUNT(o.OrderID) AS Order_Count
FROM  Capstone2_Customers c
INNER JOIN  Capstone2_Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Total_Sales DESC;



-- Having

SELECT
    c.Region,
    SUM(o.Sales) AS Total_Sales
FROM Capstone2_Customers c
INNER JOIN Capstone2_Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.Region
HAVING SUM(o.Sales) > 10000000
ORDER BY Total_Sales DESC;


-- CASE Statement

SELECT TOP 20
    OrderID,
    Sales,
    Profit,
    CASE
        WHEN Profit > 0 THEN 'Profit'
        WHEN Profit < 0 THEN 'Loss'
        ELSE 'Break Even'
    END AS Profit_Status
FROM dbo.Capstone2_Orders;


-- Subquery: Orders with Sales Above Average Sales

SELECT
    OrderID,
    CustomerID,
    Sales,
    Profit
FROM dbo.Capstone2_Orders
WHERE Sales > (
    SELECT AVG(Sales)
    FROM dbo.Capstone2_Orders
)
ORDER BY Sales DESC;


-- CTE

WITH Region_Sales AS (
    SELECT
        c.Region,
        SUM(o.Sales) AS Total_Sales
    FROM Capstone2_Customers c
    INNER JOIN Capstone2_Orders o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.Region
)

SELECT
    Region,
    Total_Sales
FROM Region_Sales
WHERE Total_Sales > 10000000
ORDER BY Total_Sales DESC;


-- Window Functions

WITH Region_Sales AS (
    SELECT
        c.Region,
        SUM(o.Sales) AS Total_Sales
    FROM Capstone2_Customers c
    INNER JOIN Capstone2_Orders o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.Region
)

SELECT
    Region,
    Total_Sales,
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM Region_Sales
ORDER BY Sales_Rank;


-- Orphan CustomerID

SELECT
    o.OrderID,
    o.CustomerID,
    o.Sales,
    o.Profit
FROM Capstone2_Orders o
LEFT JOIN Capstone2_Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;