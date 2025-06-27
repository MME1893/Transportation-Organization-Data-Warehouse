USE TransitDW;
GO;


/*********************    DimCardType Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_DimCardType
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Safety: abort if table already has data                 */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM [Financial].DimCardType)
    BEGIN
        RAISERROR (N'DimCardType already contains data. Aborting first-load.',
                   16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardType',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimCardType',
         @ProcedureName = N'First_Fill_DimCardType';

    /*-------------------------------------------------------------*/
    /* 2.  Truncate + bulk insert                                  */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE [Financial].DimCardType;     -- ensures table empty

    INSERT INTO [Financial].DimCardType
           (CardTypeID_BK, TypeCode, Label_EN, Label_FA)
    SELECT  CardTypeID      ,   TypeCode, Label_EN, Label_FA
    FROM   TransitSA.dbo.SA_LkpCardType;

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3.  Log rows inserted                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardType',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimCardType.',
         @ProcedureName = N'First_Fill_DimCardType';

    /*-------------------------------------------------------------*/
    /* 4.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardType',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimCardType';
END;
GO;


/*********************    DimCardStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_DimCardStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Safety: abort if table already has data                 */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM [Financial].DimCardStatus)
    BEGIN
        RAISERROR (N'DimCardStatus already contains data. Aborting first-load.',
                   16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimCardType',
         @ProcedureName = N'First_Fill_DimCardStatus';

    /*-------------------------------------------------------------*/
    /* 2.  Truncate + bulk insert                                  */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE [Financial].DimCardStatus;     -- ensures table empty

    INSERT INTO [Financial].DimCardStatus
           (CardStatusID_BK, StatusCode, Label_EN, Label_FA)
    SELECT  CardStatusID      ,   StatusCode, Label_EN, Label_FA
    FROM   TransitSA.dbo.SA_LkpCardStatus;

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3.  Log rows inserted                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardStatus',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimCardStatus.',
         @ProcedureName = N'First_Fill_DimCardStatus';

    /*-------------------------------------------------------------*/
    /* 4.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimCardStatus';
END;
GO;


/*********************    DimSalesChannel Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_DimSalesChannel
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Safety: abort if table already has data                 */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM [Financial].DimSalesChannel)
    BEGIN
        RAISERROR (N'DimSalesChannel already contains data. Aborting first-load.',
                   16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimSalesChannel',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimSalesChannel',
         @ProcedureName = N'First_Fill_DimSalesChannel';

    /*-------------------------------------------------------------*/
    /* 2.  Truncate + bulk insert                                  */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE [Financial].DimSalesChannel;     -- ensures table empty

    INSERT INTO [Financial].DimSalesChannel
           (SalesChannelID_BK, ChannelCode, Label_EN, Label_FA)
    SELECT  SalesChannelID      ,   ChannelCode, Label_EN, Label_FA
    FROM   TransitSA.dbo.SA_LkpSalesChannel;

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3.  Log rows inserted                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimSalesChannel',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimSalesChannel.',
         @ProcedureName = N'First_Fill_DimSalesChannel';

    /*-------------------------------------------------------------*/
    /* 4.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimSalesChannel',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimSalesChannel';
END;
GO;



/*****************************************************************/
/*****************************************************************/
/**********************       Facts        ***********************/
/*****************************************************************/
/*****************************************************************/


/*********************    FactTrnsCardTopUp Table    *********************/

CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactTrnsCardTopUp
@option INT = 0
AS
	BEGIN

		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTap is empty                  */
		/*-------------------------------------------------------------*/
		IF @option = 0 AND EXISTS (SELECT 1 FROM [Financial].FactTrnsCardTopUp)
		BEGIN
			RAISERROR(N'FactTrnsCardTopUp already contains data. Aborting first load.',16,1);
			RETURN;
		END

		
		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactTrnsCardTopUp',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST load of FactTrnsCardTopUp ',
			 @ProcedureName = N'First_Fill_FactTrnsCardTopUp';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE [Financial].FactTrnsCardTopUp;          -- guarantees empty (idempotent)

		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT @current_date = CAST(MIN(TopUpDT) AS DATE) FROM TransitSA.dbo.SA_CardTopUpTxn;

		SELECT @end_date	 = CAST(MAX(TopUpDT) AS DATE) FROM TransitSA.dbo.SA_CardTopUpTxn;

		WHILE @current_date <= @end_date
		BEGIN 
			INSERT INTO [Financial].FactTrnsCardTopUp
			(
				DateKey,
				StationKey,
				TimeKey,
				SalesChannelKey,
				CardTypeKey,
				CardStatusKey,
				Amount
			)
			SELECT 
				CAST(CONVERT(VARCHAR(8), txn.TopUpDT, 112) AS INT) AS DateKey,
				txn.StationID,
				CAST(DATEPART(HOUR, txn.TopUpDT) * 100 + DATEPART(MINUTE, txn.TopUpDT) AS SMALLINT) as TimeKey,
				txn.SalesChannelID,
				c.CardTypeID,
				c.CardStatusID,
				txn.Amount
			FROM 
						[TransitSA].dbo.SA_CardTopUpTxn txn
			LEFT JOIN	
						[TransitSA].dbo.SA_Card c 
					ON txn.CardID = c.CardID
			WHERE  txn.TopUpDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) AND txn.TopUpDT >= CAST( @current_date AS DATETIME )
			SET @rows = @@ROWCOUNT;
			SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						+ N' rows in date ' + @current_date 
						+ N' ).';
			EXEC [Global].LogAction
					@TableName     = N'FactTrnsCardTopUp',
					@RowsAffected  = @rows,
					@SeverityLevel = 'INFO',
					@Description   = @desc,
					@ProcedureName = N'First_Fill_FactTrnsCardTopUp';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);
		END

		EXEC [Global].LogAction
         @TableName     = N'FactTrnsCardTopUp',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactTrnsCardTopUp',
         @ProcedureName = N'First_Fill_FactTrnsCardTopUp';
	END;
GO;


/*********************    FactDailyCardTopUp Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactDailyCardTopUp
AS
	BEGIN 
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyCardTap is empty                  */
		/*-------------------------------------------------------------*/
		IF EXISTS (SELECT 1 FROM [Financial].FactDailyCardTopUp)
		BEGIN
			RAISERROR(N'FactDailyCardTopUp already contains data. Aborting first load.',16,1);
			RETURN;
		END

		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyCardTopUp',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST load of FactDailyCardTopUp',
			 @ProcedureName = N'First_Fill_FactDailyCardTopUp';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE [Financial].FactDailyCardTopUp;          -- guarantees empty (idempotent)
		DECLARE 
				@end_date     DATE,
				@current_date DATE;


		SELECT @current_date = CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactTrnsCardTopUp;

		SELECT @end_date	 = CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactTrnsCardTopUp;

		IF @current_date IS NULL OR @end_date IS NULL 
		BEGIN 
			RAISERROR(N'FactTrnsCardTopUp does not contain data. Aborting first load.',16,1);
			RETURN;
		END

		WHILE @current_date <= @end_date

		BEGIN 

			INSERT INTO [Financial].FactDailyCardTopUp
			(
				DateKey,
				StationKey,
				SalesChannelKey,
				CardTypeKey,
				TotalTopUpAmt,
				TotalTopUps
			)
			SELECT 
					F.DateKey,
					F.StationKey,
					F.SalesChannelKey,
					F.CardTypeKey,
					COUNT(*) AS TotalTopUpAmt,
					SUM(F.Amount) AS TotalTopUps
			FROM 
				[Financial].FactTrnsCardTopUp f
			WHERE F.DateKey = CONVERT(INT, CONVERT(VARCHAR(8),@current_date,112))
			GROUP BY 
					F.DateKey,
					F.StationKey,
					F.SalesChannelKey,
					F.CardTypeKey
				
			SET @rows = @@ROWCOUNT;
				SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						  + N' rows in date ' +  CONVERT(NVARCHAR(9),@current_date, 112)
						  + N' ).';
			EXEC [Global].LogAction
					@TableName     = N'FactDailyCardTopUp',
					@RowsAffected  = @rows,
					@SeverityLevel = 'INFO',
					@Description   = @desc,
					@ProcedureName = N'First_Fill_FactDailyCardTopUp';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);	


		END
		EXEC [Global].LogAction
         @TableName     = N'FactDailyCardTopUp',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactDailyCardTopUp',
         @ProcedureName = N'First_Fill_FactDailyCardTopUp';
	END;
GO;



/*********************    FactAccCardTopUp Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactAccCardTopUp
AS
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Start log                                               */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactAccCardTopUp',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST (day-by-day) load of FactAccCardTopUp',
			 @ProcedureName = N'First_Fill_FactAccCardTopUp';
		/*-------------------------------------------------------------*/
		/* 1.  Date range                                              */
		/*-------------------------------------------------------------*/

		DECLARE @current_date DATE,
        @end_date     DATE,
        @des        NVARCHAR(MAX),
        @row_count  INT;



		SELECT @current_date = CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactDailyCardTopUp;

		SELECT @end_date	 = CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactDailyCardTopUp;

		IF @current_date IS NULL OR @end_date IS NULL 
		BEGIN 
        EXEC [Global].LogAction
             @TableName     = N'FactAccCardTopUp',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactDailyCardTopUp is empty – aborting.',
             @ProcedureName = N'First_Fill_FactAccCardTopUp';
        RETURN;
		END
		/*-------------------------------------------------------------*/
		/* 1-B. House-keeping (truncate scratch & bookmark tables)      */
		/*-------------------------------------------------------------*/
			TRUNCATE TABLE [Financial].TimeFactAccCardTopUp;   -- bookmark
			TRUNCATE TABLE [Temp].temp4_FactAccCardTopUp;      -- running total
			TRUNCATE TABLE [Temp].temp5_FactAccCardTopUp;      -- “yesterday”
			TRUNCATE TABLE [Temp].temp6_FactAccCardTopUp;      -- “today”

		WHILE @current_date <= @end_date
		BEGIN
		/*----------- 2-A  Copy yesterday → temp5 ------------------*/
			TRUNCATE TABLE [Temp].temp5_FactAccCardTopUp;	
			
	        INSERT INTO [Temp].temp5_FactAccCardTopUp
              (StationKey, SalesChannelKey, CardTypeKey,
               TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
	        SELECT StationKey, SalesChannelKey, CardTypeKey,
		           TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps
			FROM   [Temp].temp4_FactAccCardTopUp;

		    /*----------- 2-B  Load today → temp6 ----------------------*/
			TRUNCATE TABLE [Temp].temp6_FactAccCardTopUp;

			INSERT INTO [Temp].temp6_FactAccCardTopUp
				  (StationKey, SalesChannelKey, CardTypeKey,
				   TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
			SELECT StationKey,
				   SalesChannelKey,
				   CardTypeKey,
				   TotalTopUpAmt,
				   TotalTopUpAmt,                                           -- MaxTopUpAmt (single-day value)
				   CASE WHEN TotalTopUps = 0
						THEN 0
						ELSE TotalTopUpAmt / TotalTopUps END,              -- AvgTopUpAmt (single-day)
				   TotalTopUps
			FROM   [Financial].FactDailyCardTopUp
			WHERE  DateKey = CONVERT(INT, CONVERT(VARCHAR(8),@current_date,112));

			/*----------- 2-C  Merge yesterday+today → temp4 ----------*/
			TRUNCATE TABLE [Temp].temp4_FactAccCardTopUp;

			INSERT INTO  [Temp].temp4_FactAccCardTopUp
					(StationKey, SalesChannelKey, CardTypeKey,
					TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
			SELECT
				COALESCE(t6.StationKey     , t5.StationKey)      AS StationKey,
				COALESCE(t6.SalesChannelKey, t5.SalesChannelKey) AS SalesChannelKey,
				COALESCE(t6.CardTypeKey    , t5.CardTypeKey)     AS CardTypeKey,

				/* running totals */
				ISNULL(t5.TotalTopUpAmt,0) + ISNULL(t6.TotalTopUpAmt,0) AS TotalTopUpAmt,

				/* running MAX (largest single-day top-up value seen so far) */
				CASE WHEN ISNULL(t5.MaxTopUpAmt,0) > ISNULL(t6.MaxTopUpAmt,0)
						THEN t5.MaxTopUpAmt ELSE t6.MaxTopUpAmt END         AS MaxTopUpAmt,

				/* running AVG = running sum ÷ running count */
				CASE WHEN ISNULL(t5.TotalTopUps,0) + ISNULL(t6.TotalTopUps,0) = 0
						THEN 0
						ELSE (ISNULL(t5.TotalTopUpAmt,0) + ISNULL(t6.TotalTopUpAmt,0))
							/ (ISNULL(t5.TotalTopUps,0)  + ISNULL(t6.TotalTopUps,0))
				END                                                     AS AvgTopUpAmt,

				/* running counts */
				ISNULL(t5.TotalTopUps,0) + ISNULL(t6.TotalTopUps,0)     AS TotalTopUps
			FROM   [Temp].temp5_FactAccCardTopUp t5
			FULL   OUTER JOIN [Temp].temp6_FactAccCardTopUp t6
					ON  t5.StationKey      = t6.StationKey
					AND t5.SalesChannelKey = t6.SalesChannelKey
					AND t5.CardTypeKey     = t6.CardTypeKey;
			/*----------- 2-D  Per-day log ----------------------------*/
				SET @des = N'Processed DateKey=' + CONVERT(NVARCHAR(9),@current_date, 112);
				SET @row_count = (SELECT COUNT(*) FROM [Temp].temp6_FactAccCardTopUp);

				EXEC [Global].LogAction
					 @TableName     = N'FactAccCardTopUp',
					 @RowsAffected  = @row_count,
					 @SeverityLevel = 'INFO',
					 @Description   = @des,
					 @ProcedureName = N'First_Fill_FactAccCardTopUp';
			/*----------- 2-E  Bump to next calendar day --------------*/

			SET @current_date = DATEADD(DAY , 1 , @current_date);
		END;
		/*-------------------------------------------------------------*/
		/* 3.  Swap to real table & bookmark                           */
		/*-------------------------------------------------------------*/
		BEGIN TRAN;
			TRUNCATE TABLE [Financial].FactAccCardTopUp;

			INSERT INTO [Financial].FactAccCardTopUp
				  (StationKey, SalesChannelKey, CardTypeKey,
				   TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
			SELECT StationKey, SalesChannelKey, CardTypeKey,
				   TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps
			FROM   [Temp].temp4_FactAccCardTopUp;

			TRUNCATE TABLE [Financial].TimeAccFactCardTopUp;

			INSERT INTO [Financial].TimeFactAccCardTopUp ([Date])
			VALUES ( @end_date );
		COMMIT TRAN;

		/*-------------------------------------------------------------*/
		/* 4.  End log                                                 */
		/*-------------------------------------------------------------*/
		SET @des = N'FIRST load finished up to DateKey=' + CONVERT(NVARCHAR(9),@current_date, 112);
		SET @row_count = (SELECT COUNT(*) FROM [Financial].FactAccCardTopUp);

		EXEC [Global].LogAction
				@TableName     = N'FactAccCardTopUp',
				@RowsAffected  = @row_count,
				@SeverityLevel = 'INFO',
				@Description   = @des,
				@ProcedureName = N'First_Fill_FactAccCardTopUp';

	END;

GO;


/*********************    FactTrnsTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactTrnsTicketSale
@option INT = 0
AS
	BEGIN

		SET NOCOUNT ON;
		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTicketSale is empty                  */
		/*-------------------------------------------------------------*/
		IF @option = 0 AND EXISTS (SELECT 1 FROM [Financial].FactTrnsTicketSale)
		BEGIN
			RAISERROR(N'FactTrnsTicketSale already contains data. Aborting first load.',16,1);
			RETURN;
		END

		
		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactTrnsTicketSale',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST load of FactTrnsTicketSale ',
			 @ProcedureName = N'First_Fill_FactTrnsTicketSale';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE [Financial].FactTrnsTicketSale;          -- guarantees empty (idempotent)

		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT @current_date = CAST(MIN(SaleDT) AS DATE) FROM TransitSA.dbo.SA_TicketSaleTxn;

		SELECT @end_date	 = CAST(MAX(SaleDT) AS DATE) FROM TransitSA.dbo.SA_TicketSaleTxn;

		WHILE @current_date <= @end_date
		BEGIN 

			INSERT INTO [Financial].FactTrnsTicketSale
			(
				DateKey,
				StationKey,
				TimeKey,
				SalesChannelKey,
				TicketRevenue
			)
			SELECT 
				CAST(CONVERT(VARCHAR(8), txn.SaleDT, 112) AS INT) AS DateKey,
				txn.StationID,
				CAST(DATEPART(HOUR, txn.SaleDT) * 100 + DATEPART(MINUTE, txn.SaleDT) AS SMALLINT) as TimeKey,
				txn.SalesChannelID,
				txn.Amount
			FROM 
						[TransitSA].dbo.SA_TicketSaleTxn txn

			WHERE  txn.SaleDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) AND txn.SaleDT >= CAST( @current_date AS DATETIME )


			SET @rows = @@ROWCOUNT;
			SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						+ N' rows in date ' + CONVERT(NVARCHAR(9),@current_date, 112) 
						+ N' ).';

			EXEC [Global].LogAction
					@TableName     = N'FactTrnsTicketSale',
					@RowsAffected  = @rows,
					@SeverityLevel = 'INFO',
					@Description   = @desc,
					@ProcedureName = N'First_Fill_FactTrnsTicketSale';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);

		END

		EXEC [Global].LogAction
         @TableName     = N'FactTrnsTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactTrnsTicketSale',
         @ProcedureName = N'First_Fill_FactTrnsTicketSale';

	END;
GO;


/*********************    FactDailyTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactDailyTicketSale
AS
	BEGIN 
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyTicketSale is empty                  */
		/*-------------------------------------------------------------*/
		IF EXISTS (SELECT 1 FROM [Financial].FactDailyTicketSale)
		BEGIN
			RAISERROR(N'FactDailyTicketSale already contains data. Aborting first load.',16,1);
			RETURN;
		END

		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyTicketSale',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST load of FactDailyTicketSale',
			 @ProcedureName = N'First_Fill_FactDailyCardTopUp';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE [Financial].FactDailyTicketSale;          -- guarantees empty (idempotent)
		DECLARE 
				@end_date     DATE,
				@current_date DATE;


		SELECT @current_date = CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactTrnsTicketSale;

		SELECT @end_date	 = CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactTrnsTicketSale;

		IF @current_date IS NULL OR @end_date IS NULL 
		BEGIN 
			RAISERROR(N'FactTrnsTicketSale does not contain data. Aborting first load.',16,1);
			RETURN;
		END

		WHILE @current_date <= @end_date

		BEGIN 

			INSERT INTO [Financial].FactDailyTicketSale
			(
				DateKey,
				StationKey,
				SalesChannelKey,
				TotalTicketsSold,
				TotalRevenue
			)
			SELECT 
					F.DateKey,
					F.StationKey,
					F.SalesChannelKey,
					COUNT(*) AS TotalTopUpAmt,
					SUM(F.TicketRevenue) AS TotalRevenue
			FROM 
				[Financial].FactTrnsTicketSale f
			WHERE F.DateKey = CONVERT(INT, CONVERT(VARCHAR(8),@current_date,112))
			GROUP BY 
					F.DateKey,
					F.StationKey,
					F.SalesChannelKey
				
				
			SET @rows = @@ROWCOUNT;
				SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						  + N' rows in date ' +  CONVERT(NVARCHAR(9),@current_date, 112)
						  + N' ).';
			EXEC [Global].LogAction
					@TableName     = N'FactDailyTicketSale',
					@RowsAffected  = @rows,
					@SeverityLevel = 'INFO',
					@Description   = @desc,
					@ProcedureName = N'First_Fill_FactDailyTicketSale';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);	


		END
		EXEC [Global].LogAction
         @TableName     = N'FactDailyTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactDailyTicketSale',
         @ProcedureName = N'First_Fill_FactDailyTicketSale';
	END;
GO;


/*********************    FactAccTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].First_Fill_FactAccTicketSale
AS
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Start log                                               */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactAccTicketSale',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting FIRST (day-by-day) load of FactAccTicketSale',
			 @ProcedureName = N'First_Fill_FactAccTicketSale';
		/*-------------------------------------------------------------*/
		/* 1.  Date range                                              */
		/*-------------------------------------------------------------*/

		DECLARE @current_date	DATE,
        @end_date				DATE,
        @des					NVARCHAR(MAX),
        @row_count				INT;



		SELECT @current_date = CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactDailyTicketSale;

		SELECT @end_date	 = CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM [Financial].FactDailyTicketSale;

		IF @current_date IS NULL OR @end_date IS NULL 
		BEGIN 
        EXEC [Global].LogAction
             @TableName     = N'FactAccTicketSale',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactDailyTicketSale is empty – aborting.',
             @ProcedureName = N'First_Fill_FactAccTicketSale';
        RETURN;
		END
		/*-------------------------------------------------------------*/
		/* 1-B. House-keeping (truncate scratch & bookmark tables)      */
		/*-------------------------------------------------------------*/
			TRUNCATE TABLE [Financial].TimeFactAccTicketSale;   -- bookmark
			TRUNCATE TABLE [Temp].temp4_FactAccTicketSale;      -- running total
			TRUNCATE TABLE [Temp].temp5_FactAccTicketSale;      -- “yesterday”
			TRUNCATE TABLE [Temp].temp6_FactAccTicketSale;      -- “today”

		WHILE @current_date <= @end_date
		BEGIN
		/*----------- 2-A  Copy yesterday → temp5 ------------------*/
			TRUNCATE TABLE [Temp].temp5_FactAccTicketSale;	
			
	        INSERT INTO [Temp].temp5_FactAccTicketSale
            (
				StationKey, SalesChannelKey,
				TotalTicketsSold, TotalRevenue
			)
	        SELECT 	StationKey, SalesChannelKey,
					TotalTicketsSold, TotalRevenue
			FROM   [Temp].temp4_FactAccTicketSale;

		    /*----------- 2-B  Load today → temp6 ----------------------*/
			TRUNCATE TABLE [Temp].temp6_FactAccTicketSale;

			INSERT INTO [Temp].temp6_FactAccTicketSale
			(
				StationKey, SalesChannelKey,
				TotalTicketsSold, TotalRevenue
			)
			SELECT StationKey,
				   SalesChannelKey,
				   TotalTicketsSold,
				   TotalRevenue                                    
			FROM   [Financial].FactDailyTicketSale
			WHERE  DateKey = CONVERT(INT, CONVERT(VARCHAR(8),@current_date,112));

			/*----------- 2-C  Merge yesterday+today → temp4 ----------*/
			TRUNCATE TABLE [Temp].temp4_FactAccTicketSale;

			INSERT INTO  [Temp].temp4_FactAccTicketSale
			(
				StationKey, SalesChannelKey,
				TotalTicketsSold, TotalRevenue
			)
			SELECT
				COALESCE(t6.StationKey     , t5.StationKey)      AS StationKey,
				COALESCE(t6.SalesChannelKey, t5.SalesChannelKey) AS SalesChannelKey,

				/* running totals */
				ISNULL(t5.TotalTicketsSold,0) + ISNULL(t6.TotalTicketsSold,0)     AS TotalTicketsSold,

				ISNULL(t5.TotalRevenue,0)	  + ISNULL(t6.TotalRevenue,0)		  AS TotalRevenue

			FROM   [Temp].temp5_FactAccTicketSale t5
			FULL   OUTER JOIN [Temp].temp6_FactAccTicketSale t6
					ON  t5.StationKey      = t6.StationKey
					AND t5.SalesChannelKey = t6.SalesChannelKey
			/*----------- 2-D  Per-day log ----------------------------*/
				SET @des = N'Processed DateKey=' + CONVERT(NVARCHAR(9),@current_date, 112);
				SET @row_count = (SELECT COUNT(*) FROM [Temp].temp6_FactAccTicketSale);

				EXEC [Global].LogAction
					 @TableName     = N'FactAccTicketSale',
					 @RowsAffected  = @row_count,
					 @SeverityLevel = 'INFO',
					 @Description   = @des,
					 @ProcedureName = N'First_Fill_FactAccTicketSale';
			/*----------- 2-E  Bump to next calendar day --------------*/

			SET @current_date = DATEADD(DAY , 1 , @current_date);
		END;
		/*-------------------------------------------------------------*/
		/* 3.  Swap to real table & bookmark                           */
		/*-------------------------------------------------------------*/
		BEGIN TRAN;
			TRUNCATE TABLE [Financial].FactAccTicketSale;

			INSERT INTO [Financial].FactAccTicketSale
			(
				StationKey, SalesChannelKey,
				TotalTicketsSold, TotalRevenue
			)
			SELECT
				StationKey, SalesChannelKey,
				TotalTicketsSold, TotalRevenue
			FROM   [Temp].temp4_FactAccTicketSale;

			TRUNCATE TABLE [Financial].TimeFactAccTicketSale;

			INSERT INTO [Financial].TimeFactAccTicketSale ([Date])
			VALUES ( @end_date );
		COMMIT TRAN;

		/*-------------------------------------------------------------*/
		/* 4.  End log                                                 */
		/*-------------------------------------------------------------*/
		SET @des = N'FIRST load finished up to DateKey=' + CONVERT(NVARCHAR(9),@current_date, 112);
		SET @row_count = (SELECT COUNT(*) FROM [Financial].FactAccTicketSale);

		EXEC [Global].LogAction
				@TableName     = N'FactAccTicketSale',
				@RowsAffected  = @row_count,
				@SeverityLevel = 'INFO',
				@Description   = @des,
				@ProcedureName = N'First_Fill_FactAccTicketSale';

	END;

GO;


