--Andrew Vance

--1
SELECT *
FROM Employee

--2
SELECT 
	FirstName AS [First Name]
	,LastName AS [Last Name]
	,Email AS [Email Address]
From Employee

--3
SELECT
	Name AS [Track Title]
	,Composer
	,AlbumId AS [Album ID]
FROM Track
WHERE AlbumId = 19

--4
SELECT 
	Name AS [Track Title]
	,Composer
	,AlbumId AS [Album ID]
FROM Track
WHERE AlbumId = 19
	ORDER BY Composer ASC, Name ASC

--5
SELECT TOP 5
	BillingCountry AS [Country]
	,BillingCity AS [City]
	,Total AS [Billing Total]
FROM Invoice
WHERE BillingCountry <> 'USA'
	ORDER BY Total DESC

--6
SELECT DISTINCT
	State
	,Country
FROM Customer
WHERE Country = 'USA'
	ORDER BY State

--7
SELECT 
	CustomerId AS [Customer ID]
	,BillingCity AS [City]
	,BillingPostalCode AS [ZIP Code]
	,Total AS [Billing Total]
FROM Invoice
WHERE BillingCountry = 'Germany' 
	AND Total > 5
ORDER BY CustomerId ASC, Total DESC

--8
SELECT DISTINCT TOP 20
	Country AS [Country Name]
	,State AS [State or Region]
FROM Customer
ORDER BY Country ASC, State ASC

--9
SELECT
	AlbumId AS [Album ID]
	,MediaTypeID AS [Media Type ID]
	,Name as [Track Title]
FROM Track
WHERE AlbumId <= 5
	OR MediaTypeID = 2
ORDER BY AlbumId ASC

--10
SELECT
	AlbumId AS [Album ID]
	,Name AS [Track Name]
	,Milliseconds
	,UnitPrice AS [Unit Price]
From Track
WHERE (AlbumId = 5 AND Milliseconds > 300000)
	OR UnitPrice > 0.99
ORDER BY AlbumId ASC, Milliseconds ASC