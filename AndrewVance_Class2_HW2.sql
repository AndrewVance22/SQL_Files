--Andrew Vance

USE Chinook
IF OBJECT_ID('Track_v_av') IS NOT NULL DROP VIEW Track_v_av
IF OBJECT_ID('ArtistAlbum_fn_av') IS NOT NULL DROP FUNCTION ArtistAlbum_fn_av
IF OBJECT_ID('TracksByArtist_p_av') IS NOT NULL DROP PROC TracksByArtist_p_av

--1
CREATE VIEW Track_v_av AS
SELECT
	T.*,
	G.Name AS GenreName,
	M.Name AS MediaTypeName
FROM Track T
JOIN Genre G
	ON G.GenreId = T.GenreId
JOIN MediaType M
	ON M.MediaTypeId = T.MediaTypeId

--2
CREATE FUNCTION ArtistAlbum_fn_av (@TrackId int)
RETURNS varchar(100)
AS
BEGIN
DECLARE @ArtistAlbum varchar(100)
SELECT
	@ArtistAlbum = CONCAT(AR.Name,'-',AL.Title)
FROM Track T
JOIN Album AL
	ON AL.AlbumId = T.AlbumId
JOIN Artist AR
	ON AR.ArtistId = AL.ArtistId
WHERE T.TrackId = @TrackId
RETURN
	@ArtistAlbum
END

--3
CREATE PROC TracksByArtist_p_av
	@ArtistName varchar(100) AS
SELECT
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	T.Name AS TrackName
FROM Artist A
LEFT JOIN Album AL
	ON A.ArtistId = AL.ArtistId
LEFT JOIN Track T
	ON AL.AlbumId = T.AlbumId
WHERE A.Name Like CONCAT('%',@ArtistName,'%')
GO

--4
SELECT
	AL.Title AS AlbumTitle,
	T.Name,
	T.GenreName,
	T.MediaTypeName
FROM Track_v_av T
JOIN Album AL
	ON T.AlbumId = AL.AlbumId
WHERE T.Name = 'Babylon'

--5
SELECT
	dbo.ArtistAlbum_fn_av(TrackId) AS [Artist and Album],
	Name AS TrackName
FROM Track_v_av
WHERE GenreName = 'Opera'

--6
EXEC TracksByArtist_p_av 'black'
EXEC TracksByArtist_p_av 'white'

--7
ALTER PROC TracksByArtist_p_av
	@ArtistName varchar(100) = 'Scorpions' 
AS
SELECT
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	T.Name AS TrackName
FROM Artist A
LEFT JOIN Album AL
	ON A.ArtistId = AL.ArtistId
LEFT JOIN Track T
	ON AL.AlbumId = T.AlbumId
WHERE A.Name Like CONCAT('%',@ArtistName,'%')
GO

--8
EXEC TracksByArtist_p_av

--9
BEGIN TRANSACTION
UPDATE Employee
SET LastName = 'Vance'
WHERE EmployeeId = 1

--10
SELECT
	EmployeeId,
	LastName
FROM Employee
WHERE EmployeeId = 1

ROLLBACK TRANSACTION

SELECT
	EmployeeId,
	LastName
FROM Employee
WHERE EmployeeId = 1