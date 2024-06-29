TRUNCATE TABLE CountTotalWorkInHours;
DROP PROCEDURE dbo.GetTotalHours;
DROP FUNCTION dbo.IsNonWorkingDay;
DROP TABLE CountTotalWorkInHours;
GO
CREATE TABLE CountTotalWorkInHours
(
    STARTDATE DATETIME,
    END_DATE DATETIME,
    NO_OF_HOURS INT
);
GO
IF OBJECT_ID('dbo.IsNonWorkingDay', 'FN') IS NOT NULL
    DROP FUNCTION dbo.IsNonWorkingDay;
GO
CREATE FUNCTION dbo.IsNonWorkingDay(@Date DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @DayOfWeek INT = DATEPART(WEEKDAY, @Date);
    DECLARE @FirstSaturday DATE;
    DECLARE @SecondSaturday DATE;
    DECLARE @ThirdSaturday DATE;
    DECLARE @FourthSaturday DATE;

    DECLARE @FirstDayOfMonth DATE = DATEADD(DAY, 1 - DAY(@Date), @Date);
    SET @FirstSaturday = DATEADD(DAY, (7 - DATEPART(WEEKDAY, @FirstDayOfMonth) + 7) % 7, @FirstDayOfMonth);
    SET @SecondSaturday = DATEADD(DAY, 7, @FirstSaturday);
    SET @ThirdSaturday = DATEADD(DAY, 14, @FirstSaturday);
    SET @FourthSaturday = DATEADD(DAY, 21, @FirstSaturday);

    RETURN CASE 
        WHEN @DayOfWeek = 1 THEN 1 -- Sunday
        WHEN @Date = @FirstSaturday THEN 0
        WHEN @Date = @SecondSaturday THEN 0
        WHEN @Date = @ThirdSaturday THEN 1
        WHEN @Date = @FourthSaturday THEN 1
        ELSE 0 -- Working Day
    END;
END;
GO
IF OBJECT_ID('dbo.GetTotalHours', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTotalHours;
GO
CREATE PROCEDURE dbo.GetTotalHours
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    DECLARE @CurrentDate DATE = @StartDate;
    DECLARE @TotalHours INT = 0;
    
    WHILE @CurrentDate < @EndDate
    BEGIN
        IF (@CurrentDate = @StartDate) OR (dbo.IsNonWorkingDay(@CurrentDate) = 0)
        BEGIN
            SET @TotalHours = @TotalHours + 24;
        END
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
    IF @StartDate = @EndDate
    BEGIN
        SET @TotalHours = 0;
    END
    INSERT INTO CountTotalWorkInHours(STARTDATE, END_DATE, NO_OF_HOURS)
    VALUES (@StartDate, @EndDate, @TotalHours);
END;
GO
EXEC dbo.GetTotalHours '2023-07-01', '2023-07-17';
EXEC dbo.GetTotalHours '2023-07-01', '2023-07-01';
EXEC dbo.GetTotalHours '2023-07-01', '2023-07-02';
EXEC dbo.GetTotalHours '2023-07-02', '2023-07-03';
EXEC dbo.GetTotalHours '2022-05-01', '2022-05-08';
EXEC dbo.GetTotalHours '2021-02-15', '2021-02-26';
EXEC dbo.GetTotalHours '2021-12-01', '2021-12-25';
SELECT * FROM CountTotalWorkInHours;
