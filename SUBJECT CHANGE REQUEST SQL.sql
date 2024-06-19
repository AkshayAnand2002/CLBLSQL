CREATE TABLE SubjectAllotments(
   StudentID VARCHAR(50),
   SubjectID VARCHAR(50),
   Is_valid	 BIT
);
SELECT * FROM SubjectAllotments;
TRUNCATE TABLE SubjectAllotments;
CREATE TABLE SubjectRequest(
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50)
);
INSERT INTO SubjectRequest VALUES('159103036', 'PO1491');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1492');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1493');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1494');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1495');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1496');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1497');
INSERT INTO SubjectRequest VALUES('159103036', 'PO1498');
SELECT * FROM SubjectRequest;
TRUNCATE TABLE SubjectRequest;
CREATE PROCEDURE UpdateSubjectAllotment
AS
BEGIN
    UPDATE SubjectAllotments
    SET Is_valid = 0
    FROM SubjectAllotments SA
    JOIN SubjectRequest SR ON SA.StudentID = SR.StudentID
    WHERE SA.Is_valid = 1;

    INSERT INTO SubjectAllotments
    SELECT SR.StudentID, SR.SubjectID, 1
    FROM SubjectRequest SR
    LEFT JOIN SubjectAllotments SA 
    ON SR.StudentID = SA.StudentID 
    AND SR.SubjectID = SA.SubjectID
    WHERE SA.StudentID IS NULL 
    OR (SA.StudentID IS NOT NULL AND SA.SubjectID <> SR.SubjectID);
END;
EXEC UpdateSubjectAllotment;
DROP PROCEDURE UpdateSubjectAllotment;