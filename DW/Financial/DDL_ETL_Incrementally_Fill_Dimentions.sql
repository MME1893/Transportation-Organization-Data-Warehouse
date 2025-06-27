USE TransitDW;
GO;

/*********************    DimCardType Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_DimCardType
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------------------------------------------
      0.  Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardType',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimCardType (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimCardType';

    /*-----------------------------------------------------------------
      1.  MERGE  source → dimension
    -----------------------------------------------------------------*/
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  [Financial].DimCardType     AS tgt
    USING  TransitSA.dbo.SA_LkpCardType              AS src
          ON tgt.CardTypeID_BK = src.CardTypeID       -- match on BK
    /*—— update descriptive text if anything changed ————————*/
    WHEN MATCHED AND
         (   ISNULL(tgt.TypeCode, N'') <> ISNULL(src.TypeCode, N'')
          OR ISNULL(tgt.Label_EN , N'')  <> ISNULL(src.Label_EN , N'')
          OR ISNULL(tgt.Label_FA , N'')  <> ISNULL(src.Label_FA , N'') )
      THEN UPDATE SET
           tgt.TypeCode = src.TypeCode,
           tgt.Label_EN   = src.Label_EN,
           tgt.Label_FA   = src.Label_FA
    /*—— insert brand-new journey-status codes ————————————*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (CardTypeID_BK, TypeCode, Label_EN, Label_FA)
           VALUES (src.CardTypeID , src.TypeCode , src.Label_EN , src.Label_FA)
    /*—— keep rows missing from source (no delete branch) ——*/
    OUTPUT $action INTO @mergeLog(action);

    /*-----------------------------------------------------------------
      2.  Per-action logging
    -----------------------------------------------------------------*/
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@des varchar(MAX);

    IF @rowsInserted > 0
	BEGIN
		SET @des = N'Rows inserted into DimCardType: '
                              + CAST(@rowsInserted AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimCardType',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimCardType';
	END

    IF @rowsUpdated > 0
	BEGIN
		SET @des = N'Rows updated in DimCardType: '
                              + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimCardType',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimCardType';
	END

    /*-----------------------------------------------------------------
      3.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardType',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimCardType';
END;
GO


/*********************    DimCardStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_DimCardStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------------------------------------------
      0.  Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimCardStatus (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimCardStatus';

    /*-----------------------------------------------------------------
      1.  MERGE  source → dimension
    -----------------------------------------------------------------*/
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  [Financial].DimCardStatus     AS tgt
    USING  TransitSA.dbo.SA_LkpCardStatus              AS src
          ON tgt.CardStatusID_BK = src.CardStatusID       -- match on BK
    /*—— update descriptive text if anything changed ————————*/
    WHEN MATCHED AND
         (   ISNULL(tgt.StatusCode, N'') <> ISNULL(src.StatusCode, N'')
          OR ISNULL(tgt.Label_EN , N'')  <> ISNULL(src.Label_EN , N'')
          OR ISNULL(tgt.Label_FA , N'')  <> ISNULL(src.Label_FA , N'') )
      THEN UPDATE SET
           tgt.StatusCode = src.StatusCode,
           tgt.Label_EN   = src.Label_EN,
           tgt.Label_FA   = src.Label_FA
    /*—— insert brand-new journey-status codes ————————————*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (CardStatusID_BK, StatusCode, Label_EN, Label_FA)
           VALUES (src.CardStatusID , src.StatusCode , src.Label_EN , src.Label_FA)
    /*—— keep rows missing from source (no delete branch) ——*/
    OUTPUT $action INTO @mergeLog(action);

    /*-----------------------------------------------------------------
      2.  Per-action logging
    -----------------------------------------------------------------*/
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@des varchar(MAX);

    IF @rowsInserted > 0
	BEGIN
		SET @des = N'Rows inserted into DimCardStatus: '
                              + CAST(@rowsInserted AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimCardStatus',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimCardStatus';
	END

    IF @rowsUpdated > 0
	BEGIN
		SET @des = N'Rows updated in DimCardStatus: '
                              + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimCardStatus',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimCardStatus';
	END

    /*-----------------------------------------------------------------
      3.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimCardStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimCardStatus';
END;
GO


/*********************    DimSalesChannel Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_DimSalesChannel
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------------------------------------------
      0.  Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimSalesChannel',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimSalesChannel (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimSalesChannel';

    /*-----------------------------------------------------------------
      1.  MERGE  source → dimension
    -----------------------------------------------------------------*/
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  [Financial].DimSalesChannel     AS tgt
    USING  TransitSA.dbo.SA_LkpSalesChannel              AS src
          ON tgt.SalesChannelID_BK = src.SalesChannelID       -- match on BK
    /*—— update descriptive text if anything changed ————————*/
    WHEN MATCHED AND
         (   ISNULL(tgt.ChannelCode, N'') <> ISNULL(src.ChannelCode, N'')
          OR ISNULL(tgt.Label_EN , N'')  <> ISNULL(src.Label_EN , N'')
          OR ISNULL(tgt.Label_FA , N'')  <> ISNULL(src.Label_FA , N'') )
      THEN UPDATE SET
           tgt.ChannelCode = src.ChannelCode,
           tgt.Label_EN   = src.Label_EN,
           tgt.Label_FA   = src.Label_FA
    /*—— insert brand-new journey-status codes ————————————*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (SalesChannelID_BK, ChannelCode, Label_EN, Label_FA)
           VALUES (src.SalesChannelID , src.ChannelCode , src.Label_EN , src.Label_FA)
    /*—— keep rows missing from source (no delete branch) ——*/
    OUTPUT $action INTO @mergeLog(action);

    /*-----------------------------------------------------------------
      2.  Per-action logging
    -----------------------------------------------------------------*/
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@des varchar(MAX);

    IF @rowsInserted > 0
	BEGIN
		SET @des = N'Rows inserted into DimSalesChannel: '
                              + CAST(@rowsInserted AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimSalesChannel',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimSalesChannel';
	END

    IF @rowsUpdated > 0
	BEGIN
		SET @des = N'Rows updated in DimSalesChannel: '
                              + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimSalesChannel',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimSalesChannel';
	END

    /*-----------------------------------------------------------------
      3.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimSalesChannel',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimSalesChannel';
END;
GO  


/*****************************************************************/
/*****************************************************************/
/**********************       Facts        ***********************/
/*****************************************************************/
/*****************************************************************/

/*********************    FactTrnsCardTap Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_FactTrnsCardTopUp
AS 
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsCardTopUp is not empty                  */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM [Financial].FactTrnsCardTopUp)
		BEGIN
			RAISERROR(N'FactTrnsCardTopUp does not contain data. Aborting incrementally load.',16,1);
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
			 @Description   = N'Starting Incrementally load of FactTrnsCardTopUp',
			 @ProcedureName = N'Incrementally_Fill_FactTrnsCardTopUp';
		
		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM [Financial].FactTrnsCardTopUp;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CAST(MAX(TopUpDT) AS DATE ) FROM TransitSA.dbo.SA_CardTopUpTxn;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from SA_CardTopUpTxn' , 16 , 1);
			RETURN;
		END
		

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
							+ N' rows in date '  
							+ N' ).';
				EXEC [Global].LogAction
						@TableName     = N'FactTrnsCardTopUp',
						@RowsAffected  = @rows,
						@SeverityLevel = 'INFO',
						@Description   = @desc,
						@ProcedureName = N'Incrementally_Fill_FactTrnsCardTopUp';

				SET @current_date = DATEADD(DAY, 1 ,@current_date);
			END
			EXEC [Global].LogAction
			 @TableName     = N'FactTrnsCardTopUp',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Completed FIRST load of FactTrnsCardTopUp',
			 @ProcedureName = N'Incrementally_Fill_FactTrnsCardTopUp';
	END;
GO;


/*********************    FactDailyCardTopUp Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_FactDailyCardTopUp
AS  
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyCardTopUp is not empty                  */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM [Financial].FactDailyCardTopUp)
		BEGIN
			RAISERROR(N'FactDailyCardTopUp does not contain data. Aborting incrementally load.',16,1);
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
			 @Description   = N'Starting Incrementally load of FactDailyCardTopUp',
			 @ProcedureName = N'Incrementally_FactDailyCardTopUp';

		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM [Financial].FactDailyCardTopUp;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )  FROM [Financial].FactDailyCardTopUp;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactDailyCardTopUp' , 16 , 1);
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
					@ProcedureName = N'Incrementally_FactDailyCardTopUp';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);	
		END
		EXEC [Global].LogAction
         @TableName     = N'FactDailyCardTopUp',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed Incrementally load of FactDailyCardTopUp',
         @ProcedureName = N'Incrementally_FactDailyCardTopUp';
	END;
GO;


/*********************    FactAccCardTopUp Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_FactAccCardTopUp
AS
BEGIN
    SET NOCOUNT ON;
    

    ------------------------------------------------------------------
    -- 0.  Start-of-run logging
    ------------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'FactAccCardTopUp',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting accumulator load (Incrementally_Fill_FactAccCardTopUp)',
         @ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';


	IF NOT EXISTS ( SELECT 1 FROM [Financial].FactAccCardTopUp) OR NOT EXISTS ( SELECT 1 FROM [Financial].TimeFactAccCardTopUp)
	BEGIN 
		 EXEC [Global].LogAction
         @TableName     = N'FactAccCardTopUp',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FAILD, NO DATA IN FactAccTap or TimeFactAccCardTopUp',
         @ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';

		 RETURN;
	END
    ------------------------------------------------------------------
    -- 1.  Date range discovery
    ------------------------------------------------------------------
    DECLARE @current_date DATE,
            @end_date    DATE,
			@des        NVARCHAR(MAX),
			@row_count  INT;



    SELECT  @current_date = CONVERT(DATE,CAST(MIN(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ),
            @end_date    = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )
    FROM    [Financial].FactDailyCardTopUp;

    /* resume from the last bookmark if it exists */
    SELECT @current_date =
           ISNULL(
               (SELECT DATEADD(DAY, 1, MAX([Date]) ) FROM [Financial].TimeFactAccCardTopUp),
               @current_date
           );
     
    /* nothing to do? */
    IF @current_date IS NULL OR @current_date > @end_date
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccCardTopUp',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'No new days to process – exiting.',
             @ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';
        RETURN;
    END

    ------------------------------------------------------------------
    -- 2.  Main day-by-day loop
    ------------------------------------------------------------------
	TRUNCATE TABLE [Financial].TimeFactAccCardTopUp;   -- bookmark
	TRUNCATE TABLE [Temp].temp1_FactAccCardTopUp;      -- running total
	TRUNCATE TABLE [Temp].temp2_FactAccCardTopUp;      -- “yesterday”
	TRUNCATE TABLE [Temp].temp3_FactAccCardTopUp;      -- “today”

	WHILE @current_date <= @end_date
	BEGIN
	/*----------- 2-A  Copy yesterday → temp2 ------------------*/
		TRUNCATE TABLE [Temp].temp2_FactAccCardTopUp;	
			
	    INSERT INTO [Temp].temp2_FactAccCardTopUp
            (StationKey, SalesChannelKey, CardTypeKey,
            TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
	    SELECT StationKey, SalesChannelKey, CardTypeKey,
		        TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps
		FROM   [Temp].temp1_FactAccCardTopUp;

		/*----------- 2-B  Load today → temp3 ----------------------*/
		TRUNCATE TABLE [Temp].temp3_FactAccCardTopUp;

		INSERT INTO [Temp].temp3_FactAccCardTopUp
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
		TRUNCATE TABLE [Temp].temp1_FactAccCardTopUp;

		INSERT INTO  [Temp].temp1_FactAccCardTopUp
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
		FROM   [Temp].temp2_FactAccCardTopUp t5
		FULL   OUTER JOIN [Temp].temp3_FactAccCardTopUp t6
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
				@ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';
		/*----------- 2-E  Bump to next calendar day --------------*/

		SET @current_date = DATEADD(DAY , 1 , @current_date);
	END;

    ------------------------------------------------------------------
    -- 3.  Swap into real accumulator & bookmark end date
    ------------------------------------------------------------------
		BEGIN TRAN;
			TRUNCATE TABLE [Financial].FactAccCardTopUp;

			INSERT INTO [Financial].FactAccCardTopUp
				  (StationKey, SalesChannelKey, CardTypeKey,
				   TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
			SELECT StationKey, SalesChannelKey, CardTypeKey,
				   TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps
			FROM   [Temp].temp1_FactAccCardTopUp;

			TRUNCATE TABLE [Financial].TimeAccFactCardTopUp;

			INSERT INTO [Financial].TimeFactAccCardTopUp ([Date])
			VALUES ( @end_date );
		COMMIT TRAN;

    ------------------------------------------------------------------
    -- 4.  End-of-run audit
    ------------------------------------------------------------------
	SET @des		= N'Accumulator load complete up to DateKey=' + CAST(@end_date AS NVARCHAR(8));
	SET @row_count  = (SELECT COUNT(*) FROM [Temp].temp1_FactAccTap);
    EXEC [Global].LogAction
         @TableName     = N'FactAccCardTopUp',
         @RowsAffected  = @row_count,
         @SeverityLevel = 'INFO',
         @Description   = @des,
         @ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';
END;
GO


/*********************    FactTrnsTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_FactTrnsCardTopUp
AS 
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTap is not empty                  */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM [Financial].FactTrnsTicketSale)
		BEGIN
			RAISERROR(N'FactTrnsTicketSale does not contain data. Aborting incrementally load.',16,1);
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
			 @Description   = N'Starting Incrementally load of FactTrnsTicketSale',
			 @ProcedureName = N'Incrementally_Fill_FactTrnsTicketSale';
		
		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM [Financial].FactTrnsTicketSale;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CAST(MAX(SaleDT) AS DATE ) FROM TransitSA.dbo.SA_TicketSaleTxn;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from SA_TicketSaleTxn' , 16 , 1);
			RETURN;
		END
		

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
         @ProcedureName = N'Incrementally_Fill_FactTrnsTicketSale';
	END;
GO;


/*********************    FactDailyTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_FactDailyTicketSale
AS  
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyTicketSale is not empty                  */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM [Financial].FactDailyTicketSale)
		BEGIN
			RAISERROR(N'FactDailyTicketSale does not contain data. Aborting incrementally load.',16,1);
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
			 @Description   = N'Starting Incrementally load of FactDailyTicketSale',
			 @ProcedureName = N'Incrementally_FactDailyTicketSale';

		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM [Financial].FactDailyTicketSale;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )  FROM [Financial].FactDailyTicketSale;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactDailyTicketSale' , 16 , 1);
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
					@ProcedureName = N'Incrementally_FactDailyTicketSale';

			SET @current_date = DATEADD(DAY, 1 ,@current_date);	


		END
	
	
	
	EXEC [Global].LogAction
         @TableName     = N'FactDailyTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed Incrementally load of FactDailyTicketSale',
         @ProcedureName = N'Incrementally_FactDailyTicketSale';
	END;
GO;



/*********************    FactAccTicketSale Table    *********************/
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_FactAccTicketSale
AS
BEGIN
    SET NOCOUNT ON;
    

    ------------------------------------------------------------------
    -- 0.  Start-of-run logging
    ------------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'FactAccTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting accumulator load (Incrementally_Fill_FactAccTicketSale)',
         @ProcedureName = N'Incrementally_Fill_FactAccTicketSale';


	IF NOT EXISTS ( SELECT 1 FROM [Financial].FactAccTicketSale) OR NOT EXISTS ( SELECT 1 FROM [Financial].TimeFactAccTicketSale)
	BEGIN 
		 EXEC [Global].LogAction
         @TableName     = N'FactAccTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FAILD, NO DATA IN FactAccTap or TimeFactAccTicketSale',
         @ProcedureName = N'Incrementally_Fill_FactAccTicketSale';

		 RETURN;
	END
    ------------------------------------------------------------------
    -- 1.  Date range discovery
    ------------------------------------------------------------------
    DECLARE @current_date DATE,
            @end_date    DATE,
			@des        NVARCHAR(MAX),
			@row_count  INT;



    SELECT  @current_date = CONVERT(DATE,CAST(MIN(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ),
            @end_date    = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )
    FROM    [Financial].FactDailyTicketSale;

    /* resume from the last bookmark if it exists */
    SELECT @current_date =
           ISNULL(
               (SELECT DATEADD(DAY, 1, MAX([Date]) ) FROM [Financial].TimeFactAccTicketSale),
               @current_date
           );
     
    /* nothing to do? */
    IF @current_date IS NULL OR @current_date > @end_date
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'TimeFactAccTicketSale',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'No new days to process – exiting.',
             @ProcedureName = N'Incrementally_Fill_FactAccTicketSale';
        RETURN;
    END

    ------------------------------------------------------------------
    -- 2.  Main day-by-day loop
    ------------------------------------------------------------------
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
				@ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';
		/*----------- 2-E  Bump to next calendar day --------------*/

		SET @current_date = DATEADD(DAY , 1 , @current_date);
	END;

    ------------------------------------------------------------------
    -- 3.  Swap into real accumulator & bookmark end date
    ------------------------------------------------------------------
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

    ------------------------------------------------------------------
    -- 4.  End-of-run audit
    ------------------------------------------------------------------
	SET @des		= N'Accumulator load complete up to DateKey=' + CAST(@end_date AS NVARCHAR(8));
	SET @row_count  = (SELECT COUNT(*) FROM [Temp].temp4_FactAccTap);
    EXEC [Global].LogAction
         @TableName     = N'FactAccCardTopUp',
         @RowsAffected  = @row_count,
         @SeverityLevel = 'INFO',
         @Description   = @des,
         @ProcedureName = N'Incrementally_Fill_FactAccCardTopUp';
END;
GO












