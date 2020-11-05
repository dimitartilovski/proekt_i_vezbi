USE CompanyDB
GO

select * from Orders
---------------------------------------------
;with cte as (
select c.CustomerID,c.CompanyName,c.ContactName
from dbo.Customers c
)
select * from cte

;with orderDetails_cte ([Name],[Surname],[Total Orders]) as
(
select e.FirstName,e.LastName, count(o.EmployeeID)[Total] from Employees e 
inner join dbo.Orders o
on e.EmployeeID = o.EmployeeID
group by e.FirstName,e.LastName
)
select * from orderDetails_cte

;with WithMostOrders_cto([Name],[Count]) as
(
select top 1 e.FirstName,count(o.OrderID) from Orders o
inner join Employees e on o.EmployeeID  = e.EmployeeID
group by e.FirstName
order by count(o.OrderID) desc
)
select * from WithMostOrders_cto

--------------------------------------------------------
DECLARE @totalOrderCount INT = (SELECT COUNT(*) FROM dbo.Orders)
IF @totalOrderCount > 500
BEGIN
PRINT 'Total order count is larger than 500'
END
ELSE
BEGIN
PRINT 'Total order count is less than 500'
END
-------------------------------------------------------
;with cityOrders AS (
SELECT * FROM Orders WHERE ShipCity = 'London' OR ShipCity = 'Lyon'
)
select * FROM cityOrders

-------------------------------------------------------
;WITH cte_employee_orders AS(
SELECT employeeID FROM dbo.Employees WHERE City LIKE 'London'
)

SELECT EmployeeID, ShipVia, Freight, ShipCity, ShipCountry FROM dbo.Orders
WHERE EmployeeID IN (SELECT * FROM cte_employee_orders)

--------------------------------------------------------

SELECT
	RegionID, RegionDescription,
CASE
	RegionID
	WHEN 1 THEN 'E'
	WHEN 2 THEN 'W'
	WHEN 3 THEN 'N'
	WHEN 4 THEN 'S'
	ELSE 'No region'
END AS [Region Abbreviation]
FROM dbo.Region;

-------------------------------------------------------

DECLARE @date DATE = GETDATE();
DECLARE @isLeap INT = 0;
IF (YEAR(@date) % 400 = 0 OR (YEAR(@date) % 4 = 0 AND YEAR (@date) % 100 !=0))
SET @isLeap = 1;
SELECT @isLeap

DECLARE @month INT = MONTH (GETDATE());
DECLARE @days INT;
SELECT @days = CASE
	WHEN @month= 1 THEN 31
	WHEN @month= 2 THEN 28 + @isLeap
	WHEN @month= 3 THEN 31
	WHEN @month= 4 THEN 30
	WHEN @month= 5 THEN 31
	WHEN @month= 6 THEN 30
	WHEN @month= 7 THEN 31
	WHEN @month= 8 THEN 31
	WHEN @month= 9 THEN 30
	WHEN @month= 10 THEN 31
	WHEN @month= 11 THEN 30
	WHEN @month= 12 THEN 31
	END;
SELECT @days [days in the current month]

---------------------------------------------------
SELECT
	CustomerID,CompanyName,City,Country,
	CASE
		WHEN Country IN ('Germany','Sweden','France','Spain','Switzerand','Italy') THEN 'Europe'
		WHEN Country IN ('USA','Canada') THEN 'North America'
		WHEN Country IN ('Venezuela','Argentina','Brazil') THEN 'South America'
		WHEN Country IN ('Mexico') THEN 'Central America'
		WHEN Country IN ('Japan','China','India') THEN 'ASIA'
		ELSE 'Check the continent'
	END [Continent]
FROM dbo.Customers

----------------------------------------------------

BEGIN TRY
SELECT 100/0
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()
END CATCH

----------------------------------------------------
--BEGIN CATCH
--	SELECT
--		ERROR_NUMBER() AS ErrorNumber,
--		ERROR_SEVERITY() AS ErrorSeverity,
--		ERROR_STATE() AS ErrorState,
--		ERROR_
----------------------------------------------------
SELECT * FROM Products
SELECT * FROM Suppliers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Categories

--1.
SELECT * FROM Products WHERE UnitsInStock = 0

--2.
SELECT s.CompanyName,p.* FROM Products p
inner join dbo.Suppliers AS s
on s.SupplierID = p.SupplierID
WHERE UnitsInStock = 0 AND Discontinued = 0

--3.
SELECT * FROM Products WHERE (UnitsOnOrder + UnitsInStock) < ReorderLevel

--4.
SELECT p.ProductName, o.CustomerID FROM dbo.Products p
inner join dbo.Orders o
on p.ProductID = o.CustomerID
group by p.ProductID,o.CustomerID 

--5.
SELECT p.ProductName, COUNT(o.ProductID) [Total]
FROM dbo.Products p
INNER JOIN dbo.[Order Details] o
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Total DESC

--6.
SELECT p.ProductName, COUNT(o.ProductID) [Total], SUM(o.Quantity) [Quantity]
FROM dbo.Products p
INNER JOIN dbo.[Order Details] o
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Quantity DESC

--7.
select  c.CategoryName,s.CompanyName from Categories c
inner join products p on c.CategoryID = p.CategoryID
inner join Suppliers s on s.SupplierID = p.SupplierID
group by  c.CategoryName,s.CompanyName