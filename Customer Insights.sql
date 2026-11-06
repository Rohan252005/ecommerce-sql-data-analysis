-- QUESTIONS
-- Customer Insights
-- 2.1 Who are the top 10 customers by total revenue spent?
SELECT *
FROM (SELECT C.CustomerID ,  SUM(Quantity * Price) AS Revenue
FROM customers C
JOIN orders O 
ON C.CustomerID = O.CustomerID
JOIN orderdetails OD
ON OD.OrderID = O.OrderID
JOIN products P 
ON  OD.ProductID = P.ProductID
GROUP BY C.CustomerID) AS T
ORDER BY Revenue DESC
Limit 10;

-- 2.2 What is the repeat customer rate?
SELECT 
	COUNT(*) * 100.0/
    (SELECT COUNT(DISTINCT CustomerID)FROM orders)
      AS RepeatCustomerRate
FROM (
 SELECT CustomerID
    FROM orders
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
 )AS RepeatCustomers;
	
    
-- 2.3 What is the average time between two consecutive orders for the same customer Region-wise?
WITH RankedOrders AS(
SELECT O.CustomerID,O.OrderDate,C.RegionID,
		ROW_NUMBER() OVER(PARTITION BY O.CustomerID ORDER BY O.OrderDate) AS Rnk
       FROM orders O 
       JOIN customers C ON C.CustomerID = O.CustomerID),
OrderPairs AS(
SELECT curr.CustomerID,curr.RegionID,DATEDIFF(curr.OrderDate ,`prev` .OrderDate) AS DaysBetween
FROM RankedOrders curr
JOIN RankedOrders `prev` ON curr.CustomerID = `prev` .CustomerID AND curr.Rnk =`prev`.Rnk + 1),

RegionName AS(
	SELECT CustomerID,RegionName,DaysBetween
    FROM OrderPairs OP
    JOIN regions R ON R.RegionID = OP.regionID) 
    
SELECT RegionName ,ROUND(AVG(DaysBetween),2) AS AvgDaysBetwen
FROM RegionName 
GROUP BY RegionName
ORDER BY AvgDaysBetwen;

-- 2.4 Customer Segment (based on total spend)
/*Platinum: Total Spend > 1500
Gold: 1000–1500
Silver: 500–999
Bronze: < 500*/
WITH CustomerSpend AS(
SELECT O.CustomerID,SUM(OD.Quantity * P.Price) AS TotalSpend
FROM orders O
JOIN orderdetails OD ON O.OrderID = OD.OrderID
JOIN products P ON P.ProductID = OD.ProductID
GROUP BY O.CustomerID)

SELECT CustomerName,
		CASE WHEN TotalSpend > 1500 THEN "Platinum"
        WHEN TotalSpend BETWEEN 1000 AND 1500 THEN "Gold"
        WHEN TotalSpend BETWEEN 500 AND 999 THEN "Silver"
        WHEN TotalSpend < 500 THEN "Bronze"
        END AS Segment 
FROM CustomerSpend CS
JOIN customers C ON C.CustomerID = CS.CustomerID;

-- 2.5 What is the customer lifetime value (CLV)? CUSTOMER LIFETIME VALUE = TOTAL REVENUE PER CUSTOMER
SELECT C.CustomerID ,C.CustomerName , SUM(OD.Quantity*P.Price) AS CLV
FROM customers C
JOIN orders O ON O.CustomerID =C.CustomerID
JOIN orderdetails OD ON OD.OrderID = O.OrderID
JOIN Products P 	on P.ProductID = OD.ProductID
GROUP BY  C.CustomerID ,C.CustomerName
ORDER BY CLV DESC;

SELECT * FROM products ;
SELECT * FROM orderdetails;
SELECT * FROM orders ;
SELECT * FROM regions;
SELECT * FROM customers;