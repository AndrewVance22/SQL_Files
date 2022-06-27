--Andrew Vance

--1
SELECT
	T.Name AS 'TrackName',
	MT.Name AS 'MediaName',
	CASE
		WHEN  MT.Name LIKE '%video%' THEN 'Video'
		ELSE 'Audio'
		END AS MediaType,
	CASE
		WHEN  MT.Name LIKE '%AAC%' THEN 'AAC'
		WHEN  MT.Name LIKE '%MPEG%' THEN 'MPEG'
		ELSE 'Unknown'
		END AS EncodingFormat
FROM Track T
JOIN MediaType MT
	ON MT.MediaTypeId = T.MediaTypeId

--2
SELECT
	MT.Name AS 'MediaTypeName',
	COUNT(T.TrackId) TotalTracks
FROM MediaType MT
JOIN Track T
	ON T.MediaTypeId = MT.MediaTypeId
GROUP BY MT.Name
ORDER BY TotalTracks DESC

--3
SELECT
	E.FirstName,
	E.LastName,
	YEAR(I.InvoiceDate) SaleYear,
	SUM(I.Total) TotalSales
FROM Employee E
JOIN Customer C
	ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
GROUP BY E.FirstName, E.LastName, YEAR(I.InvoiceDate)
ORDER BY LastName, SaleYear

--4
SELECT
	C.LastName,
	C.FirstName,
	MAX(I.Total) MaxInvoice
FROM Customer C
JOIN Invoice I
	ON C.CustomerId = I.CustomerId
GROUP BY C.LastName, C.FirstName
ORDER BY LastName

--5
SELECT
	Country,
	PostalCode,
	CASE
		WHEN ISNUMERIC(PostalCode) = 1 THEN 'Yes'
		WHEN ISNUMERIC(PostalCode) = 0 THEN
			CASE
				WHEN PostalCode IS NOT NULL THEN 'No'
				WHEN PostalCode IS NULL THEN 'Unknown'
				END		
		END AS NumericPostalCode
FROM Customer
ORDER BY Country

--6
SELECT
	C.FirstName,
	C.LastName,
	SUM(I.Total) TotalSales
FROM Customer C
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
GROUP BY C.FirstName, C.LastName
HAVING SUM(I.Total) > 42
ORDER BY TotalSales DESC

--7 (Not Sure if you just wanted the artist name, or the number of tracks as well)
SELECT TopArtist
FROM(
SELECT TOP 1
	A.Name AS 'TopArtist',
	COUNT(T.TrackId) NumberOfTracks
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
GROUP BY A.Name
ORDER BY NumberOfTracks DESC
) t

--8
SELECT
	FirstName,
	LastName,
	CASE	
		WHEN LastName Like '[A-G]%' THEN 'Group1'
		WHEN LastName LIKE '[H-M]%' THEN 'Group2'
		WHEN LastName Like '[N-S]%' THEN 'Group3'
		WHEN LastName Like '[T-Z]%' THEN 'Group4'
		ELSE 'NULL'
		END AS CustomerGrouping
FROM Customer
ORDER BY LastName

--9
SELECT
	A.Name AS 'ArtistName',
	COUNT(AL.AlbumId) AlbumCount
FROM Artist A
LEFT JOIN Album AL
	ON A.ArtistId = AL.ArtistId
GROUP BY A.Name
ORDER BY AlbumCount, ArtistName

--10
SELECT
	FirstName,
	LastName,
	Title,
	CASE
		WHEN Title LIKE '%Manager%' THEN 'Management'
		WHEN Title LIKE '%Sales%' THEN 'Sales'
		WHEN Title LIKE '%IT%' THEN 'Technology'
		END AS Department
FROM Employee
ORDER BY Department