/* =========================================================
   Sample Data: Countries / States / Districts + 50 Students
   ========================================================= */
USE StudentRegistrationDB;
GO

/* ---------- Countries ---------- */
INSERT INTO dbo.Countries (CountryName, ISOCode, DialCode) VALUES
('India', 'IN', '+91'),
('United States', 'US', '+1'),
('United Kingdom', 'GB', '+44'),
('Australia', 'AU', '+61'),
('Canada', 'CA', '+1');
GO

/* ---------- States (India) ---------- */
DECLARE @IndiaId INT = (SELECT CountryID FROM dbo.Countries WHERE ISOCode = 'IN');
INSERT INTO dbo.States (CountryID, StateName) VALUES
(@IndiaId, 'Maharashtra'),
(@IndiaId, 'Karnataka'),
(@IndiaId, 'Tamil Nadu'),
(@IndiaId, 'Delhi'),
(@IndiaId, 'Gujarat');

/* ---------- States (US) ---------- */
DECLARE @USId INT = (SELECT CountryID FROM dbo.Countries WHERE ISOCode = 'US');
INSERT INTO dbo.States (CountryID, StateName) VALUES
(@USId, 'California'),
(@USId, 'Texas'),
(@USId, 'New York');

/* ---------- States (UK) ---------- */
DECLARE @UKId INT = (SELECT CountryID FROM dbo.Countries WHERE ISOCode = 'GB');
INSERT INTO dbo.States (CountryID, StateName) VALUES
(@UKId, 'England'),
(@UKId, 'Scotland');

/* ---------- States (Australia) ---------- */
DECLARE @AUId INT = (SELECT CountryID FROM dbo.Countries WHERE ISOCode = 'AU');
INSERT INTO dbo.States (CountryID, StateName) VALUES
(@AUId, 'New South Wales'),
(@AUId, 'Victoria');

/* ---------- States (Canada) ---------- */
DECLARE @CAId INT = (SELECT CountryID FROM dbo.Countries WHERE ISOCode = 'CA');
INSERT INTO dbo.States (CountryID, StateName) VALUES
(@CAId, 'Ontario'),
(@CAId, 'Quebec');
GO

/* ---------- Districts ---------- */
DECLARE @Maharashtra INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Maharashtra');
DECLARE @Karnataka   INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Karnataka');
DECLARE @TamilNadu   INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Tamil Nadu');
DECLARE @Delhi       INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Delhi');
DECLARE @Gujarat     INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Gujarat');

INSERT INTO dbo.Districts (StateID, DistrictName) VALUES
(@Maharashtra, 'Pune'),
(@Maharashtra, 'Mumbai'),
(@Maharashtra, 'Nagpur'),
(@Karnataka, 'Bengaluru'),
(@Karnataka, 'Mysuru'),
(@TamilNadu, 'Chennai'),
(@TamilNadu, 'Coimbatore'),
(@Delhi, 'New Delhi'),
(@Gujarat, 'Ahmedabad'),
(@Gujarat, 'Surat');

DECLARE @California INT = (SELECT StateID FROM dbo.States WHERE StateName = 'California');
DECLARE @Texas       INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Texas');
DECLARE @NewYork     INT = (SELECT StateID FROM dbo.States WHERE StateName = 'New York');
INSERT INTO dbo.Districts (StateID, DistrictName) VALUES
(@California, 'Los Angeles'),
(@California, 'San Francisco'),
(@Texas, 'Houston'),
(@NewYork, 'New York City');

DECLARE @England  INT = (SELECT StateID FROM dbo.States WHERE StateName = 'England');
DECLARE @Scotland INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Scotland');
INSERT INTO dbo.Districts (StateID, DistrictName) VALUES
(@England, 'London'),
(@England, 'Manchester'),
(@Scotland, 'Edinburgh');

DECLARE @NSW INT = (SELECT StateID FROM dbo.States WHERE StateName = 'New South Wales');
DECLARE @VIC INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Victoria');
INSERT INTO dbo.Districts (StateID, DistrictName) VALUES
(@NSW, 'Sydney'),
(@VIC, 'Melbourne');

DECLARE @Ontario INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Ontario');
DECLARE @Quebec  INT = (SELECT StateID FROM dbo.States WHERE StateName = 'Quebec');
INSERT INTO dbo.Districts (StateID, DistrictName) VALUES
(@Ontario, 'Toronto'),
(@Quebec, 'Montreal');
GO

/* =========================================================
   50 Sample Student Records (randomly distributed across
   the locations above). All marked as email-verified since
   they represent completed test registrations.
   ========================================================= */
DECLARE @i INT = 1;
DECLARE @NewId NVARCHAR(20);
DECLARE @DistrictCount INT = (SELECT COUNT(*) FROM dbo.Districts);
DECLARE @FirstNames TABLE (Id INT IDENTITY(1,1), Name NVARCHAR(50));
DECLARE @LastNames  TABLE (Id INT IDENTITY(1,1), Name NVARCHAR(50));

INSERT INTO @FirstNames (Name) VALUES
('Aarav'),('Vivaan'),('Aditya'),('Ishaan'),('Sai'),('Ananya'),('Diya'),('Myra'),
('Kabir'),('Reyansh'),('Emma'),('Olivia'),('Liam'),('Noah'),('Ava'),('Sophia'),
('James'),('Charlotte'),('Amelia'),('Ethan'),('Priya'),('Rahul'),('Sneha'),
('Arjun'),('Neha');

INSERT INTO @LastNames (Name) VALUES
('Sharma'),('Verma'),('Patel'),('Iyer'),('Nair'),('Reddy'),('Gupta'),('Khan'),
('Smith'),('Johnson'),('Brown'),('Taylor'),('Wilson'),('Anderson'),('Clark'),
('Kapoor'),('Mehta'),('Rao'),('Singh'),('Joshi');

WHILE @i <= 50
BEGIN
    EXEC dbo.usp_GetNextStudentId @NewId OUTPUT;

    DECLARE @DistrictId INT = (SELECT DistrictID FROM (
        SELECT DistrictID, ROW_NUMBER() OVER (ORDER BY DistrictID) rn FROM dbo.Districts
    ) t WHERE rn = ((@i - 1) % @DistrictCount) + 1);

    DECLARE @StateId INT = (SELECT StateID FROM dbo.Districts WHERE DistrictID = @DistrictId);
    DECLARE @CountryId INT = (SELECT CountryID FROM dbo.States WHERE StateID = @StateId);

    DECLARE @FName NVARCHAR(50) = (SELECT Name FROM @FirstNames WHERE Id = ((@i - 1) % 25) + 1);
    DECLARE @LName NVARCHAR(50) = (SELECT Name FROM @LastNames WHERE Id = ((@i - 1) % 20) + 1);
    DECLARE @FullName NVARCHAR(150) = @FName + ' ' + @LName;
    DECLARE @Email NVARCHAR(150) = LOWER(@FName + '.' + @LName + CAST(@i AS VARCHAR(5)) + '@example.com');
    DECLARE @Mobile NVARCHAR(20) = '9' + RIGHT('000000000' + CAST(1000000000 + (@i * 37) AS VARCHAR(15)), 9);
    DECLARE @Gender NVARCHAR(10) = CASE WHEN @i % 2 = 0 THEN 'Female' ELSE 'Male' END;
    DECLARE @DOB DATE = DATEADD(YEAR, -(18 + (@i % 6)), DATEADD(DAY, @i, '2000-01-01'));
    DECLARE @Course NVARCHAR(100) = CASE (@i % 5)
        WHEN 0 THEN 'B.Sc. Computer Science'
        WHEN 1 THEN 'B.Tech Information Technology'
        WHEN 2 THEN 'BCA'
        WHEN 3 THEN 'MCA'
        ELSE 'B.Com' END;
    DECLARE @Semester NVARCHAR(20) = 'Semester ' + CAST(((@i % 8) + 1) AS VARCHAR(2));

    INSERT INTO dbo.Students
        (StudentID, FullName, Email, MobileNumber, CountryID, StateID, DistrictID,
         Address, Gender, DateOfBirth, ProfilePhotoPath, Course, Semester,
         RegistrationDate, IsEmailVerified)
    VALUES
        (@NewId, @FullName, @Email, @Mobile, @CountryId, @StateId, @DistrictId,
         CAST(@i AS VARCHAR(5)) + ' Sample Street', @Gender, @DOB,
         '~/Uploads/Students/default-avatar.png', @Course, @Semester,
         DATEADD(DAY, -@i, GETDATE()), 1);

    SET @i += 1;
END
GO

SELECT COUNT(*) AS TotalStudents FROM dbo.Students;
GO
