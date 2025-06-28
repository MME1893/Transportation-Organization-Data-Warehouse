USE TransitDW;
GO;

/*********************    DimJourneyStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_DimJourneyStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------------------------------------------
      0.  Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimJourneyStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimJourneyStatus (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimJourneyStatus';

    /*-----------------------------------------------------------------
      1.  MERGE  source → dimension
    -----------------------------------------------------------------*/
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  [Transport].DimJourneyStatus     AS tgt
    USING  TransitSA.dbo.SA_LkpJourneyStatus              AS src
          ON tgt.JourneyStatusID_BK = src.JourneyStatusID       -- match on BK
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
      THEN INSERT (JourneyStatusID_BK, StatusCode, Label_EN, Label_FA)
           VALUES (src.JourneyStatusID , src.StatusCode , src.Label_EN , src.Label_FA)
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
		SET @des = N'Rows inserted into DimJourneyStatus: '
                              + CAST(@rowsInserted AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimJourneyStatus',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimJourneyStatus';
	END

    IF @rowsUpdated > 0
	BEGIN
		SET @des = N'Rows updated in DimJourneyStatus: '
                              + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimJourneyStatus',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimJourneyStatus';
	END

    /*-----------------------------------------------------------------
      3.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimJourneyStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimJourneyStatus';
END;
GO


/*********************    DimRouteStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_DimRouteStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimRouteStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimRouteStatus (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimRouteStatus';

    /*-------------------------------------------------------------*/
    /* 1.  MERGE source → dimension                                */
    /*-------------------------------------------------------------*/
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  Transport.DimRouteStatus               AS tgt
    USING  TransitSA.dbo.SA_LkpRouteStatus            AS src
          ON tgt.RouteStatusID_BK = src.RouteStatusID        -- match on BK
    /*— update when ANY descriptive field differs —*/
    WHEN MATCHED AND
         (   ISNULL(tgt.StatusCode, N'') <> ISNULL(src.StatusCode, N'')
          OR ISNULL(tgt.Label_EN , N'')  <> ISNULL(src.Label_EN , N'')
          OR ISNULL(tgt.Label_FA , N'')  <> ISNULL(src.Label_FA , N'') )
      THEN UPDATE SET
           tgt.StatusCode = src.StatusCode,
           tgt.Label_EN   = src.Label_EN,
           tgt.Label_FA   = src.Label_FA
    /*— insert brand-new route-status codes —*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (RouteStatusID_BK, StatusCode, Label_EN, Label_FA)
           VALUES (src.RouteStatusID , src.StatusCode , src.Label_EN , src.Label_FA)
    /*— keep rows missing from source (no delete clause) —*/
    OUTPUT $action INTO @mergeLog(action);

    /*-------------------------------------------------------------*/
    /* 2.  Per-action logging                                      */
    /*-------------------------------------------------------------*/
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@des varchar(MAX);


		IF @rowsInserted > 0
		BEGIN
			SET @des = N'Rows inserted into DimJourneyStatus: '
			 					  + CAST(@rowsInserted AS NVARCHAR(10));
	        EXEC [Global].LogAction
             @TableName     = N'DimRouteStatus',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimRouteStatus';
		END

		IF @rowsUpdated > 0
		BEGIN
		SET @des = N'Rows updated in DimJourneyStatus: '
								  + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimRouteStatus',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimRouteStatus';
		END


    /*-------------------------------------------------------------*/
    /* 3.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimRouteStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimRouteStatus';
END;
GO


/*********************    DimDevice Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_DimDevice
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------------------------------------------
      0.  Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimDevice',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimDevice (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimDevice';

    /*-----------------------------------------------------------------
      1.  MERGE source snapshot → dimension
    -----------------------------------------------------------------*/
    DECLARE @mergeLog TABLE (action NVARCHAR(10));

    ;WITH src AS
    (
        SELECT  pd.DeviceID               AS DeviceID_BK,
                pd.DeviceCode,
                pd.DeviceTypeID,
                dt.TypeCode,   dt.Label_EN  AS Type_EN,  dt.Label_FA  AS Type_FA,
                pd.DeviceStatusID,
                ds.StatusCode, ds.Label_EN AS Status_EN, ds.Label_FA AS Status_FA,
                pd.InstallDate,
                pd.SerialNo,
                pd.FirmwareVersion,
                pd.LastServiceDT,
                pd.IPAddress
        FROM        TransitSA.dbo.SA_PaymentDevice     AS pd
        LEFT JOIN   TransitSA.dbo.SA_LkpDeviceType     AS dt ON dt.DeviceTypeID   = pd.DeviceTypeID
        LEFT JOIN   TransitSA.dbo.SA_LkpDeviceStatus   AS ds ON ds.DeviceStatusID = pd.DeviceStatusID
    )
    MERGE  Transport.DimDevice  AS tgt
    USING  src        AS s
          ON  tgt.DeviceID_BK = s.DeviceID_BK
    /*----------- UPDATE when any attribute differs ------------------*/
    WHEN MATCHED AND (
           ISNULL(tgt.DeviceCode      , N'') <> ISNULL(s.DeviceCode     , N'')
        OR ISNULL(tgt.DeviceTypeID    , 0  ) <> ISNULL(s.DeviceTypeID   , 0  )
        OR ISNULL(tgt.TypeCode        , N'') <> ISNULL(s.TypeCode       , N'')
        OR ISNULL(tgt.Type_EN         , N'') <> ISNULL(s.Type_EN        , N'')
        OR ISNULL(tgt.Type_FA         , N'') <> ISNULL(s.Type_FA        , N'')
        OR ISNULL(tgt.DeviceStatusID  , 0  ) <> ISNULL(s.DeviceStatusID , 0  )
        OR ISNULL(tgt.StatusCode      , N'') <> ISNULL(s.StatusCode     , N'')
        OR ISNULL(tgt.Status_EN       , N'') <> ISNULL(s.Status_EN      , N'')
        OR ISNULL(tgt.Status_FA       , N'') <> ISNULL(s.Status_FA      , N'')
        OR ISNULL(tgt.InstallDate     , '1900-01-01') <> ISNULL(s.InstallDate    , '1900-01-01')
        OR ISNULL(tgt.SerialNo        , N'') <> ISNULL(s.SerialNo       , N'')
        OR ISNULL(tgt.FirmwareVersion , N'') <> ISNULL(s.FirmwareVersion, N'')
        OR ISNULL(tgt.LastServiceDT   , '1900-01-01') <> ISNULL(s.LastServiceDT  , '1900-01-01')
        OR ISNULL(tgt.IPAddress       , N'') <> ISNULL(s.IPAddress      , N'')
        )
      THEN UPDATE SET
           tgt.DeviceCode      = s.DeviceCode,
           tgt.DeviceTypeID    = s.DeviceTypeID,
           tgt.TypeCode        = s.TypeCode,
           tgt.Type_EN         = s.Type_EN,
           tgt.Type_FA         = s.Type_FA,
           tgt.DeviceStatusID  = s.DeviceStatusID,
           tgt.StatusCode      = s.StatusCode,
           tgt.Status_EN       = s.Status_EN,
           tgt.Status_FA       = s.Status_FA,
           tgt.InstallDate     = s.InstallDate,
           tgt.SerialNo        = s.SerialNo,
           tgt.FirmwareVersion = s.FirmwareVersion,
           tgt.LastServiceDT   = s.LastServiceDT,
           tgt.IPAddress       = s.IPAddress
    /*----------- INSERT brand-new devices ---------------------------*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT ( DeviceID_BK, DeviceCode,
                    DeviceTypeID, TypeCode, Type_EN, Type_FA,
                    DeviceStatusID, StatusCode, Status_EN, Status_FA,
                    InstallDate, SerialNo, FirmwareVersion,
                    LastServiceDT, IPAddress)
           VALUES ( s.DeviceID_BK, s.DeviceCode,
                    s.DeviceTypeID, s.TypeCode, s.Type_EN, s.Type_FA,
                    s.DeviceStatusID, s.StatusCode, s.Status_EN, s.Status_FA,
                    s.InstallDate, s.SerialNo, s.FirmwareVersion,
                    s.LastServiceDT, s.IPAddress )
    /*----------- keep rows missing from source ---------------------*/
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
			SET @des = N'Rows inserted into DimDevice: '
			 					  + CAST(@rowsInserted AS NVARCHAR(10));
	        EXEC [Global].LogAction
             @TableName     = N'DimDevice',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimDevice';
		END

		IF @rowsUpdated > 0
		BEGIN
		SET @des = N'Rows updated in DimDevice: '
								  + CAST(@rowsUpdated  AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimDevice',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'Incrementally_Fill_DimDevice';
		END


    /*-----------------------------------------------------------------
      3.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimDevice',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimDevice';
END;
GO

/*****************************************************************/
/*****************************************************************/
/**********************       Facts        ***********************/
/*****************************************************************/
/*****************************************************************/

/*********************    FactTrnsCardTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactTrnsTap
AS 
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTap is not empty           */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM Transport.FactTrnsTap)
		BEGIN
			RAISERROR(N'FactTrnsTap does not contain data. Aborting incrementally load.',16,1);
			RETURN;
		END

		
		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactTrnsTap',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting Incrementally load of FactTrnsTap',
			 @ProcedureName = N'Incrementally_Fill_FactTrnsTap';

		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactTrnsTap;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = MAX(TxnDT) FROM TransitSA.dbo.SA_PaymentTxn;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from SA_PaymentTxn' , 16 , 1);
			RETURN;
		END
		

		WHILE @current_date <= @end_date
					BEGIN 
				INSERT INTO Transport.FactTrnsTap
				( 
					DateKey, TimeKey, StationKey, RouteKey,
					PaymentMethodKey, DeviceKey, FareAmount
				)
				SELECT 
					  CAST(CONVERT(VARCHAR(8), p.TxnDT, 112) AS INT) AS DateKey, 
					  --YEAR(p.TxnDT)*10000 + MONTH(p.TxnDT)*100 + DAY(p.TxnDT) ) AS DateKey,
					  DATEPART(HOUR,p.TxnDT)   * 100 + DATEPART(MINUTE,p.TxnDT) AS TimeKey,
					  p.StationID,
					  p.RouteID,
					  p.PaymentMethodID,
					  p.DeviceID,
					  p.FareAmount
				FROM   TransitSA.dbo.SA_PaymentTxn                  AS p
				--LEFT JOIN Global.DimStation         AS s  ON s.StationID_BK       = p.StationID
				--LEFT JOIN Global.DimRoute           AS r  ON r.RouteID_BK         = p.RouteID
				--LEFT JOIN Global.DimPaymentMethod   AS pm ON pm.PaymentMethodID_BK = p.PaymentMethodID
				--LEFT JOIN Transport.DimDevice          AS dv ON dv.DeviceID_BK       = p.DeviceID
				WHERE P.TxnDT >= CAST(@current_date AS DATETIME ) AND P.TxnDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) 

				SET @rows = @@ROWCOUNT;
				SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						  + N' rows in date ' +  CONVERT(NVARCHAR(9),@current_date, 112)   
						  + N' ).';
				EXEC [Global].LogAction
					 @TableName     = N'FactTrnsTap',
					 @RowsAffected  = @rows,
					 @SeverityLevel = 'INFO',
					 @Description   = @desc,
					 @ProcedureName = N'Incrementally_Fill_FactTrnsTap';

				SET @current_date = DATEADD(DAY, 1 ,@current_date);
			END
		EXEC [Global].LogAction
         @TableName     = N'FactTrnsTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed Incrementally  load of FactTrnsTap',
         @ProcedureName = N'Incrementally_Fill_FactTrnsTap';


	END;
GO;


/*********************    FactDailyTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_FactDailyTap
AS  
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyTap is not empty                  */
		/*-------------------------------------------------------------*/
		IF NOT EXISTS (SELECT 1 FROM Transport.FactDailyTap)
		BEGIN
			RAISERROR(N'FactDailyTap does not contain data. Aborting incrementally load.',16,1);
			RETURN;
		END

		
		DECLARE
			@rows        INT,
			@desc        NVARCHAR(MAX);
		/*-------------------------------------------------------------*/
		/* 1.  Start-of-run audit                                      */
		/*-------------------------------------------------------------*/
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyTap',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting Incrementally load of FactDailyTap',
			 @ProcedureName = N'Incrementally_FactDailyTap';

		
		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactDailyTap;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )  FROM Transport.FactTrnsTap;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactTrnsTap' , 16 , 1);
			RETURN;
		END
		
		TRUNCATE TABLE Temp.temp1_cross_RouteStation_PaymentMethodType;
		INSERT INTO Temp.temp1_cross_RouteStation_PaymentMethodType
		(StationKey, RouteKey , PaymentMethodKey )
		SELECT StationKey ,RouteKey , PaymentMethodID_BK
		FROM Global.DimPaymentMethod
		CROSS JOIN 
		(
			SELECT F.StationKey, F.RouteKey
			FROM Transport.FactlessRouteStation f
			GROUP BY F.StationKey, F.RouteKey
		) as F


		WHILE @current_date <= @end_date
			BEGIN 

				INSERT INTO Transport.FactDailyTap
				(
					DateKey, StationKey, RouteKey, PaymentMethodKey,
					TotalBoardings, TotalRevenue 
			)
			SELECT 
				CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112)) AS DateKey,
				T.StationKey,
				T.RouteKey,
				T.PaymentMethodKey,
				COUNT(CASE WHEN P.StationKey IS NOT NULL THEN 1 END) AS TotalBoardings,
				SUM(CASE WHEN P.StationKey IS NOT NULL THEN P.FareAmount ELSE 0 END) AS TotalRevenue
			FROM 
				Temp.temp1_cross_RouteStation_PaymentMethodType AS T
			LEFT JOIN 
				[Transport].FactTrnsTap AS P
				ON P.StationKey = T.StationKey 
				   AND P.RouteKey = T.RouteKey 
				   AND P.PaymentMethodKey = T.PaymentMethodKey
				   AND P.DateKey = CONVERT(INT, CONVERT(VARCHAR(8), @current_date, 112))
			GROUP BY 
				T.StationKey,
				T.RouteKey,
				T.PaymentMethodKey;

				

				SET @rows = @@ROWCOUNT;
				SET @desc = N'Inserted ' + CAST(@rows AS NVARCHAR(20))
						  + N' rows in date ' + CONVERT(NVARCHAR(9),@current_date, 112)  
						  + N' ).';
				EXEC [Global].LogAction
					 @TableName     = N'FactDailyTap',
					 @RowsAffected  = @rows,
					 @SeverityLevel = 'INFO',
					 @Description   = @desc,
					 @ProcedureName = N'Incrementally_FactDailyTap';

				SET @current_date = DATEADD(DAY, 1 ,@current_date);


			END

		EXEC [Global].LogAction
         @TableName     = N'FactDailyTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactDailyTap',
         @ProcedureName = N'Incrementally_FactDailyTap';


	END;
GO;


/*********************    FactAccTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactAccTap
AS
BEGIN
    SET NOCOUNT ON;
    

    ------------------------------------------------------------------
    -- 0.  Start-of-run logging
    ------------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'FactAccTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting accumulator load (Incrementally_Fill_FactAccTap)',
         @ProcedureName = N'Incrementally_Fill_FactAccTap';


	IF NOT EXISTS ( SELECT 1 FROM Transport.FactAccTap ) OR NOT EXISTS ( SELECT 1 FROM Transport.TimeAccFactTap )
	BEGIN 
		 EXEC [Global].LogAction
         @TableName     = N'FactAccTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FAILD, NO DATA IN FactAccTap or TimeAccFactTap',
         @ProcedureName = N'Incrementally_Fill_FactAccTap';

		 RETURN;
	END
    ------------------------------------------------------------------
    -- 1.  Date range discovery
    ------------------------------------------------------------------
    DECLARE @current_day DATE,
            @end_date    DATE;

    SELECT  @current_day = CONVERT(DATE,CAST(MIN(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ),
            @end_date    = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )
    FROM    [Transport].FactDailyTap;

    /* resume from the last bookmark if it exists */
    SELECT @current_day =
           ISNULL(
               (SELECT DATEADD(DAY, 1, MAX([Date]) ) FROM [Transport].TimeAccFactTap),
               @current_day
           );
     
    /* nothing to do? */
    IF @current_day IS NULL OR @current_day > @end_date
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccTap',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'No new days to process – exiting.',
             @ProcedureName = N'Incrementally_Fill_FactAccTap';
        RETURN;
    END

	TRUNCATE TABLE Temp.temp1_FactAccTap;
	TRUNCATE TABLE Temp.temp2_FactAccTap;
	TRUNCATE TABLE Temp.temp3_FactAccTap;

    INSERT INTO   [Temp].temp1_FactAccTap
	(
			StationKey, RouteKey, PaymentMethodKey,
            TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
	)
    SELECT 
		StationKey, RouteKey, PaymentMethodKey,
        TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
		FROM [Transport].FactAccTap;   -- yesterday’s running total 


    ------------------------------------------------------------------
    -- 2.  Main day-by-day loop
    ------------------------------------------------------------------
    WHILE @current_day <= @end_date
    BEGIN
        /*--------------------------------------------*
         * 2-A  load previous cumulative into tmp2    *
         *--------------------------------------------*/
        TRUNCATE TABLE [Temp].temp2_FactAccTap 
        INSERT INTO   [Temp].temp2_FactAccTap
		(
			 StationKey, RouteKey, PaymentMethodKey,
             TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
		)
        SELECT 
			StationKey, RouteKey, PaymentMethodKey,
            TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
			FROM [Temp].temp1_FactAccTap;   -- yesterday’s running total 

        /*--------------------------------------------*
         * 2-B  load today’s daily rows into tmp2     *
         *--------------------------------------------*/
        TRUNCATE TABLE [Temp].temp3_FactAccTap;
        INSERT INTO   [Temp].temp3_FactAccTap
               ( StationKey, RouteKey, PaymentMethodKey,
                 TotalBoardings, TotalRevenue,
                 MaxRevenue, MinRevenue )
        SELECT  StationKey,
                RouteKey,
                PaymentMethodKey,
                TotalBoardings,
                TotalRevenue,
                TotalRevenue    AS MaxRevenue,   -- daily max = total for that day
                TotalRevenue    AS MinRevenue
        FROM    [Transport].FactDailyTap
        WHERE   DateKey = CAST(CONVERT(char(8), @current_day, 112) AS INT);--@current_day

        /*--------------------------------------------*
         * 2-C  combine tmp2 + tmp3  → tmp1_acc        *
         *--------------------------------------------*/
        TRUNCATE TABLE [Temp].temp1_FactAccTap;

        INSERT INTO [Temp].temp1_FactAccTap
               ( StationKey, RouteKey, PaymentMethodKey,
                 TotalBoardings, TotalRevenue,
                 MaxRevenue, MinRevenue )
        SELECT
               COALESCE(t2.StationKey , t1.StationKey)   AS StationKey,
               COALESCE(t2.RouteKey   , t1.RouteKey)     AS RouteKey,
               COALESCE(t2.PaymentMethodKey, t1.PaymentMethodKey) AS PaymentMethodKey,
               ISNULL(t1.TotalBoardings,0) + ISNULL(t2.TotalBoardings,0)              AS TotalBoardings,
               ISNULL(t1.TotalRevenue ,0) + ISNULL(t2.TotalRevenue ,0)               AS TotalRevenue,
               CASE WHEN ISNULL(t1.MaxRevenue,0) > ISNULL(t2.MaxRevenue,0)
                        THEN t1.MaxRevenue ELSE t2.MaxRevenue END                    AS MaxRevenue,
               CASE WHEN ISNULL(t1.MinRevenue,0)=0 THEN ISNULL(t2.MinRevenue,0)
                    WHEN ISNULL(t2.MinRevenue,0)=0 THEN ISNULL(t1.MinRevenue,0)
                    WHEN t1.MinRevenue < t2.MinRevenue THEN t1.MinRevenue
                    ELSE t2.MinRevenue END                                           AS MinRevenue
        FROM   [Temp].temp2_FactAccTap t1
        FULL   OUTER JOIN [Temp].temp3_FactAccTap t2
               ON  t1.StationKey       = t2.StationKey
               AND t1.RouteKey         = t2.RouteKey
               AND t1.PaymentMethodKey = t2.PaymentMethodKey;

        /*--------------------------------------------*
         * 2-D  advance to next day                   *
         *--------------------------------------------*/
        SET @current_day = DATEADD(DAY, 1, @current_day);

    END  /* WHILE loop */

    ------------------------------------------------------------------
    -- 3.  Swap into real accumulator & bookmark end date
    ------------------------------------------------------------------
	BEGIN TRAN;

		------------------------------------------------------------
		-- 1) Populate staging with “upsert” logic via FULL JOIN
		------------------------------------------------------------
		TRUNCATE TABLE Temp.Staging_FactAccTap;

		INSERT INTO Temp.Staging_FactAccTap
		(
		  StationKey,
		  RouteKey,
		  PaymentMethodKey,
		  TotalBoardings,
		  TotalRevenue,
		  MaxRevenue,
		  MinRevenue
		)
		SELECT
		  COALESCE(old.StationKey, n.StationKey)        AS StationKey,
		  COALESCE(old.RouteKey,   n.RouteKey)          AS RouteKey,
		  COALESCE(old.PaymentMethodKey, n.PaymentMethodKey) AS PaymentMethodKey,

		  /* add old + new boardings & revenue */
		  ISNULL(old.TotalBoardings,0) + ISNULL(n.TotalBoardings,0) AS TotalBoardings,
		  ISNULL(old.TotalRevenue,  0) + ISNULL(n.TotalRevenue,  0) AS TotalRevenue,

		  /* pick the higher of old vs new for MaxRevenue */
		  CASE
			WHEN old.MaxRevenue IS NULL THEN n.MaxRevenue
			WHEN n.MaxRevenue   IS NULL THEN old.MaxRevenue
			WHEN old.MaxRevenue > n.MaxRevenue THEN old.MaxRevenue
			ELSE n.MaxRevenue
		  END AS MaxRevenue,

		  /* pick the lower of old vs new for MinRevenue */
		  CASE
			WHEN old.MinRevenue IS NULL THEN n.MinRevenue
			WHEN n.MinRevenue   IS NULL THEN old.MinRevenue
			WHEN old.MinRevenue < n.MinRevenue THEN old.MinRevenue
			ELSE n.MinRevenue
		  END AS MinRevenue
		FROM Transport.FactAccTap        AS old
		FULL OUTER JOIN Temp.temp1_FactAccTap AS n
		  ON old.StationKey        = n.StationKey
		 AND old.RouteKey          = n.RouteKey
		 AND old.PaymentMethodKey  = n.PaymentMethodKey;


		------------------------------------------------------------
		-- 2) Swap in the new cumulative results
		------------------------------------------------------------
		TRUNCATE TABLE Transport.FactAccTap;

		INSERT INTO Transport.FactAccTap
		(
		  StationKey,
		  RouteKey,
		  PaymentMethodKey,
		  TotalBoardings,
		  TotalRevenue,
		  MaxRevenue,
		  MinRevenue
		)
		SELECT
		  StationKey,
		  RouteKey,
		  PaymentMethodKey,
		  TotalBoardings,
		  TotalRevenue,
		  MaxRevenue,
		  MinRevenue
		FROM Temp.Staging_FactAccTap;


		------------------------------------------------------------
		-- 3) Advance the bookmark
		------------------------------------------------------------
		TRUNCATE TABLE Transport.TimeAccFactTap;

		INSERT INTO Transport.TimeAccFactTap ([Date])
		VALUES (@end_date);

	COMMIT TRAN;


    ------------------------------------------------------------------
    -- 4.  End-of-run audit
    ------------------------------------------------------------------
	DECLARE @des NVARCHAR(MAX) = N'Accumulator load complete up to DateKey=' + CAST(@end_date AS NVARCHAR(8)), @row_count INT = (SELECT COUNT(*) FROM [Temp].temp1_FactAccTap);
    EXEC [Global].LogAction
         @TableName     = N'AccFactTap',
         @RowsAffected  = @row_count,
         @SeverityLevel = 'INFO',
         @Description   = @des,
         @ProcedureName = N'Incrementally_Fill_AccFactTap';
END;
GO





/*********************    FactTrnsArrival Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactTrnsArrival
AS
BEGIN
    SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM [Transport].FactTrnsArrival)
    BEGIN
        RAISERROR (N'FactTrnsArrival does not contain data. Aborting incrementally load',16,1);
        RETURN;
    END


   
    EXEC [Global].LogAction
         @TableName     = N'FactTrnsArrival',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally load of FactTrnsArrival (day-by-day)',
         @ProcedureName = N'Incrementally_Fill_FactTrnsArrival';

   
    DECLARE @current_date  DATE,
            @end_date     DATE,
            @rowsToday   INT,
            @msg         NVARCHAR(200);

	SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactTrnsArrival;
	SET		@current_date  = DATEADD(DAY, 1 , @current_date);

	SELECT	@end_date	   =  CAST(MAX(ActualArrivalDT) AS DATE) FROM TransitSA.dbo.SA_ArrivalEvent;

	IF @end_date IS NULL 
	BEGIN
		RAISERROR('No End date from SA_Journey' , 16 , 1);
		RETURN;
	END

    IF @current_date IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactTrnsArrival',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'SA_Journey is empty – nothing to load.',
             @ProcedureName = N'Incrementally_Fill_FactTrnsArrival';
        RETURN;
    END

  
    WHILE @current_date <= @end_date
    BEGIN

        INSERT INTO [Transport].FactTrnsArrival
               ( JourneyID_BK, StationKey, DateKey,
                PlannedStartTK, ActualStartTK, PlannedEndTK, ActualEndTK,
                VehicleKey, RouteKey, DriverKey, JourneyStatusKey,
                DistanceKM, PassengerCount,
                CardBoarded, TicketBoarded, BoardedCnt, AlightedCnt, DelaySeconds)
        SELECT 
				j.JourneyID,
				a.StationID,
				CAST(CONVERT(VARCHAR(8), j.ActualStartDT, 112) AS INT) AS DateKey,
				CAST(DATEPART(HOUR, j.PlannedStartDT) * 100 + DATEPART(MINUTE, j.PlannedStartDT) AS SMALLINT) as PlaPlannedStartTK,
				CAST(DATEPART(HOUR, j.ActualStartDT) * 100 + DATEPART(MINUTE, j.ActualStartDT) AS SMALLINT) as PlaPlannedStartTK,
				CAST(DATEPART(HOUR, j.PlannedEndDT) * 100 + DATEPART(MINUTE, j.PlannedEndDT) AS SMALLINT) as PlaPlannedStartTK,
				CAST(DATEPART(HOUR, j.ActualEndDT) * 100 + DATEPART(MINUTE, j.ActualEndDT) AS SMALLINT) as PlaPlannedStartTK,
				j.VehicleID as VehicleKey,
				j.RouteID as RouteKey,
				j.DriverEmpID as DriverKey,
				js.JourneyStatusID as JourneyStatusKey,
				j.DistanceKM as DistanceKM,
				j.PassengerCount as PassengerCount,
				a.CardBoarded ,
				a.TicketBoarded,
				a.BoardedCnt,
				a.AlightedCnt,
				DATEDIFF(SECOND, a.ActualArrivalDT, a.ActualDepartureDT) AS DifferenceInSeconds

		FROM   TransitSA.dbo.SA_Journey            AS j
		LEFT   JOIN TransitSA.dbo.SA_ArrivalEvent      AS a ON J.JourneyID = A.JourneyID
		LEFT   JOIN TransitSA.dbo.SA_JourneyStatusEvent           AS js ON js.JourneyID = j.JourneyID
		WHERE		
					j.ActualStartDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) AND j.ActualStartDT >= CAST( @current_date AS DATETIME )
				AND 
					a.ActualArrivalDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) AND a.ActualArrivalDT  >= CAST( @current_date AS DATETIME )
				AND 
					js.StatusDT < CAST( (DATEADD(DAY,1,@current_date)) AS DATETIME) AND js.StatusDT  >= CAST( @current_date AS DATETIME );


        SET @msg = N'Loaded ' + CAST(@rowsToday AS NVARCHAR(20))
                 + N' rows for date ' + CONVERT(char(10), @current_date, 120);

        EXEC [Global].LogAction
             @TableName     = N'FactTrnsArrival',
             @RowsAffected  = @@ROWCOUNT,
             @SeverityLevel = 'INFO',
             @Description   = @msg,
             @ProcedureName = N'Incrementally_Fill_FactTrnsArrival';


        SET @current_date = DATEADD(DAY, 1, @current_date);
    END  /* WHILE */


	SET @msg = N'Incrementally load complete up to ' + CONVERT(char(10), @end_date, 120);
	SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactTrnsArrival)
		;
    EXEC [Global].LogAction
         @TableName     = N'FactTrnsArrival',
         @RowsAffected  = @rowsToday,
         @SeverityLevel = 'INFO',
         @Description   = @msg,
         @ProcedureName = N'Incrementally_Fill_FactTrnsArrival';
END;
GO;


/*********************    FactAccJourney Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactAccJourney
AS
BEGIN

	SET NOCOUNT ON;


    IF NOT EXISTS (SELECT 1 FROM [Transport].FactAccJourney)
    BEGIN
        RAISERROR (N'FactAccJourney does not contain data. Aborting incrementally load',16,1);
        RETURN;
    END


   
    EXEC [Global].LogAction
         @TableName     = N'FactAccJourney',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally load of FactAccJourney (day-by-day)',
         @ProcedureName = N'Incrementally_Fill_FactAccJourney';

   
    DECLARE @current_date  DATE,
            @end_date     DATE,
            @rowsToday   INT,
            @msg         NVARCHAR(200);

	SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactAccJourney;
	SET		@current_date  = DATEADD(DAY, 1 , @current_date);

	SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactTrnsArrival;

	IF @end_date IS NULL 
	BEGIN
		RAISERROR('No End date from FactTrnsArrival' , 16 , 1);
		RETURN;
	END

    IF @current_date IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccJourney',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactAccJourney is empty – nothing to load.',
             @ProcedureName = N'Incrementally_Fill_FactAccJourney';
        RETURN;
    END


	WHILE @current_date <= @end_date
	BEGIN 
		INSERT INTO Transport.FactAccJourney
		(
			JourneyID_BK, DateKey, VehicleKey, RouteKey, DriverKey, 
            TotalPassengers, MaxPassengers, AvgPassengers, 
            TotalDelay, DistanceKM
		)
		SELECT 
			f.JourneyID_BK,
			f.DateKey,
			f.VehicleKey,
			f.RouteKey,
			f.DriverKey,
			SUM(f.PassengerCount),
			MAX(f.PassengerCount),
			CAST(SUM(f.PassengerCount) / COUNT(f.PassengerCount) AS INT),
			SUM(f.DelaySeconds),
			F.DistanceKM
		FROM [Transport].FactTrnsArrival f
		WHERE f.DateKey = CONVERT(INT,CONVERT(VARCHAR(8) , @current_date , 112))
		GROUP BY 
				f.JourneyID_BK,
				f.VehicleKey,
				f.DateKey,
				f.DriverKey,
				f.RouteKey,
				f.DistanceKM


        SET @msg = N'Loaded ' + CAST(@@ROWCOUNT AS NVARCHAR(20))
                 + N' rows for date ' + CONVERT(char(10), @current_date, 120);

        EXEC [Global].LogAction
             @TableName     = N'FactAccJourney',
             @RowsAffected  = @@ROWCOUNT,
             @SeverityLevel = 'INFO',
             @Description   = @msg,
             @ProcedureName = N'Incrementally_Fill_FactAccJourney';


		SET @current_date = DATEADD(DAY, 1, @current_date);

	END

	SET @msg = N'FIRST load complete up to ' + CONVERT(char(10), @end_date, 120);
	SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactAccJourney);
    EXEC [Global].LogAction
         @TableName     = N'FactAccJourney',
         @RowsAffected  = @rowsToday,
         @SeverityLevel = 'INFO',
         @Description   = @msg,
         @ProcedureName = N'Incrementally_Fill_FactAccJourney';
END
GO;


/*********************    FactDailyVehicleStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactDailyVehicleStatus
	@option INT = 0 
AS
BEGIN
	
		SET NOCOUNT ON;


		IF NOT EXISTS (SELECT 1 FROM [Transport].FactDailyVehicleStatus)
		BEGIN
			RAISERROR (N'FactDailyVehicleStatus does not contain data. Aborting incrementally load',16,1);
			RETURN;
		END


   
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyVehicleStatus',
			 @RowsAffected  = 0,
			 @SeverityLevel = 'INFO',
			 @Description   = N'Starting Incrementally load of FactAccJourney (day-by-day)',
			 @ProcedureName = N'Incrementally_Fill_FactDailyVehicleStatus';

   
		DECLARE @current_date  DATE,
				@end_date     DATE,
				@rowsToday   INT,
				@msg         NVARCHAR(200);

		SELECT	@current_date  = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactDailyVehicleStatus;
		SET		@current_date  = DATEADD(DAY, 1 , @current_date);

		SELECT	@end_date	   = CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ ) FROM Transport.FactTrnsArrival;

		IF @end_date IS NULL 
		BEGIN
			RAISERROR('No End date from FactDailyVehicleStatus' , 16 , 1);
			RETURN;
		END

		IF @current_date IS NULL
		BEGIN
			EXEC [Global].LogAction
				 @TableName     = N'FactDailyVehicleStatus',
				 @RowsAffected  = 0,
				 @SeverityLevel = 'WARN',
				 @Description   = N'FactDailyVehicleStatus is empty – nothing to load.',
				 @ProcedureName = N'Incrementally_Fill_FactDailyVehicleStatus';
			RETURN;
		END
		WHILE @current_date <= @end_date
		BEGIN 
			INSERT INTO [Transport].FactDailyVehicleStatus
			(
				DateKey,
				VehicleKey,
				ActiveHours,
				TotalPassengers
			)
			SELECT 
				ISNULL(f.DateKey, CONVERT(INT,CONVERT(VARCHAR(8) , @current_date , 112))) AS DateKey,
				ISNULL(f.VehicleKey, v.VehicleID_SK) AS VehicleKey,
				SUM(
					CASE 
						WHEN f.ActualEndTK IS NULL OR f.ActualStartTK IS NULL THEN 0
						ELSE 
							CAST(FLOOR(f.ActualEndTK / 100) AS DECIMAL(6,2)) + 
							CAST((f.ActualEndTK % 100) / 60.0 AS DECIMAL(6,2)) - 
							CAST(FLOOR(f.ActualStartTK / 100) AS DECIMAL(6,2)) - 
							CAST((f.ActualStartTK % 100) / 60.0 AS DECIMAL(6,2))
					END
				) AS ActiveHours,
				SUM(ISNULL(PassengerCount, 0)) AS TotalPassengers
				FROM 
				(
					SELECT * FROM Transport.FactTrnsArrival
					WHERE DateKey	= CONVERT(INT,CONVERT(VARCHAR(8) , @current_date , 112))
				) AS f
				RIGHT JOIN
					( 
						select * from Global.DimVehicle where IsCurrent = 1
					) as v			
				ON f.VehicleKey = v.VehicleID_SK           
				GROUP BY ISNULL(f.VehicleKey,v.VehicleID_SK),
						 ISNULL(f.DateKey, CONVERT(INT,CONVERT(VARCHAR(8) , @current_date , 112)))
				
				SET @msg = N'Loaded ' + CAST(@@ROWCOUNT AS NVARCHAR(20))
						 + N' rows for date ' + CONVERT(char(10), @current_date, 120);

				EXEC [Global].LogAction
					 @TableName     = N'FactDailyVehicleStatus',
					 @RowsAffected  = @@ROWCOUNT,
					 @SeverityLevel = 'INFO',
					 @Description   = @msg,
					 @ProcedureName = N'Incrementally_Fill_FactDailyVehicleStatus';

     			SET @current_date = DATEADD(DAY , 1 , @current_date);

		END

		SET @msg = N'FIRST load complete up to ' + CONVERT(char(10), @end_date, 120);
		SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactAccJourney);
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyVehicleStatus',
			 @RowsAffected  = @rowsToday,
			 @SeverityLevel = 'INFO',
			 @Description   = @msg,
			 @ProcedureName = N'Incrementally_Fill_FactDailyVehicleStatus';
END
GO;


/*********************    FactlessRouteStation Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].Incrementally_Fill_FactlessRouteStation
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0. Start-of-run audit                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load (MERGE) of FactlessRouteStation',
         @ProcedureName = N'First_Fill_FactlessRouteStation';

    /*-------------------------------------------------------------*/
    /* 1. Merge new Route-Station pairs                            */
    /*    (Keep existing rows, insert only new ones)               */
    /*-------------------------------------------------------------*/
    MERGE Transport.FactlessRouteStation AS Target
    USING (
        SELECT RouteID AS RouteKey, StationID AS StationKey, SeqNo
        FROM TransitSA.dbo.SA_RouteStation
    ) AS Source
    ON Target.RouteKey = Source.RouteKey
       AND Target.StationKey = Source.StationKey

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (RouteKey, StationKey, SeqNo)
        VALUES (Source.RouteKey, Source.StationKey, Source.SeqNo);

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 2. Log rows inserted                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'MERGE complete – new rows inserted into FactlessRouteStation.',
         @ProcedureName = N'First_Fill_FactlessRouteStation';

    /*-------------------------------------------------------------*/
    /* 3. End-of-run audit                                         */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load (MERGE) procedure',
         @ProcedureName = N'First_Fill_FactlessRouteStation';
END;
GO
