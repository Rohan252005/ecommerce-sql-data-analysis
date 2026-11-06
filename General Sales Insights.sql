-- Questions:
-- General Sales Insights
-- 1.1 What is the total revenue generated over the entire period?(revenve = quantity*price)
	SELECT SUM(OD.Quantity * P.Price) AS Total_Revenue
	FROM orderdetails OD
    JOIN products P 
    ON OD.ProductID = P.ProductID;
    
-- 1.2 Revenue Excluding Returned Orders
	SELECT SUM(OD.Quantity * P.Price) AS Total_Revenue_Excluding_Order
	FROM orderdetails OD
    JOIN products P 
    ON OD.ProductID = P.ProductID
    JOIN orders O 
    ON O.OrderID = OD.OrderID
    WHERE O.IsReturned <> 1;
    
-- 1.3 Total Revenue per Year / Month
SELECT YEAR(OrderDate) AS `Year`,
	MONTH(OrderDate) AS `Month`,SUM(OD.Quantity * P.Price) AS Total_Revenue
	FROM orderdetails OD
    JOIN products P 
    ON OD.ProductID = P.ProductID
    JOIN orders O 
    ON O.OrderID = OD.OrderID
    GROUP BY `Month`,`Year`
    ORDER BY `Month`,`Year`;

-- 1.4 Revenue by Product / Category
SELECT SUM(Quantity * Price) AS Total_Revenue, ProductName, Category 
FROM orderdetails OD
JOIN products P 
ON OD.ProductID = P.ProductID
GROUP BY ProductName, Category 
ORDER BY ProductName, Category ;

-- 1.5 What is the average order value (AOV) across all orders?
SELECT O.OrderID , SUM(Quantity * Price)/COUNT(O.OrderID) AS AOV 
FROM products P
JOIN orderdetails OD
ON P.ProductID = OD.ProductID
JOIN orders O
ON O.OrderID = OD.OrderID
GROUP BY OrderID
ORDER BY OrderID ASC;


-- 1.6 AOV per Year / Month
SELECT YEAR(O.OrderDate) AS `Year`,
		MONTH(O.OrderDate) AS `Month`,
SUM(Quantity * Price)/ COUNT(DISTINCT O.OrderID) AS AOV
FROM products P
JOIN orderdetails OD
ON P.ProductID = OD.ProductID
JOIN orders O
ON O.OrderID = OD.OrderID
GROUP BY `Year`,`Month`
ORDER BY `Year`,`Month`;

-- 1.7 What is the average order size by region?
SELECT RegionName , AVG(AVG_SIZE) AS average_order_size
FROM (SELECT O.OrderID,C.RegionID,SUM(OD.Quantity) AS AVG_SIZE
		FROM orders O
		JOIN customers C 
		ON C.CustomerID = O.CustomerID
		JOIN orderdetails OD
		ON OD.OrderID = O.OrderID
		GROUP BY O.OrderID,C.RegionID) AS OrderSize
JOIN regions R
ON R.RegionID = OrderSize.RegionID
GROUP BY RegionName
ORDER BY average_order_size DESC;


SELECT * FROM products ;
SELECT * FROM orderdetails;
SELECT * FROM orders ;
SELECT * FROM regions;
SELECT * FROM customers;

