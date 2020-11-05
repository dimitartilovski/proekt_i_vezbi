USE CompanyDB

SELECT * FROM dbo.Orders

--1. Count all Orders that were made in Year 1996
SELECT COUNT(*) FROM dbo.Orders WHERE YEAR(OrderDate) = 1996

--2. Count orders grouped by Employees
select e.FirstName, e.LastName, o.EmployeeID, count(*) [TotalOrders] from orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
group by o.EmployeeID, e.FirstName, e.LastName

--3. Count orders grouped by Customers
select c.CustomerID, c.CompanyName, count(*) [Total Orders] from dbo.Customers AS c
INNER JOIN dbo.Orders AS o
ON o.CustomerID = c.CustomerID
group by c.CompanyName, c.CustomerID

----------------------------------------------------------------------------------
--total freight>50 i nema nitu edna freight pomala od 10
--EmployID  FirstName  LastName   TotalOrders
--11122    Riste       Pazarkoski 456 
select e.FirstName, e.LastName, o.EmployeeID, SUM(Freight) > 50  from orders o
inner join Employees e on e.EmployeeID = o.EmployeeID
group by o.EmployeeID, e.FirstName, e.LastName, o.Freight
HAVING (Freight) > 10
----------------------------------------------------------------------------------

--4. What is the averige quantity was ordered (Order Details) grouper by Product?
select p.ProductName, avg(od.Quantity) [AvgQuantity] from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
group by p.ProductName

--5. Find the MIN date an Order was made
Select MIN(OrderDate) from dbo.Orders

--6. Find the MAX date an  Order was made
Select MAX(OrderDate) from dbo.Orders

--7. List cities by Count of orders
select c.ShipCity, count(*) AS [Total] from dbo.Orders AS c
group by ShipCity
order by ShipCity

--8. List the cities that are having between 10 and 15 orders
Select o.shipcity, COUNT (o.orderid) as [Total] From dbo.Orders o
group by o.ShipCity
having COUNT(o.orderid) between 10 and 15
order by Total

--9. What is the sum for the Freight for all the Orders
SELECT SUM(Freight) FROM dbo.Orders