/* =========================================================
   Student Registration System - Database Creation Script
   ========================================================= */

IF DB_ID('StudentRegistrationDB') IS NULL
BEGIN
    CREATE DATABASE StudentRegistrationDB;
END
GO

USE StudentRegistrationDB;
GO

/* ---------- Countries ---------- */
IF OBJECT_ID('dbo.Countries') IS NOT NULL DROP TABLE dbo.Countries;
CREATE TABLE dbo.Countries (
    CountryID   INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(100) NOT NULL,
    ISOCode     NVARCHAR(5)   NOT NULL,   -- e.g. IN, US
    DialCode    NVARCHAR(10)  NOT NULL    -- e.g. +91, +1
);
GO

/* ---------- States ---------- */
IF OBJECT_ID('dbo.States') IS NOT NULL DROP TABLE dbo.States;
CREATE TABLE dbo.States (
    StateID    INT IDENTITY(1,1) PRIMARY KEY,
    CountryID  INT NOT NULL FOREIGN KEY REFERENCES dbo.Countries(CountryID),
    StateName  NVARCHAR(100) NOT NULL
);
GO

/* ---------- Districts ---------- */
IF OBJECT_ID('dbo.Districts') IS NOT NULL DROP TABLE dbo.Districts;
CREATE TABLE dbo.Districts (
    DistrictID   INT IDENTITY(1,1) PRIMARY KEY,
    StateID      INT NOT NULL FOREIGN KEY REFERENCES dbo.States(StateID),
    DistrictName NVARCHAR(100) NOT NULL
);
GO

/* ---------- OTP Verification ---------- */
IF OBJECT_ID('dbo.OtpVerification') IS NOT NULL DROP TABLE dbo.OtpVerification;
CREATE TABLE dbo.OtpVerification (
    OtpID         INT IDENTITY(1,1) PRIMARY KEY,
    Email         NVARCHAR(150) NOT NULL,
    OtpCode       NVARCHAR(10)  NOT NULL,
    GeneratedTime DATETIME NOT NULL DEFAULT GETDATE(),
    ExpiryTime    DATETIME NOT NULL,
    IsUsed        BIT NOT NULL DEFAULT 0
);
GO

/* ---------- Students ---------- */
IF OBJECT_ID('dbo.Students') IS NOT NULL DROP TABLE dbo.Students;
CREATE TABLE dbo.Students (
    StudentID        NVARCHAR(20) PRIMARY KEY,      -- Auto-generated e.g. STU00001
    FullName         NVARCHAR(150) NOT NULL,
    Email            NVARCHAR(150) NOT NULL,
    MobileNumber     NVARCHAR(20)  NOT NULL,
    CountryID        INT NOT NULL FOREIGN KEY REFERENCES dbo.Countries(CountryID),
    StateID          INT NOT NULL FOREIGN KEY REFERENCES dbo.States(StateID),
    DistrictID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Districts(DistrictID),
    Address          NVARCHAR(300),
    Gender           NVARCHAR(10),
    DateOfBirth      DATE,
    ProfilePhotoPath NVARCHAR(300),
    Course           NVARCHAR(100),
    Semester         NVARCHAR(20),
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsEmailVerified  BIT NOT NULL DEFAULT 0
);
GO

/* Helper sequence-style table to make StudentID generation easy & safe
   under concurrent inserts. */
IF OBJECT_ID('dbo.StudentIdCounter') IS NOT NULL DROP TABLE dbo.StudentIdCounter;
CREATE TABLE dbo.StudentIdCounter (
    LastValue INT NOT NULL
);
INSERT INTO dbo.StudentIdCounter (LastValue) VALUES (0);
GO

/* Stored procedure: generates the next Student ID like STU00001 */
IF OBJECT_ID('dbo.usp_GetNextStudentId') IS NOT NULL DROP PROCEDURE dbo.usp_GetNextStudentId;
GO
CREATE PROCEDURE dbo.usp_GetNextStudentId
    @NextId NVARCHAR(20) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewVal INT;

    UPDATE dbo.StudentIdCounter
        SET @NewVal = LastValue = LastValue + 1;

    SET @NextId = 'STU' + RIGHT('00000' + CAST(@NewVal AS VARCHAR(10)), 5);
END
GO
