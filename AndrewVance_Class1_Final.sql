--Andrew Vance

--1
SELECT Top 10 WITH TIES
	Art.Name AS 'Artist Name',
	SUM(IL.UnitPrice) AS 'Total Sales'
FROM Artist Art
JOIN Album Alb
	ON Art.ArtistId = Alb.ArtistId
JOIN Track T
	ON T.AlbumId = Alb.AlbumId
JOIN InvoiceLine IL
	ON IL.TrackId = T.TrackId
JOIN Invoice I
	ON I.InvoiceId = IL.InvoiceId
JOIN MediaType MT
	ON MT.MediaTypeId = T.MediaTypeId
WHERE T.MediaTypeId <> 3
AND I.InvoiceDate BETWEEN '2011-07-01' AND '2012-06-30'
GROUP BY Art.Name
ORDER BY [Total Sales] DESC

--2
SELECT 
	CONCAT(E.FirstName,' ',E.LastName) AS [Employee Name],
	YEAR(I.InvoiceDate) AS [Calender Year],
	CASE DATENAME(Quarter, I.InvoiceDate)
		WHEN '1' THEN 'First'
		WHEN '2' THEN 'Second'
		WHEN '3' THEN 'Third'
		WHEN '4' THEN 'Fourth'
		END AS [Sales Quarter],
	MAX(I.Total) AS 'Highest Sale',
	COUNT(I.InvoiceId) AS 'Number of Sales',
	SUM(I.Total) AS 'Total Sales'
FROM Employee E
JOIN Customer C
	ON C.SupportRepId = E.EmployeeId
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
WHERE I.InvoiceDate BETWEEN '2010-01-01' AND '2012-06-30'
GROUP BY CONCAT(E.FirstName,' ',E.LastName), YEAR(I.InvoiceDate), DATENAME(QUARTER, I.InvoiceDate)
ORDER BY [Employee Name], [Calender Year], DATENAME(QUARTER, I.InvoiceDate)

--3
SELECT
	P.Name AS 'Playlist Name',
	P.PlaylistId AS 'Playlist ID',
	PT.TrackId AS 'Track ID'
FROM Playlist P
FULL JOIN PlaylistTrack PT
	ON PT.PlaylistId = P.PlaylistId
WHERE EXISTS(
	SELECT *
	FROM Playlist PL
	WHERE PL.Name = P.Name
	AND PL.PlaylistId < P.PlaylistId)
ORDER BY P.PlaylistId

--4
SELECT
	C.Country AS 'Country',
	Art.Name AS 'Artist Name',
	COUNT(IL.TrackId) AS 'Track Count',
	COUNT(Distinct IL.TrackId) AS 'Unique Track Count',
	COUNT(IL.TrackId)-COUNT(Distinct IL.TrackId) AS 'Count Difference',
	SUM(IL.UnitPrice) AS 'Total Revenue',
	CASE T.MediaTypeId
		WHEN 3 THEN 'Video'
		ELSE 'Audio'
		END AS 'Media Type'
FROM Customer C
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
JOIN InvoiceLine IL
	ON I.InvoiceId = IL.InvoiceId
JOIN Track T
	ON T.TrackId = IL.TrackId
JOIN Album A
	ON A.AlbumId = T.AlbumId
JOIN Artist Art
	ON Art.ArtistId = A.ArtistId
WHERE I. InvoiceDate BETWEEN '2009-07-01' AND '2013-06-30'
GROUP BY C.Country, Art.Name, CASE T.MediaTypeId
		WHEN 3 THEN 'Video'
		ELSE 'Audio'
		END
ORDER BY Country, [Track Count] DESC, [Artist Name]

--5
SELECT 
	CONCAT(FirstName,' ',LastName) AS 'Full Name',
	CONVERT(varchar, BirthDate, 101) AS 'Birth Date',
	CONVERT(varchar,DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate)), 101) AS 'Birth Day 2016',
	DATENAME(WEEKDAY, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDAte))) AS 'Birth Day of Week',
	CASE DATENAME(WEEKDAY, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDAte)))
		WHEN 'Saturday' THEN CONVERT(varchar,DATEADD(DAY, 2, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate))), 101)
		WHEN 'Sunday' THEN CONVERT(varchar,DATEADD(DAY, 1, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate))), 101)
		ELSE CONVERT(varchar,DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate)), 101)
		END AS 'Celebration Date',
	DATENAME(WEEKDAY, CASE DATENAME(WEEKDAY, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDAte)))
		WHEN 'Saturday' THEN CONVERT(varchar,DATEADD(DAY, 2, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate))), 101)
		WHEN 'Sunday' THEN CONVERT(varchar,DATEADD(DAY, 1, DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate))), 101)
		ELSE CONVERT(varchar,DATEFROMPARTS(2016, MONTH(BirthDate), DAY(BirthDate)), 101)
		END) AS 'Celebration Day Of Week'
FROM Employee
