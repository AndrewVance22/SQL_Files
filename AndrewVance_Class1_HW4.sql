--Andrew Vance

--1
SELECT
	AR.Name AS ArtistName,
	AL.Title AS AlbumTitle
FROM Artist AS AR
JOIN Album AS AL
	ON AR.ArtistId = AL.ArtistId
WHERE AR.Name LIKE '[A-D]%'
ORDER BY ArtistName, AlbumTitle

--2
SELECT
	AR.Name AS ArtistName,
	AL.Title AS AlbumTitle
FROM Artist AS AR
LEFT JOIN Album AS AL
	ON AR.ArtistId = AL.ArtistId
WHERE AR.Name LIKE '[A-D]%'
ORDER BY ArtistName, AlbumTitle

--3
SELECT
	A.Name AS ArtistName,
	T.Name AS TrackName
FROM Artist AS A
JOIN Album AS AL
	ON A.ArtistId = AL.ArtistId
JOIN Track AS T
	ON T.AlbumId = AL.AlbumId
JOIN Genre AS G
	ON T.GenreId = G.GenreId
WHERE G.Name = 'Alternative'
ORDER BY ArtistName, TrackName

--4 (Not Sure if Correct)
SELECT
	E.FirstName,
	SJ.LastName
FROM Employee E
CROSS JOIN Employee SJ
ORDER BY E.FirstName

--5
SELECT
	P.Name AS PlaylistName,
	A.Name AS ArtistName,
	AL.Title AS AlbumName,
	T.Name AS TrackName,
	G.Name AS GenreName
From Artist A
JOIN Album AL
	ON A.ArtistId = AL.ArtistId
JOIN Track T
	ON T.AlbumId = AL.AlbumId
JOIN Genre G
	ON G.GenreId = T.GenreId
JOIN PlaylistTrack PT
	ON PT.TrackId = T.TrackId
JOIN Playlist P
	ON P.PlaylistId = PT.PlaylistId
WHERE P.Name = 'Grunge'

--6
SELECT
	A.Title AS AlbumName,
	T.Name AS TrackName,
	T.Milliseconds,
	T.Milliseconds/1000 AS Seconds
FROM Album A
JOIN Track T
	ON T.AlbumId = A.AlbumId
WHERE A.Title = 'Let There Be Rock'

--7
SELECT
	CONCAT(E.FirstName,' ',E.LastName) AS CustomerRep,
	CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
	C.Country
FROM Customer C
JOIN Employee E
	ON E.EmployeeId = C.SupportRepId
ORDER BY CustomerRep, C.Country

--8 (not sure if you wanted both orders in descending order)
SELECT
	A.Title AS AlbumTitle,
	T.Name AS TrackName,
	I.InvoiceId
FROM Album A
JOIN Track T
	ON T.AlbumId = A.AlbumId
FULL JOIN InvoiceLine I
	ON I.TrackId = T.TrackId
ORDER BY TrackName DESC, I.InvoiceId DESC

--9
SELECT
	E.EmployeeId,
	E.LastName,
	E.FirstName,
	E.ReportsTo,
	IIF(E.ReportsTo IS NULL, 'N/A', CONCAT(SJ.FirstName,' ',SJ.LastName)) AS ManagerName
FROM Employee E
LEFT JOIN Employee SJ
	ON SJ.EmployeeId = E.ReportsTo

--10
SELECT
	C.LastName,
	A.Title AS AlbumTitle,
	T.Name AS TrackName,
	Convert(varchar, I.InvoiceDate, 103) AS PurchaseDate
FROM Album A
JOIN Track T
	ON T.AlbumId = A.AlbumId
JOIN InvoiceLine IL
	ON IL.TrackId = T.TrackId
JOIN Invoice I
	ON I.InvoiceId = IL.InvoiceId
JOIN Customer C
	ON C.CustomerId = I.CustomerId
WHERE C.FirstName = 'Julia'
	AND C.LastName = 'Barnett'
ORDER BY I.InvoiceDate, AlbumTitle, TrackName