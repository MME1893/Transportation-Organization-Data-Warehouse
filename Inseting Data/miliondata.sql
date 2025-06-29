SET NOCOUNT ON;

DECLARE @BatchSize INT = 100000;
DECLARE @Total INT = 1000000;
DECLARE @InsertedCount INT = 0;

DECLARE @CardID BIGINT;
DECLARE @IssueDate DATE;
DECLARE @ExpiryDate DATE;
DECLARE @TopUpDT DATETIME;
DECLARE @Amount MONEY;
DECLARE @SalesChannelID INT;
DECLARE @StationID INT;
DECLARE @RandomDays INT;

WHILE @InsertedCount < @Total
BEGIN
    DECLARE @j INT = 0;

    WHILE @j < @BatchSize
    BEGIN
        SET @CardID = (ABS(CHECKSUM(NEWID())) % 20000) + 1;

        SELECT @IssueDate = IssueDate, @ExpiryDate = ExpiryDate
        FROM Financial.Card
        WHERE CardID = @CardID;

        IF @IssueDate IS NOT NULL AND @ExpiryDate IS NOT NULL
        BEGIN
            SET @RandomDays = ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '2025-01-01', '2027-01-01');
            SET @TopUpDT = DATEADD(SECOND, 
                            ABS(CHECKSUM(NEWID())) % 86400,
                            DATEADD(DAY, @RandomDays, '2025-01-01'));

            IF (@TopUpDT >= @IssueDate AND @TopUpDT < @ExpiryDate)
            BEGIN
                SET @Amount = (ABS(CHECKSUM(NEWID())) % 91 + 10) * 1000;
                SET @SalesChannelID = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 2 END;
                SET @StationID = (ABS(CHECKSUM(NEWID())) % 148) + 1;
                INSERT INTO Financial.CardTopUpTxn (CardID, TopUpDT, Amount, SalesChannelID, StationID)
                VALUES (@CardID, @TopUpDT, @Amount, @SalesChannelID, @StationID);

                UPDATE Financial.Card
                SET 
                    CurrentBalance = ISNULL(CurrentBalance, 0) + @Amount,
                    LastTopUpDT = @TopUpDT
                WHERE CardID = @CardID;

                SET @j += 1;
                SET @InsertedCount += 1;
            END
        END
    END

    PRINT CONCAT('Inserted ', @InsertedCount, ' records so far...');
END


