
--Andrew Vance

--1
SELECT
	Name,
	REPLACE(Name, ' & ',' and ') AS NewName
FROM Genre
Where Name like '%&%'

--2
SELECT
	FirstName +' '+ LastName AS FullName,
	DAY(BirthDate) AS Day,
	DATENAME(MONTH, BirthDate) AS Month,
	YEAR(BirthDate) AS Year
FROM Employee

--3
SELECT
	REPLACE(Title, ' ','') AS TitleNoSpaces,
	UPPER(Title) AS TitleUpperCase,
	REVERSE(Title) AS TitleReverse,
	LEN(Title) AS TitleLength,
	CHARINDEX(' ', Title) AS SpaceLocation
FROM Album

--4
SELECT
	FirstName,
	LastName,
	BirthDate,
	DATEDIFF(DAY, BirthDate,GETDATE())/365 AS Age
FROM Employee

--5
SELECT
	Title,
	LTRIM(SUBSTRING(Title,CHARINDEX(' ',Title),Len(Title))) AS ShortTitle
FROM Employee

--6
SELECT
	FirstName,
	LastName,
	LEFT(FirstName, 1) + LEFT(LastName, 1) AS Initials
FROM Customer
ORDER BY Initials

--7
SELECT
	FirstName,
	LastName,
	REPLACE((REPLACE(Phone, '+1 ', '')), '-', ' ') AS Phone,
	ISNULL(REPLACE((REPLACE(Fax, '+1 ', '')), '-', ' '), 'Unknown') AS Fax
FROM Customer
WHERE Country = 'USA'
ORDER BY LastName

--8
SELECT
	UPPER(LastName +', '+FirstName) AS CustomerName,
	ISNULL(Company, 'N/A') AS Company
FROM Customer
WHERE LastName LIKE '[A-M]%'
ORDER BY LastName

--9
SELECT
	InvoiceId,
	CustomerId,
	Total,
	CONVERT(Date, InvoiceDate, 1) AS InvoiceDate,
	CONCAT('FY',DATENAME(YEAR,(DATEADD(MONTH,6,InvoiceDate)))) AS FiscalYear
FROM Invoice
ORDER BY InvoiceDate DESC

--10
SELECT
	IIF(Country = 'USA' OR Country = 'Canada', 'Domestic', 'International') AS CustomerType,
	FirstName,
	LastName,
	Country
FROM Customer
ORDER BY CustomerType, LastName
