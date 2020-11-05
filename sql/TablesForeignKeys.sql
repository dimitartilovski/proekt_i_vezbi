CREATE VIEW TablesForeignKeys
AS
SELECT t.[name] [Table name], fk.[name] [FK name]
FROM [sys].tables AS t
JOIN [sys].foreign_keys fk ON fk.parent_object_id = t.object_id

SELECT * FROM TablesForeignKeys

CREATE VIEW [dbo].[EmployeesWithMoreThan50Customers]
AS
SELECT o.[EmployeeID], e.[FirstName] +' '+e.[LastName] [FullName],
COUNT (DISTINCT o.[CustomerID]) [CustomersCount]
FROM [Orders] AS o
INNER JOIN [Employees] e ON e.[EmployeeID] = o.EmployeeID
INNER JOIN [Customers] c ON c.[CustomerID] = o.[CustomerID]
GROUP BY o.[EmployeeID], e.[LastName],e.[FirstName]
HAVING COUNT (DISTINCT o.CustomerID) >50
GO

SELECT * FROM EmployeesWithMoreThan50Customers

---------------------------------------------------------------------------------

CREATE PROCEDURE dbo.SalesByYear
	@Beginning_Date DATETIME,
	@Ending_Date DATETIME
AS
BEGIN
SELECT o.ShippedDate, o.OrderID, YEAR(o.ShippedDate) AS [YEAR]
FROM dbo.Orders AS o
WHERE o.ShippedDate BETWEEN @Beginning_Date AND @Ending_Date
END

EXEC dbo.SalesByYear @Beginning_date = '1996-06-01',@Ending_Date = '1997-06-01'

ALTER PROCEDURE dbo.SalesByYear
	@Beginning_Date DATETIME,
	@Ending_Date DATETIME,
	@Ret INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET @Ret =0
SELECT o.ShippedDate, o.OrderID, YEAR(o.ShippedDate) AS [YEAR]
FROM dbo.Orders AS o
WHERE o.ShippedDate BETWEEN @Beginning_Date AND @Ending_Date
END

DECLARE @Out INT 
EXEC dbo.SalesByYear @Beginning_date = '1996-06-01',@Ending_Date = '1997-06-01',@Ret = @Out OUTPUT

SELECT @Out AS [output]

ALTER PROC dbo.spOrdersByCity
	@City NVARCHAR(60)
AS
BEGIN

SELECT * FROM Orders
WHERE ShipCity = @City
END

EXEC dbo.spOrdersByCity @City = 'London'

----------------------------------------------------------------------------------

CREATE FUNCTION dbo.CountOrderByCity(@City NVARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @theCount INT=0;
	SELECT @theCount = (SELECT COUNT(*) FROM dbo.Orders WHERE ShipCity = @City);
	RETURN @theCount;
END;

SELECT dbo.CountOrderByCity('London') [Orders Count]

CREATE FUNCTION dbo.FULLName (@FirstName NVARCHAR(30),@LastName NVARCHAR(30))
RETURNS NVARCHAR(60)
AS 
BEGIN
DECLARE @FULLName NVARCHAR(60);
SET @FULLName = @FirstName+' '+@LastName;
RETURN @FULLName;
END


--Procedura

alter procedure dbo.TwoNumbersSum
@Number1 int,
@Number2 int
@Sum int

AS
BEGIN

select @Number1+@Number2

END
EXEC dbo.[TwoNumbersSum]
@Number1=10,
@Number2=20

--funkcija

create function dbo.SumOfTwoNumbers(@Number1 int,@Number2 int)
returns int
as 
begin
declare @Sum int


set @Sum=@Number1+@Number2
return @Sum;
end
select dbo.SumOfTwoNumbers(10,20)
