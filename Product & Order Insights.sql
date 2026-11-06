-- Product & Order Insights

-- 3.1 What are the top 10 most sold products (by quantity)?
SELECT P.ProductID ,P.ProductName,SUM(OD.Quantity) AS TotalQty
FROM orderdetails OD
JOIN Products P ON P.ProductID =OD.ProductID
GROUP BY P.ProductID ,P.ProductName
ORDER BY TotalQty DESC
LIMIT 10;

-- 3.2What are the top 10 most sold products (by revenue)?
SELECT P.ProductID ,P.ProductName,SUM(OD.Quantity*P.Price) AS Revenue
FROM orderdetails OD
JOIN products P ON OD.ProductID =OD.ProductID
GROUP BY P.ProductID ,P.ProductName
ORDER BY Revenue DESC 
LIMIT 10;

-- 3.3 Which products have the highest return rate? RETURN RATE =(RETURNED QUANTITY / TOTAL QUANTITY)
WITH Sold AS(
SELECT ProductID,SUM(Quantity) AS TotalQty
FROM orderdetails 
GROUP BY ProductID
),
Returned AS( 
SELECT ProductID,SUM(Quantity) AS TotalQtyReturned
FROM orderdetails OD
JOIN orders O ON O.OrderID = OD.OrderID
WHERE IsReturned = 1
GROUP BY ProductID	
)
SELECT ProductName,ROUND(TotalQtyReturned/TotalQty,2) AS ReturnRate
FROM Products P 
JOIN Sold S ON S.ProductID = P.ProductID
JOIN Returned R ON R.ProductID = P.ProductID
ORDER BY ReturnRate DESC
LIMIT 10;


-- Return Rate by Category
WITH Sold AS(
SELECT Category,SUM(Quantity) AS TotalQty
FROM orderdetails OD
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY Category
),
Returned AS( 
SELECT Category,SUM(Quantity) AS TotalQtyReturned
FROM orderdetails OD
JOIN orders O ON O.OrderID = OD.OrderID
JOIN products P ON P.ProductID = OD.ProductID
WHERE IsReturned = 1
GROUP BY Category	
)
SELECT S.Category,ROUND(TotalQtyReturned/TotalQty,2) AS ReturnRate
FROM Sold S
JOIN  Returned R ON R.Category = S.Category
ORDER BY ReturnRate DESC
LIMIT 10;

-- What is the average price of products per region? AVG(PRICE) = TOTTALREVENUE/TOTALQTY
SELECT RegionName,ROUND(SUM(OD.Quantity*P.Price)/SUM(OD.Quantity),2) AS AvgPrice
FROM orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON	R.RegionID = C.RegionID
JOIN orderdetails OD ON OD.OrderID = O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY RegionName
ORDER BY AvgPrice DESC;


-- What is the sales trend for each product category? 
SELECT DATE_FORMAT(OrderDate,"%Y-%m") AS Period,Category,SUM(OD.Quantity*P.price) AS Revenue
FROM orders O
JOIN orderdetails OD ON OD.OrderID = O.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY Period,Category
ORDER BY Period,Category;


SELECT * FROM products ;
SELECT * FROM orderdetails;
SELECT * FROM orders ;
SELECT * FROM regions;
SELECT * FROM customers;