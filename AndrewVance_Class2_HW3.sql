--Andrew Vance

--1
WITH AA AS
(
SELECT 
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	A.ArtistId,
	AL.AlbumId
FROM Artist A
JOIN Album AL
	ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'AudioSlave'
)
SELECT
	AA.ArtistName,
	AA.AlbumTitle,
	T.Name AS TrackName
FROM AA
JOIN Track T
	ON T.AlbumId = AA.AlbumId

--2
SELECT
	AA.ArtistName,
	AA.AlbumTitle,
	T.Name AS TrackName
FROM
(
	SELECT
		A.ArtistId,
		A.Name AS ArtistName,
		AL.AlbumID,
		AL.Title AS AlbumTitle
	FROM Artist A
	JOIN Album AL
		ON AL.ArtistId = A.ArtistId
	WHERE A.Name = 'Kiss'
) AS AA
JOIN Track T
	On T.AlbumId = AA.AlbumId

--3
WITH CUST AS
(
SELECT
	CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
	SUM(I.Total) AS SumTotal,
	C.SupportRepId
FROM Customer C
JOIN Invoice I
	ON I.CustomerId = C.CustomerId
GROUP BY
	CONCAT(C.FirstName,' ',C.LastName),
	C.SupportRepId
)
SELECT
	E.LastName AS SupportRep,
	CUST.CustomerName,
	CUST.SumTotal
FROM CUST
JOIN Employee E
	ON E.EmployeeId = CUST.SupportRepId
ORDER BY SumTotal DESC, LastName

--4
SELECT
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	(
		SELECT COUNT(*)
		FROM Track T
		WHERE T.AlbumId = AL.AlbumId
		) AS TrackCount
FROM Artist A
JOIN Album AL
	ON AL.ArtistId = A.ArtistId
WHERE A.Name = 'Iron Maiden'
ORDER BY TrackCount

--5
WITH TC AS
(
SELECT 
	COUNT(*) AS TrackCount,
	AlbumId
FROM Track
GROUP BY AlbumId
)
SELECT
	A.Name AS ArtistName,
	AL.Title AS AlbumTitle,
	TC.TrackCount
FROM TC
JOIN Album AL
	ON TC.AlbumId = AL.AlbumId
JOIN Artist A
	ON A.ArtistId = AL.ArtistId
WHERE A.Name = 'U2'
ORDER BY TrackCount

--6
WITH BirthDate AS
(
SELECT
	CONCAT(FirstName,' ',LastName) AS FullName,
	BirthDate,
	DATEFROMPARTS(2021,MONTH(BirthDate),DAY(BirthDate)) AS BirthDay2021
FROM Employee
),
Celebration AS
(
SELECT
	FullName,
	BirthDate,
	BirthDay2021,
	CASE
		WHEN DATEPART(weekday,BirthDay2021) = 1 THEN DATEADD(DAY,1,BirthDay2021)
		WHEN DATEPART(weekday,BirthDay2021) = 7 THEN DATEADD(DAY,2,BirthDay2021)
		ELSE BirthDay2021
		END AS CelebrationDate
FROM BirthDate
)
SELECT
	FullName,
	CONVERT(varchar,BirthDate,110) AS BirthDate,
	CONVERT(varchar,BirthDay2021,110) AS BirthDay2021,
	DATENAME(weekday,BirthDay2021) AS BirthDayOfWeek2021,
	CONVERT(varchar,CelebrationDate,110) AS CelebrationDate,
	DATENAME(weekday,CelebrationDate) AS CelebrationDayOfWeek
FROM Celebration

--7 PREP
GO
USE master
IF DB_ID('MyDB_av') IS NOT NULL 
BEGIN
	ALTER DATABASE MyDB_av SET OFFLINE WITH ROLLBACK IMMEDIATE; 
	ALTER DATABASE MyDB_av SET ONLINE; 
	DROP DATABASE MyDB_av; 
END
CREATE DATABASE MyDB_av
GO
USE MyDB_av

SELECT *
INTO Staff
FROM Chinook.dbo.Employee

SELECT
	CAST('' AS varchar(20)) AS DMLType
	,sysdatetime() AS DateUpdated
	,SYSTEM_USER AS UpdatedBy
	,*
INTO Staff_log
FROM Chinook.dbo.Employee
WHERE 1=2 

--7
UPDATE Staff
SET Title = 'New General Manager'
OUTPUT
	inserted.EmployeeId,
	deleted.Title AS TitleBefore,
	inserted.Title AS TitleAfter
WHERE EmployeeId = 2

--8
CREATE TRIGGER Staff_trg
	ON Staff
	FOR UPDATE, DELETE
	AS
	INSERT INTO Staff_log
	SELECT 'deleted', SYSDATETIME(), SYSTEM_USER, * FROM deleted
	INSERT INTO Staff_log
	SELECT 'updated', SYSDATETIME(), SYSTEM_USER, * FROM inserted

--9
DELETE Staff
WHERE EmployeeId = 1

--10
UPDATE Staff
SET Title = 'New Sales Manager'
WHERE EmployeeId = 3

--11
SELECT *
FROM Staff

SELECT *
FROM Staff_log

		

