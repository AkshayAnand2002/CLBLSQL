CREATE TABLE StudentDetails (
  StudentId VARCHAR(20) PRIMARY KEY,
  StudentName VARCHAR(100),
  GPA DECIMAL(3, 2),
  Branch VARCHAR(50),
  Section VARCHAR(10)
);
SELECT * FROM StudentDetails;
DROP TABLE StudentDetails;

CREATE TABLE SubjectDetails (
  SubjectId VARCHAR(20) PRIMARY KEY,
  SubjectName VARCHAR(100),
  MaxSeats INT,
  RemainingSeats INT
);
SELECT * FROM SubjectDetails;
DROP TABLE SubjectDetails;
CREATE TABLE StudentPreference (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Preference INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    UNIQUE (StudentId, Preference)
);
DROP TABLE StudentPreference;
CREATE TABLE Allotments (
   SubjectId VARCHAR(20),
   StudentId VARCHAR(20),
   FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId),
   FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
   PRIMARY KEY (SubjectId, StudentId)
);
SELECT * FROM Allotments;
DROP TABLE Allotments;
TRUNCATE TABLE Allotments;
CREATE TABLE UnallotedStudents(
   StudentId VARCHAR(20) PRIMARY KEY,
   FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);
SELECT * FROM UnallotedStudents;
DROP TABLE UnallotedStudents;
TRUNCATE TABLE UnallotedStudents;
ALTER TABLE StudentPreference NOCHECK CONSTRAINT ALL;

INSERT INTO StudentDetails(StudentId, StudentName, GPA, Branch, Section) VALUES
('159103036', 'Mohit Agarwal', 8.9, 'CCE', 'A'), ('159103037', 'Rohit Agarwal', 5.2, 'CCE', 'A'),
('159103038', 'Shohit Garg', 7.1, 'CCE', 'B'), ('159103039', 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
('159103040', 'Mehreet Singh', 5.6, 'CCE', 'A'),('159103041', 'Arjun Tehlan', 9.2, 'CCE', 'B');
SELECT * FROM StudentDetails;

INSERT INTO SubjectDetails(SubjectId, SubjectName, MaxSeats, RemainingSeats) VALUES
('PO1491', 'Basics of Political Science', 60, 2), ('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90), ('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);
SELECT * FROM SubjectDetails;

INSERT INTO StudentPreference (StudentId, SubjectId, Preference) VALUES
('159103036', 'PO1491', 1),('159103036', 'PO1492', 2),('159103036', 'PO1493', 3),
('159103036', 'PO1494', 4),('159103036', 'PO1495', 5),
('159103037', 'PO1493', 1),('159103037', 'PO1494', 2),('159103037', 'PO1495', 3),
('159103037', 'PO1491', 4),('159103037', 'PO1492', 5),
('159103038', 'PO1492', 1),('159103038', 'PO1493', 2),('159103038', 'PO1494', 3),
('159103038', 'PO1495', 4),('159103038', 'PO1491', 5),
('159103039', 'PO1491', 1),('159103039', 'PO1492', 2),('159103039', 'PO1493', 3),
('159103039', 'PO1494', 4),('159103039', 'PO1495', 5),
('159103040', 'PO1494', 1),('159103040', 'PO1495', 2),('159103040', 'PO1491', 3),
('159103040', 'PO1492', 4),('159103040', 'PO1493', 5),
('159103041', 'PO1491', 1),('159103041', 'PO1493', 2),('159103041', 'PO1494', 3),
('159103041', 'PO1495', 4),('159103041', 'PO1492', 5);
SELECT * FROM StudentPreference;

ALTER TABLE StudentPreference CHECK CONSTRAINT ALL;

CREATE PROCEDURE AllocateOpenElectives
AS
BEGIN
    CREATE TABLE #TempStudentPreferences (
        RowNumber INT IDENTITY(1,1),
        StudentId VARCHAR(20),
        SubjectId VARCHAR(20),
        Preference INT,
        GPA DECIMAL(3, 2),
        PRIMARY KEY (RowNumber)
    );

    INSERT INTO #TempStudentPreferences (StudentId, SubjectId, Preference, GPA)
    SELECT sp.StudentId, sp.SubjectId, sp.Preference, sd.GPA
    FROM StudentPreference sp
    JOIN StudentDetails sd ON sp.StudentId = sd.StudentId
    ORDER BY sd.GPA DESC, sp.Preference ASC;

    DECLARE @Counter INT = 1;

    WHILE EXISTS (SELECT * FROM #TempStudentPreferences WHERE RowNumber = @Counter)
    BEGIN
        DECLARE @StudentId VARCHAR(20);
        DECLARE @SubjectId VARCHAR(20);
        DECLARE @Preference INT;
        DECLARE @RemainingSeats INT;

        SELECT @StudentId = StudentId, @SubjectId = SubjectId, @Preference = Preference
        FROM #TempStudentPreferences
        WHERE RowNumber = @Counter;

        SELECT @RemainingSeats = RemainingSeats
        FROM SubjectDetails
        WHERE SubjectId = @SubjectId;

        IF @RemainingSeats > 0
        BEGIN
            INSERT INTO Allotments (SubjectId, StudentId) VALUES (@SubjectId, @StudentId);

            UPDATE SubjectDetails
            SET RemainingSeats = RemainingSeats - 1
            WHERE SubjectId = @SubjectId;
        END

        SET @Counter = @Counter + 1;
    END;

    INSERT INTO UnallotedStudents (StudentId)
    SELECT StudentId
    FROM #TempStudentPreferences
    WHERE StudentId NOT IN (SELECT DISTINCT StudentId FROM Allotments);

    DROP TABLE #TempStudentPreferences;
END;


EXEC AllocateOpenElectives;
DROP PROCEDURE AllocateOpenElectives;
