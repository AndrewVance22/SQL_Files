--Andrew Vance

--1
SELECT CEILING(RAND()*101+99) AS RandomNumber;

--2
SELECT
	TrackId,
	Name,
	CEILING(RAND(CAST(NEWID() AS varbinary))*3000) AS RandomByRow
FROM Track
ORDER BY 3 DESC;

--3
SELECT
	ArtistId,
	Name,
	ROW_NUMBER() OVER (ORDER BY NewID()) AS RandomUniqueID
FROM Artist;

--4
WITH CTE AS
(
SELECT
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	SUM(IL.UnitPrice) AS TotalSales,
	CASE WHEN
		T.MediaTypeID <> 3 THEN 'Audio'
		ELSE 'Video'
	END AS Media
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN InvoiceLine IL
	ON IL.TrackId = T.TrackId
GROUP BY A.Name, AL.Title, CASE WHEN T.MediaTypeID <> 3 THEN 'Audio' ELSE 'Video' END
)
SELECT 
	*,
	RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS Ranking,
	DENSE_RANK() OVER (PARTITION BY Media ORDER BY TotalSales DESC) AS DenseRanking
FROM CTE
WHERE TotalSales > 15;

--5
WITH CTE AS
(
SELECT
	G.Name AS GenreName,
	AL.Title AS AlbumTitle,
	SUM(IL.UnitPrice) AS TotalSales,
	RANK() OVER (PARTITION BY G.Name ORDER BY SUM(IL.UnitPrice) DESC) AS Ranking
FROM Album AL
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN Genre G
	ON G.GenreId = T.GenreId
JOIN InvoiceLine IL
	ON IL.TrackId = T.TrackId
GROUP BY G.Name, AL.Title
HAVING SUM(IL.UnitPrice) > 15
)
SELECT *
FROM CTE
WHERE Ranking <= 3;

--6
SELECT
	A.Name AS ArtistName,
	SUM(IL.UnitPrice) AS TotalPrice,
	SUM(SUM(IL.UnitPrice)) OVER (ORDER BY A.Name) AS RunningTotal
FROM Artist A
JOIN Album Al
	ON A.ArtistId = AL.ArtistID
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN InvoiceLine IL
	ON IL.TrackId = T.TrackId
GROUP BY A.Name;

--7
SELECT
	BillingCountry,
	SUM(Total) AS TotalPrice,
	NTILE(5) OVER (ORDER BY SUM(Total) DESC, BillingCountry) AS Quintile
FROM Invoice
GROUP BY BillingCountry;

--8
SELECT
	C.FirstName,
	C.LastName,
	C.Country,
	CAST(I.InvoiceDate AS Date) AS InvoiceDate,
	I.Total,
	SUM(Total) OVER (PARTITION BY C.CustomerId) AS TotalByCustomer,
	SUM(Total) OVER (PARTITION BY C.Country) AS TotalByCountry
FROM Customer C
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
ORDER BY Country, LastName, Total;

--9
SELECT 
	AL.Title AS AlbumTitle,
	CONVERT(varchar, dateadd(ms,SUM(T.milliseconds) OVER (PARTITION BY AL.AlbumId),0),108) AS AlbumTime,
	ROW_NUMBER() OVER (PARTITION BY AL.AlbumId ORDER BY Milliseconds DESC) AS TrackNumber,
	T.Name AS TrackName,
	COUNT(*) OVER (PARTITION BY AL.AlbumId) AS TrackCount,
	CONVERT(varchar,dateadd(ms,Milliseconds,0),108) AS TrackTime
FROM Artist A
JOIN Album AL
	ON A.ArtistId = AL.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
WHERE A.Name = 'Green Day'
ORDER BY AlbumTitle, TrackNumber;

--10
WITH CTE AS
( 
SELECT
	BillingCountry,
	YEAR(InvoiceDate) AS BillingYear,
	SUM(Total) AS CurrentYear
FROM Invoice
WHERE BillingCountry IN ('USA','Canada')
GROUP BY BillingCountry, YEAR(InvoiceDate)
)
SELECT
	BillingCountry,
	BillingYear,
	CurrentYear,
	LAG(CurrentYear,1,0) OVER (PARTITION BY BillingCountry ORDER BY BillingYear) PriorYear,
	CurrentYear - LAG(CurrentYear,1,0) OVER (PARTITION BY BillingCountry ORDER BY YEAR(BillingYear)) AS YearDifference
FROM CTE
ORDER BY BillingCountry;

	
