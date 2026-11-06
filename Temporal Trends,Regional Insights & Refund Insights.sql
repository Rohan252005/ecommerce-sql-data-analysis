-- Temporal Trends
-- 4.1 What are the monthly sales trends over the past year?
SELECT YEAR(OrderDate) AS `Year`,
		MONTH(OrderDate) AS `Month`,
        SUM(OD.Quantity*P.Price) AS Revenue
FROM orders O
JOIN orderdetails OD ON OD.OrderID = O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
WHERE OrderDate >= (
    SELECT DATE_SUB(MAX(OrderDate), INTERVAL 12 MONTH)
    FROM orders
)
GROUP BY `Year`, `Month`
ORDER BY `Year`, `Month`;

-- 4.2 How does the average order value (AOV) change by month or week?
SELECT DATE_FORMAT(OrderDate,"%Y-%m") AS Period,
	ROUND(SUM(OD.Quantity*P.Price)/COUNT(DISTINCT O.OrderID),2) AS AOV
FROM orders O
JOIN orderdetails OD ON OD.OrderID = O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY Period
ORDER BY Period;
     
     
-- Regional Insights
-- 5.1 Which regions have the highest order volume and which have the lowest?
SELECT RegionName, COUNT(OrderID) AS OrderVolume
FROM orders O
JOIN customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
GROUP BY RegionName
ORDER BY OrderVolume DESC;

-- 5.2 What is the revenue per region and how does it compare across different regions?
SELECT RegionName,SUM(OD.Quantity*P.Price) AS TotalRevenue 
FROM orders O
JOIN customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
JOIN orderdetails OD ON OD.OrderID =O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY RegionName
ORDER BY  TotalRevenue DESC;

-- Compare across different regions
WITH T1 AS(SELECT RegionName, COUNT(OrderID) AS OrderVolume
FROM orders O
JOIN customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
GROUP BY RegionName
ORDER BY OrderVolume DESC),

T2 AS(SELECT RegionName,SUM(OD.Quantity*P.Price) AS TotalRevenue 
FROM orders O
JOIN customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
JOIN orderdetails OD ON OD.OrderID =O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY RegionName
ORDER BY  TotalRevenue DESC
)
SELECT T1.RegionName ,OrderVolume,TotalRevenue
FROM T1
JOIN T2 ON T1.RegionName = T2.RegionName;

-- Return & Refund Insights

-- 6.1 What is the overall return rate by product category?
SELECT Category,
    ROUND(SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END)/COUNT(O.OrderID),2) AS ReturnRate
  FROM orders O  
  JOIN orderdetails OD ON OD.OrderID = O.OrderID
  JOIN products P ON P.ProductID = OD.ProductID
  GROUP BY P.Category
  ORDER BY ReturnRate DESC;
-- 6.2 What is the overall return rate by region?


SELECT RegionName,
    ROUND(SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END)/COUNT(O.OrderID),2) AS ReturnRate
  FROM orders O  
  JOIN customers C ON C.CustomerID = O.CustomerID
  JOIN Regions R ON R.RegionID = C.RegionID
  GROUP BY R.RegionName
  ORDER BY ReturnRate DESC;
  
  
-- 6.3 Which customers are making frequent returns?
SELECT C.CustomerID,C.CustomerName,COUNT(O.OrderID) AS ReturnCount
FROM orders O
JOIN customers C ON C.CustomerID = O.CustomerID
WHERE IsReturned = 1
GROUP BY C.CustomerID,C.CustomerName
ORDER BY ReturnCount DESC
LIMIT 10;




SELECT * FROM products ; 
SELECT * FROM orderdetails;
SELECT * FROM orders ;
SELECT * FROM regions;
SELECT * FROM customers;