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
							+ N' rows in date ' + CONVERT(NVARCHAR(9),@current_date, 112)   
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

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )  FROM [Financial].FactTrnsCardTopUp;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactDailyCardTopUp' , 16 , 1);
			RETURN;
		END
		

		
		TRUNCATE TABLE Temp.temp1_cross_Station_SalesChannel_CardType;
		INSERT INTO Temp.temp1_cross_Station_SalesChannel_CardType
		(
			StationKey, SalesChannelKey, CardTypeKey
		)
		SELECT 
			s.StationID_BK, sc.SalesChannelID_BK, c.CardTypeID_BK
		FROM 
			Global.DimStation s
		CROSS JOIN 
			Financial.DimSalesChannel sc
		CROSS JOIN 
			Financial.DimCardType c

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
					CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112)) AS DateKey,
					T.StationKey,
					T.SalesChannelKey,
					T.CardTypeKey,
					SUM  ( CASE WHEN P.StationKey IS NOT NULL THEN P.Amount ELSE 0 END )  AS TotalTopUpAmt,
					COUNT( CASE WHEN P.StationKey IS NOT NULL THEN 1 END ) AS TotalTopUps
			FROM 
				Temp.temp1_cross_Station_SalesChannel_CardType AS T
			LEFT JOIN
				[Financial].FactTrnsCardTopUp AS p
				ON 
					P.StationKey = T.StationKey AND
					P.CardTypeKey = T.CardTypeKey AND
					P.SalesChannelKey = T.SalesChannelKey AND
					P.DateKey = CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112))
			GROUP BY 
					T.StationKey,
					T.SalesChannelKey,
					T.CardTypeKey
				
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

	INSERT INTO [Temp].temp1_FactAccCardTopUp
	            (StationKey, SalesChannelKey, CardTypeKey,
            TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
	SELECT             StationKey, SalesChannelKey, CardTypeKey,
            TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps
	FROM [Financial].FactAccCardTopUp


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

        /*— 1) Upsert cumulative totals from temp1 into the real fact —*/
        MERGE [Financial].FactAccCardTopUp AS tgt
        USING [Temp].temp1_FactAccCardTopUp AS src
          ON  tgt.StationKey      = src.StationKey
          AND tgt.SalesChannelKey = src.SalesChannelKey
          AND tgt.CardTypeKey     = src.CardTypeKey
        WHEN MATCHED THEN
            UPDATE SET
                tgt.TotalTopUpAmt = src.TotalTopUpAmt,
                tgt.MaxTopUpAmt   = src.MaxTopUpAmt,
                tgt.AvgTopUpAmt   = src.AvgTopUpAmt,
                tgt.TotalTopUps   = src.TotalTopUps
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (StationKey, SalesChannelKey, CardTypeKey,
                    TotalTopUpAmt, MaxTopUpAmt, AvgTopUpAmt, TotalTopUps)
            VALUES (src.StationKey, src.SalesChannelKey, src.CardTypeKey,
                    src.TotalTopUpAmt, src.MaxTopUpAmt, src.AvgTopUpAmt, src.TotalTopUps);

        TRUNCATE TABLE [Financial].TimeFactAccCardTopUp;
        INSERT INTO [Financial].TimeFactAccCardTopUp ([Date])
        VALUES (@end_date);

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
CREATE OR ALTER PROCEDURE [Financial].Incrementally_Fill_FactTrnsTicketSale
AS 
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTicketSale is not empty                  */
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

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )  FROM [Financial].FactTrnsTicketSale;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactDailyTicketSale' , 16 , 1);
			RETURN;
		END
		
		TRUNCATE TABLE Temp.temp1_cross_Station_SalesChannel;
		INSERT INTO Temp.temp1_cross_Station_SalesChannel
		( StationKey , SalesChannelKey) 
		SELECT S.StationID_BK, SC.SalesChannelID_BK
		FROM 
			Global.DimStation s
		CROSS JOIN 
			Financial.DimSalesChannel sc




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
					20250530,--CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112)) AS DateKey,
					T.StationKey,
					T.SalesChannelKey,
					COUNT(CASE WHEN TS.StationKey IS NOT NULL THEN 1 END) AS TotalTicketsSold,
					SUM(CASE WHEN TS.StationKey IS NOT NULL THEN TS.TicketRevenue ELSE 0 END) AS TotalRevenue
			FROM 
				Temp.temp1_cross_Station_SalesChannel AS T
			LEFT JOIN 
				[Financial].FactTrnsTicketSale AS TS
				ON 
					T.StationKey =TS.StationKey AND
					T.SalesChannelKey = TS.SalesChannelKey AND
				    TS.DateKey = 20250530--CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112))
				GROUP BY
					T.StationKey,
					T.SalesChannelKey
				
				
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

    /*---------------------------------------------------------------*/
    /* 0.  Start log                                                 */
    /*---------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactAccTicketSale',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting INCREMENTAL load of FactAccTicketSale',
         @ProcedureName = N'Incremental_Fill_FactAccTicketSale';

    /*---------------------------------------------------------------*/
    /* 1.  Date range                                                */
    /*     – start = bookmark + 1                                    */
    /*     – end   = newest day in the daily fact                    */
    /*---------------------------------------------------------------*/
    DECLARE @current_date DATE,
            @end_date     DATE,
            @des          NVARCHAR(MAX),
            @row_count    INT;

    /* last date successfully processed; table always has ≤1 row */
    SELECT @current_date = DATEADD(DAY, 1, MAX([Date]))
    FROM   [Financial].TimeFactAccTicketSale;   -- bookmark

    /* safety: if bookmark is empty, fall back to very first date */
    IF @current_date IS NULL
        SELECT @current_date =
               CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)), 112)
        FROM   [Financial].FactDailyTicketSale;

    /* newest business date available */
    SELECT @end_date =
           CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)), 112)
    FROM   [Financial].FactDailyTicketSale;

    /* nothing new? – log and quit */
    IF @current_date IS NULL 
       OR @end_date IS NULL 
       OR @current_date > @end_date
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccTicketSale',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'No new dates to process – exiting.',
             @ProcedureName = N'Incremental_Fill_FactAccTicketSale';
        RETURN;
    END

    /*---------------------------------------------------------------*/
    /* 1-B.  House-keeping                                           */
    /*---------------------------------------------------------------*/
    TRUNCATE TABLE [Temp].temp1_FactAccTicketSale;  -- running total
    TRUNCATE TABLE [Temp].temp2_FactAccTicketSale;  -- “yesterday”
    TRUNCATE TABLE [Temp].temp3_FactAccTicketSale;  -- “today”

    /* *** NEW ***  seed running-total table with CURRENT contents  */
    INSERT INTO [Temp].temp1_FactAccTicketSale
          (StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue)
    SELECT StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue
    FROM   [Financial].FactAccTicketSale;
    /*---------------------------------------------------------------*/

    /*===============================================================*/
    /* 2.  Loop day-by-day from @current_date → @end_date            */
    /*===============================================================*/
    WHILE @current_date <= @end_date
    BEGIN
        /* 2-A  Copy “yesterday” → temp2                              */
        TRUNCATE TABLE [Temp].temp2_FactAccTicketSale;

        INSERT INTO [Temp].temp2_FactAccTicketSale
              (StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue)
        SELECT StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue
        FROM   [Temp].temp1_FactAccTicketSale;

        /* 2-B  Load “today” delta → temp3                           */
        TRUNCATE TABLE [Temp].temp3_FactAccTicketSale;

        INSERT INTO [Temp].temp3_FactAccTicketSale
              (StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue)
        SELECT StationKey,
               SalesChannelKey,
               TotalTicketsSold,
               TotalRevenue
        FROM   [Financial].FactDailyTicketSale
        WHERE  DateKey = CONVERT(INT, CONVERT(CHAR(8), @current_date, 112));

        /* 2-C  Merge yesterday+today → temp4 (running totals)        */
        TRUNCATE TABLE [Temp].temp1_FactAccTicketSale;

        INSERT INTO [Temp].temp1_FactAccTicketSale
              (StationKey, SalesChannelKey, TotalTicketsSold, TotalRevenue)
        SELECT COALESCE(t6.StationKey     , t5.StationKey)      AS StationKey,
               COALESCE(t6.SalesChannelKey, t5.SalesChannelKey) AS SalesChannelKey,
               ISNULL(t5.TotalTicketsSold,0) + ISNULL(t6.TotalTicketsSold,0) AS TotalTicketsSold,
               ISNULL(t5.TotalRevenue    ,0) + ISNULL(t6.TotalRevenue    ,0) AS TotalRevenue
        FROM   [Temp].temp2_FactAccTicketSale t5
        FULL   OUTER JOIN [Temp].temp3_FactAccTicketSale t6
               ON  t5.StationKey      = t6.StationKey
               AND t5.SalesChannelKey = t6.SalesChannelKey;

        /* 2-D  Log per-day                                           */
        SET @des       = N'Processed DateKey='
                       + CONVERT(NVARCHAR(8), @current_date, 112);
        SET @row_count = (SELECT COUNT(*) FROM [Temp].temp3_FactAccTicketSale);

        EXEC [Global].LogAction
             @TableName     = N'FactAccTicketSale',
             @RowsAffected  = @row_count,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incremental_Fill_FactAccTicketSale';

        /* 2-E  Next day                                              */
        SET @current_date = DATEADD(DAY, 1, @current_date);
    END; -- WHILE

    /*---------------------------------------------------------------*/
    /* 3.  Merge running totals back into the real fact              */
    /*     – do NOT truncate: use MERGE to update / insert           */
    /*---------------------------------------------------------------*/
    BEGIN TRAN;

        MERGE [Financial].FactAccTicketSale       AS tgt
        USING [Temp].temp1_FactAccTicketSale      AS src
          ON  tgt.StationKey      = src.StationKey
          AND tgt.SalesChannelKey = src.SalesChannelKey
        WHEN MATCHED THEN
             UPDATE SET
                 tgt.TotalTicketsSold = src.TotalTicketsSold,
                 tgt.TotalRevenue     = src.TotalRevenue
        WHEN NOT MATCHED BY TARGET THEN
             INSERT (StationKey, SalesChannelKey,
                     TotalTicketsSold, TotalRevenue)
             VALUES (src.StationKey, src.SalesChannelKey,
                     src.TotalTicketsSold, src.TotalRevenue);

        /* bookmark the finish line                                  */
        TRUNCATE TABLE [Financial].TimeFactAccTicketSale;
        INSERT  INTO [Financial].TimeFactAccTicketSale ([Date])
        VALUES (@end_date);

    COMMIT TRAN;

    /*---------------------------------------------------------------*/
    /* 4.  End log                                                   */
    /*---------------------------------------------------------------*/
    SET @des       = N'Incremental load finished up to DateKey='
                   + CONVERT(NVARCHAR(8), @end_date, 112);
    SET @row_count = (SELECT COUNT(*) FROM [Financial].FactAccTicketSale);

    EXEC [Global].LogAction
         @TableName     = N'FactAccTicketSale',
         @RowsAffected  = @row_count,
         @SeverityLevel = 'INFO',
         @Description   = @des,
         @ProcedureName = N'Incremental_Fill_FactAccTicketSale';
END;
GO












