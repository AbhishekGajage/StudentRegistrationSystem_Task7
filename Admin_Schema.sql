IF COL_LENGTH('Students', 'ApprovalStatus') IS NULL
    ALTER TABLE Students ADD ApprovalStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending';

IF COL_LENGTH('Students', 'AccountStatus') IS NULL
    ALTER TABLE Students ADD AccountStatus NVARCHAR(20) NOT NULL DEFAULT 'Active';

IF COL_LENGTH('Students', 'RejectionRemark') IS NULL
    ALTER TABLE Students ADD RejectionRemark NVARCHAR(500) NULL;

IF COL_LENGTH('Students', 'ApprovedBy') IS NULL
    ALTER TABLE Students ADD ApprovedBy NVARCHAR(100) NULL;

IF COL_LENGTH('Students', 'ApprovedDate') IS NULL
    ALTER TABLE Students ADD ApprovedDate DATETIME NULL;

IF COL_LENGTH('Students', 'RejectedBy') IS NULL
    ALTER TABLE Students ADD RejectedBy NVARCHAR(100) NULL;

IF COL_LENGTH('Students', 'RejectedDate') IS NULL
    ALTER TABLE Students ADD RejectedDate DATETIME NULL;

IF COL_LENGTH('Students', 'CreatedDate') IS NULL
    ALTER TABLE Students ADD CreatedDate DATETIME NULL;

IF COL_LENGTH('Students', 'LastModifiedDate') IS NULL
    ALTER TABLE Students ADD LastModifiedDate DATETIME NULL;

IF COL_LENGTH('Students', 'LastLoginDate') IS NULL
    ALTER TABLE Students ADD LastLoginDate DATETIME NULL;

UPDATE Students SET CreatedDate = RegistrationDate WHERE CreatedDate IS NULL;
UPDATE Students SET LastModifiedDate = RegistrationDate WHERE LastModifiedDate IS NULL;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_Students_StudentID')
    ALTER TABLE Students ADD CONSTRAINT UQ_Students_StudentID UNIQUE (StudentID);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_Students_Email')
    ALTER TABLE Students ADD CONSTRAINT UQ_Students_Email UNIQUE (Email);

IF OBJECT_ID('Admins', 'U') IS NULL
BEGIN
    CREATE TABLE Admins (
        AdminID       INT IDENTITY(1,1) PRIMARY KEY,
        Username      NVARCHAR(50)  NOT NULL UNIQUE,
        PasswordHash  NVARCHAR(255) NOT NULL,
        FullName      NVARCHAR(100) NOT NULL,
        CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM Admins WHERE Username = 'admin')
BEGIN
    INSERT INTO Admins (Username, PasswordHash, FullName)
    VALUES (
        'admin',
        LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'Admin@123'), 2)),
        'System Administrator'
    );
END
GO
