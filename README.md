-- =====================================================
-- Q.1.1  Create the database and tables from the ERD
-- =====================================================

CREATE DATABASE DEBATES;
USE DEBATES;

-- Faculty table
CREATE TABLE Faculty (
    FacultyID   VARCHAR(10)  NOT NULL,
    FacultyName VARCHAR(100) NOT NULL,
    PRIMARY KEY (FacultyID)
);

-- Venue table
CREATE TABLE Venue (
    VenueID      VARCHAR(10)  NOT NULL,
    VenueName    VARCHAR(100) NOT NULL,
    VenueAddress VARCHAR(200) NOT NULL,
    PRIMARY KEY (VenueID)
);

-- Debate table
CREATE TABLE Debate (
    DebateID        VARCHAR(10)  NOT NULL,
    FacultyID_A     VARCHAR(10)  NOT NULL,
    FacultyID_B     VARCHAR(10)  NOT NULL,
    VenueID         VARCHAR(10)  NOT NULL,
    DebateDate      DATE         NOT NULL,
    DebateTime      TIME         NOT NULL,
    DebateDuration  INT          NOT NULL,   -- duration in minutes
    PRIMARY KEY (DebateID),
    CONSTRAINT FK_Debate_FacultyA FOREIGN KEY (FacultyID_A) REFERENCES Faculty(FacultyID),
    CONSTRAINT FK_Debate_FacultyB FOREIGN KEY (FacultyID_B) REFERENCES Faculty(FacultyID),
    CONSTRAINT FK_Debate_Venue    FOREIGN KEY (VenueID)     REFERENCES Venue(VenueID)
);


-- =====================================================
-- Q.1.2  Populate the tables with the given data
-- =====================================================

-- Faculty data
INSERT INTO Faculty (FacultyID, FacultyName) VALUES
('F001', 'Faculty of Science'),
('F002', 'Faculty of Engineering'),
('F003', 'Faculty of Humanities'),
('F004', 'Faculty of Law'),
('F005', 'Faculty of Commerce');

-- Venue data
INSERT INTO Venue (VenueID, VenueName, VenueAddress) VALUES
('V001', 'Newton Hall',       '12 University Road, Cape Town'),
('V002', 'Curie Centre',      '44 Innovation Avenue, Gqeberha'),
('V003', 'Plato Auditorium',  '88 Knowledge Street, Durban'),
('V004', 'Darwin Hall',       '15 Research Lane, Johannesburg'),
('V005', 'Aristotle Theatre', '9 Academic Crescent, Tshwane');

-- Debate data
INSERT INTO Debate (DebateID, FacultyID_A, FacultyID_B, VenueID, DebateDate, DebateTime, DebateDuration) VALUES
('D001', 'F001', 'F002', 'V001', '2026-08-10', '10:00:00', 60),
('D002', 'F003', 'F005', 'V004', '2026-08-11', '14:00:00', 90),
('D003', 'F002', 'F003', 'V005', '2026-08-12', '18:00:00', 90),
('D004', 'F001', 'F005', 'V003', '2026-08-13', '16:00:00', 120),
('D005', 'F002', 'F005', 'V001', '2026-08-14', '17:00:00', 120);


-- =====================================================
-- Q.1.3  Alter the DEBATE table to add a field for
--        the number of seats available
-- =====================================================

ALTER TABLE Debate
ADD SeatsAvailable INT NULL;


-- =====================================================
-- Q.1.4  Update the new field
--        (For DEBATE_ID 'D003' set seats/tickets available to 400)
-- =====================================================

UPDATE Debate
SET SeatsAvailable = 400
WHERE DebateID = 'D003';
