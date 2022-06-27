USE [master]
GO
/****** Object:  Database [LSP_AGV]    Script Date: 3/10/2021 20:46:59 ******/
CREATE DATABASE [LSP_AGV]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LSP_AGV', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\LSP_AGV.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LSP_AGV_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\LSP_AGV_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [LSP_AGV] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LSP_AGV].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LSP_AGV] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LSP_AGV] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LSP_AGV] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LSP_AGV] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LSP_AGV] SET ARITHABORT OFF 
GO
ALTER DATABASE [LSP_AGV] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [LSP_AGV] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LSP_AGV] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LSP_AGV] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LSP_AGV] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LSP_AGV] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LSP_AGV] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LSP_AGV] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LSP_AGV] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LSP_AGV] SET  ENABLE_BROKER 
GO
ALTER DATABASE [LSP_AGV] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LSP_AGV] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LSP_AGV] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LSP_AGV] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LSP_AGV] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LSP_AGV] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LSP_AGV] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LSP_AGV] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [LSP_AGV] SET  MULTI_USER 
GO
ALTER DATABASE [LSP_AGV] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LSP_AGV] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LSP_AGV] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LSP_AGV] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LSP_AGV] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LSP_AGV] SET QUERY_STORE = OFF
GO
USE [LSP_AGV]
GO
/****** Object:  Table [dbo].[Classlist]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classlist](
	[ClassListID] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[Grade] [varchar](2) NULL,
	[EnrollmentStatus] [varchar](2) NULL,
	[TuitionAmount] [money] NULL,
 CONSTRAINT [PK_ClassList] PRIMARY KEY CLUSTERED 
(
	[ClassListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [varchar](15) NULL,
	[CourseTitle] [varchar](75) NULL,
	[TotalWeeks] [int] NULL,
	[TotalHours] [numeric](5, 1) NULL,
	[FullCourseFee] [int] NULL,
	[CourseDescription] [varchar](500) NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Section]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [int] IDENTITY(10000,1) NOT NULL,
	[CourseID] [int] NOT NULL,
	[TermID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Days] [varchar](10) NULL,
	[SectionStatus] [varchar](50) NULL,
	[RoomID] [int] NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CourseRevenue_V]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CourseRevenue_V] AS 
SELECT
	C.CourseCode,
	C.CourseTitle,
	COUNT(DISTINCT S.SectionID) AS SectionCount,
	SUM(CL.TuitionAmount) AS TotalRevenue,
	CAST(SUM(CL.TuitionAmount)/CAST(COUNT(DISTINCT S.SectionID) AS numeric) AS numeric(9,2)) AS AverageRevenue
FROM Course C
LEFT JOIN Section S
	ON S. CourseID = C.CourseID AND S.SectionStatus != 'CN'
LEFT JOIN Classlist CL
	ON CL.SectionID = S.SectionID

GROUP BY C.CourseCode, C.CourseTitle


GO
/****** Object:  Table [dbo].[Payments]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentsID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyID] [int] NULL,
	[SectionID] [int] NULL,
	[PrimaryInstructor] [varchar](50) NOT NULL,
	[PaymentAmount] [numeric](9, 2) NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Term]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Term](
	[TermID] [int] IDENTITY(1,1) NOT NULL,
	[TermCode] [char](4) NULL,
	[TermName] [varchar](30) NULL,
	[CalendarYear] [int] NULL,
	[AcademicYear] [int] NULL,
 CONSTRAINT [PK_Term] PRIMARY KEY CLUSTERED 
(
	[TermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AnnualRevenue_v]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AnnualRevenue_v] AS
WITH CTE AS
(
SELECT
	S.SectionID,
	SUM(CL.TuitionAmount) AS TotalTuition
FROM Section S
JOIN ClassList CL
	ON CL.SectionID = S.SectionID
GROUP BY S.SectionID
)
SELECT
	T.AcademicYear,
	SUM(CTE.TotalTuition) AS TotalTuition,
	SUM(P.PaymentAmount) AS TotalFacultyPayments
FROM Course C
JOIN Section S
	ON S.CourseID = C.CourseID
JOIN Term T
	ON T.TermID = S.TermID
LEFT JOIN Payments P
	ON P.SectionID = S.SectionID
LEFT JOIN CTE
	ON CTE.SectionID = S.SectionID
GROUP BY T.AcademicYear


GO
/****** Object:  Table [dbo].[Address]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[AddressType] [varchar](4) NULL,
	[AddressLine] [varchar](50) NOT NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](10) NULL,
	[Country] [varchar](30) NULL,
	[PostalCode] [varchar](15) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faculty]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[FacultyID] [int] IDENTITY(1,1) NOT NULL,
	[FacultyFirstName] [varchar](40) NULL,
	[FacultyLastName] [varchar](50) NULL,
	[FacultyEmail] [varchar](150) NULL,
	[PrimaryPhone] [varchar](20) NULL,
	[AlternatePhone] [varchar](20) NULL,
	[FacultyAddressLine] [varchar](75) NULL,
	[FacultyCity] [varchar](30) NULL,
	[FacultyState] [char](2) NULL,
	[FacultyPostalCode] [char](5) NULL,
 CONSTRAINT [PK_Faculty] PRIMARY KEY CLUSTERED 
(
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[Gender] [char](1) NULL,
	[Phone] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomName] [varchar](30) NULL,
	[Capacity] [int] NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_Person]
GO
ALTER TABLE [dbo].[Classlist]  WITH CHECK ADD  CONSTRAINT [FK_Classlist_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Classlist] CHECK CONSTRAINT [FK_Classlist_Person]
GO
ALTER TABLE [dbo].[Classlist]  WITH CHECK ADD  CONSTRAINT [FK_ClassList_Section] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Classlist] CHECK CONSTRAINT [FK_ClassList_Section]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Faculty]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Section] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Section]
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Section] CHECK CONSTRAINT [FK_Section_Course]
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_Room] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Section] CHECK CONSTRAINT [FK_Section_Room]
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_term] FOREIGN KEY([TermID])
REFERENCES [dbo].[Term] ([TermID])
GO
ALTER TABLE [dbo].[Section] CHECK CONSTRAINT [FK_Section_term]
GO
/****** Object:  StoredProcedure [dbo].[InsertPerson_p]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertPerson_p]
	@FirstName varchar(35),
	@LastName varchar(50),
	@AddressType varchar(10),
	@AddressLine varchar(50),
	@City varchar(25)
AS
CREATE TABLE #Person(PersonID int)
INSERT INTO Person
(FirstName, LastName)
OUTPUT inserted.PersonID INTO #Person
VALUES (@FirstName, @LastName)

INSERT INTO Address
(AddressType, AddressLine, City, PersonID)
SELECT
	@AddressType,
	@AddressLine,
	@City,
	#Person.PersonID
FROM #Person


GO
/****** Object:  StoredProcedure [dbo].[StudentHistory_p]    Script Date: 3/10/2021 20:46:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[StudentHistory_p] @PersonID int AS
SELECT
	CONCAT(P.FirstName,' ',P.LastName) AS StudentName,
	S.SectionID,
	C.CourseCode,
	C.CourseTitle,
	CONCAT(F.FacultyFirstName,' ',F.FacultyLastName) AS FacultyName,
	T.TermCode,
	S.StartDate,
	CL.TuitionAmount,
	CL.Grade
FROM Person P
JOIN Classlist CL
	ON CL.PersonID = P.PersonID
JOIN Section S
	ON S.SectionID = CL.SectionID
JOIN Term T
	ON T.TermID = S.TermID
JOIN Course C
	ON C.CourseID = S.CourseID
JOIN Payments Pay
	ON Pay.SectionID = S.SectionID AND PAY.PrimaryInstructor = 'Y'
JOIN Faculty F
	ON F.FacultyID = Pay.FacultyID
WHERE P.PersonID = @PersonID
ORDER BY StartDate


GO
USE [master]
GO
ALTER DATABASE [LSP_AGV] SET  READ_WRITE 
GO
