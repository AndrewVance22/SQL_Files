--Andrew Vance

--1
SELECT
	FirstName
	,LastName
FROM Employee
WHERE ReportsTo IS NOT NULL

--2
SELECT
	*
FROM Customer
WHERE STATE <> 'CA' 
	OR STATE IS NULL

--3
SELECT *
FROM Invoice
WHERE InvoiceDate BETWEEN '2010-04-01' AND '2010-05-01'

--4
SELECT 
	Title
	,AlbumId
FROM Album
WHERE Title LIKE 'THE %'

--5
SELECT *
FROM Album
WHERE Title LIKE '[^A-Z]%'

--6
SELECT 
	CustomerId
	,BillingCity
	,BillingCountry
	,InvoiceDate
FROM Invoice 
WHERE BillingCountry IN ('Canada','Germany','France','Spain','India')
ORDER BY InvoiceDate DESC

--7
SELECT *
FROM Album
WHERE ArtistId IN(
	SELECT ArtistId
	FROM Artist
	WHERE Name LIKE '%Black%')

--8
SELECT *
FROM Track T
WHERE NOT EXISTS(
	SELECT *
	FROM InvoiceLine I
	WHERE T.TrackId = I.TrackId)

--9
SELECT *
FROM Track
WHERE (MediaTypeId = 5 AND GenreId <> 1)
	OR Composer = 'Gene Simmons'

--10
SELECT *
FROM Track
WHERE AlbumId = 237
	AND (Composer LIKE '%Dylan%' or Composer LIKE '%Hendrix%')