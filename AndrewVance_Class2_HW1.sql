--Andrew Vance

USE master
IF DB_ID('MyDB_AndrewVance') IS NOT NULL
BEGIN
	ALTER DATABASE MyDB_AndrewVance SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE MyDB_AndrewVance SET ONLINE;
	DROP DATABASE MyDB_AndrewVance;
END