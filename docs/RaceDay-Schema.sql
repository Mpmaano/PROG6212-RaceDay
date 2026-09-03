-- RaceDay Database Schema
-- PROG6212 Part 1
-- Compatible with SQL Server (SSMS)

USE master;
GO

IF DB_ID('RaceDayDB') IS NOT NULL
    DROP DATABASE RaceDayDB;
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

-- 1. Users (Organisers + Participants)
CREATE TABLE Users (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    FirstName       NVARCHAR(80)  NOT NULL,
    LastName        NVARCHAR(80)  NOT NULL,
    Role            NVARCHAR(20)  NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    Phone           NVARCHAR(20)  NULL,
    CreatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 2. Events
CREATE TABLE Events (
    EventId         INT IDENTITY(1,1) PRIMARY KEY,
    Title           NVARCHAR(200) NOT NULL,
    Description     NVARCHAR(MAX) NULL,
    EventDate       DATETIME2     NOT NULL,
    Location        NVARCHAR(200) NOT NULL,
    Province        NVARCHAR(50)  NOT NULL,
    Status          NVARCHAR(20)  NOT NULL DEFAULT 'Draft' 
                    CHECK (Status IN ('Draft', 'Published', 'Completed', 'Cancelled')),
    OrganiserId     INT           NOT NULL,
    CreatedAt       DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId) REFERENCES Users(UserId)
);
GO

-- 3. Categories
CREATE TABLE Categories (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    EventId         INT           NOT NULL,
    Name            NVARCHAR(100) NOT NULL,
    DistanceKm      DECIMAL(6,2)  NOT NULL,
    MaxEntries      INT           NULL,
    EntryFee        DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE
);
GO

-- 4. Enrolments
CREATE TABLE Enrolments (
    EnrolmentId     INT IDENTITY(1,1) PRIMARY KEY,
    UserId          INT           NOT NULL,
    CategoryId      INT           NOT NULL,
    EnrolmentDate   DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    Status          NVARCHAR(20)  NOT NULL DEFAULT 'Registered'
                    CHECK (Status IN ('Registered', 'Cancelled', 'Completed')),
    CONSTRAINT FK_Enrolments_User     FOREIGN KEY (UserId)     REFERENCES Users(UserId),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId),
    CONSTRAINT UQ_Enrolment_User_Category UNIQUE (UserId, CategoryId)
);
GO

-- 5. Results
CREATE TABLE Results (
    ResultId        INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId     INT           NOT NULL UNIQUE,
    FinishTime      TIME          NULL,
    Position        INT           NULL,
    ChipTime        TIME          NULL,
    RecordedAt      DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    RecordedBy      INT           NOT NULL,
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolments(EnrolmentId),
    CONSTRAINT FK_Results_RecordedBy FOREIGN KEY (RecordedBy) REFERENCES Users(UserId)
);
GO

-- 6. EventImages
CREATE TABLE EventImages (
    ImageId         INT IDENTITY(1,1) PRIMARY KEY,
    EventId         INT           NOT NULL,
    ImageUrl        NVARCHAR(500) NOT NULL,
    Caption         NVARCHAR(200) NULL,
    UploadedAt      DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_EventImages_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE
);
GO

-- =====================
-- SAMPLE DATA
-- =====================

-- 2 Organisers + 2 Participants
INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Role, Phone) VALUES
('thabo.organiser@raceday.co.za', 'HASHED_PASSWORD_1', 'Thabo', 'Molefe', 'Organiser', '0821112233'),
('lerato.events@raceday.co.za',   'HASHED_PASSWORD_2', 'Lerato', 'Nkosi',  'Organiser', '0834445566'),
('sipho.runner@gmail.com',        'HASHED_PASSWORD_3', 'Sipho',  'Dlamini','Participant','0712223344'),
('nomsa.walker@gmail.com',        'HASHED_PASSWORD_4', 'Nomsa',  'Khumalo','Participant','0725556677');
GO

-- 3 Events
INSERT INTO Events (Title, Description, EventDate, Location, Province, Status, OrganiserId) VALUES
('Soweto Marathon 2026', 'Iconic 42.2 km through the streets of Soweto', '2026-11-01 06:00:00', 'FNB Stadium, Johannesburg', 'Gauteng', 'Published', 1),
('Cape Town Cycle Tour Fun Ride', 'Community 40 km cycle around the Cape Peninsula', '2026-03-15 07:00:00', 'Cape Town City Centre', 'Western Cape', 'Published', 2),
('Durban Beachfront 10 km Park Run', 'Flat coastal 10 km for all levels', '2026-05-10 06:30:00', 'North Beach, Durban', 'KwaZulu-Natal', 'Published', 1);
GO

-- Categories for each event
INSERT INTO Categories (EventId, Name, DistanceKm, MaxEntries, EntryFee) VALUES
(1, '42.2 km Marathon', 42.20, 15000, 450.00),
(1, '21.1 km Half Marathon', 21.10, 8000, 320.00),
(2, '40 km Cycle', 40.00, 5000, 280.00),
(2, '20 km Cycle', 20.00, 3000, 180.00),
(3, '10 km Run', 10.00, 2000, 120.00),
(3, '5 km Walk/Run', 5.00, 1500, 80.00);
GO

-- Sample enrolments
INSERT INTO Enrolments (UserId, CategoryId, Status) VALUES
(3, 1, 'Registered'),
(3, 5, 'Registered'),
(4, 2, 'Registered'),
(4, 6, 'Registered');
GO

-- A couple of results
INSERT INTO Results (EnrolmentId, FinishTime, Position, ChipTime, RecordedBy) VALUES
(1, '03:52:18', 1245, '03:51:45', 1),
(3, '01:48:33', 312,  '01:48:10', 1);
GO

-- Sample images
INSERT INTO EventImages (EventId, ImageUrl, Caption) VALUES
(1, 'https://example.com/images/soweto-start.jpg', 'Start line at FNB Stadium'),
(2, 'https://example.com/images/cape-cycle.jpg', 'Riders on Chapman''s Peak');
GO

PRINT 'RaceDay schema and sample data created successfully.';