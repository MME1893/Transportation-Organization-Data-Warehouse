USE TransitDW;
GO;


/*********************    DimJourneyStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_DimJourneyStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Safety: abort if table already has data                 */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM [Transport].DimJourneyStatus)
    BEGIN
        RAISERROR (N'DimJourneyStatus already contains data. Aborting first-load.',
                   16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimJourneyStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimJourneyStatus',
         @ProcedureName = N'First_Fill_DimJourneyStatus';

    /*-------------------------------------------------------------*/
    /* 2.  Truncate + bulk insert                                  */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE [Transport].DimJourneyStatus;     -- ensures table empty

    INSERT INTO [Transport].DimJourneyStatus
           (JourneyStatusID_BK, StatusCode, Label_EN, Label_FA)
    SELECT  JourneyStatusID,   StatusCode, Label_EN, Label_FA
    FROM   TransitSA.dbo.SA_LkpJourneyStatus;

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3.  Log rows inserted                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimJourneyStatus',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimJourneyStatus.',
         @ProcedureName = N'First_Fill_DimJourneyStatus';

    /*-------------------------------------------------------------*/
    /* 4.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimJourneyStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimJourneyStatus';
END;
GO;


/*********************    DimRouteStatus Table    *********************/
CREATE OR ALTER  PROCEDURE [Transport].First_Fill_DimRouteStatus
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0. Safety – run once only                                   */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM Transport.DimRouteStatus)
    BEGIN
        RAISERROR(N'DimRouteStatus already contains data. Aborting first load.',
                  16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1. Start-of-run audit                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimRouteStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimRouteStatus',
         @ProcedureName = N'First_Fill_DimRouteStatus';

    /*-------------------------------------------------------------*/
    /* 2. Truncate + bulk insert                                   */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE Transport.DimRouteStatus;      -- guarantees empty

    INSERT INTO Transport.DimRouteStatus
           (RouteStatusID_BK, StatusCode, Label_EN, Label_FA)
    SELECT RouteStatusID, StatusCode, Label_EN, Label_FA
    FROM   TransitSA.dbo.SA_LkpRouteStatus;           -- source lookup

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3. Log rows inserted                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimRouteStatus',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimRouteStatus.',
         @ProcedureName = N'First_Fill_DimRouteStatus';

    /*-------------------------------------------------------------*/
    /* 4. End-of-run audit                                         */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimRouteStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimRouteStatus';
END;
GO;


/*********************    DimDevice Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_DimDevice
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Safety – run only if DimDevice is empty                  */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM [Transport].DimDevice)
    BEGIN
        RAISERROR(N'DimDevice already contains data. Aborting first load.',16,1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1.  Start-of-run audit                                      */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimDevice',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of DimDevice',
         @ProcedureName = N'First_Fill_DimDevice';

    /*-------------------------------------------------------------*/
    /* 2.  Truncate & bulk insert                                  */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE [Transport].DimDevice;          -- guarantees empty (idempotent)

    INSERT INTO Transport.DimDevice
          ( DeviceID_BK,  DeviceCode,
            DeviceTypeID, TypeCode,   Type_EN,  Type_FA,
            DeviceStatusID, StatusCode, Status_EN, Status_FA,
            InstallDate, SerialNo, FirmwareVersion,
            LastServiceDT, IPAddress)
    SELECT  pd.DeviceID,   pd.DeviceCode,
            pd.DeviceTypeID,
            dt.TypeCode,   dt.Label_EN, dt.Label_FA,
            pd.DeviceStatusID,
            ds.StatusCode, ds.Label_EN, ds.Label_FA,
            pd.InstallDate,
            pd.SerialNo,
            pd.FirmwareVersion,
            pd.LastServiceDT,
            pd.IPAddress
    FROM        TransitSA.dbo.SA_PaymentDevice    AS pd
    LEFT JOIN   TransitSA.dbo.SA_LkpDeviceType    AS dt ON dt.DeviceTypeID   = pd.DeviceTypeID
    LEFT JOIN   TransitSA.dbo.SA_LkpDeviceStatus  AS ds ON ds.DeviceStatusID = pd.DeviceStatusID;

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3.  Log rows inserted                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimDevice',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into DimDevice.',
         @ProcedureName = N'First_Fill_DimDevice';

    /*-------------------------------------------------------------*/
    /* 4.  End-of-run audit                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimDevice',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_DimDevice';
END;
GO;




/*****************************************************************/
/*****************************************************************/
/**********************       Facts        ***********************/
/*****************************************************************/
/*****************************************************************/


/*********************    FactTrnsTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactTrnsTap
@option INT = 0
AS
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactTrnsTap is empty                  */
		/*-------------------------------------------------------------*/
		IF @option = 0 AND EXISTS (SELECT 1 FROM Transport.FactTrnsTap)
		BEGIN
			RAISERROR(N'FactTrnsTap already contains data. Aborting first load.',16,1);
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
			 @Description   = N'Starting FIRST load of FactTrnsTap ',
			 @ProcedureName = N'First_Fill_FactTrnsCardTap';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE Transport.FactTrnsTap;          -- guarantees empty (idempotent)

		DECLARE 
				@end_date     DATE,
				@current_date DATE;

		SELECT  @current_date = CAST(MIN(TxnDT) AS DATE) FROM TransitSA.dbo.SA_PaymentTxn --2025-01-01 06:03:20.000

		SELECT  @end_date	  = CAST(MAX(TxnDT)AS DATE) FROM TransitSA.dbo.SA_PaymentTxn ---2025-05-30 21:58:22.000
		
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
					 @ProcedureName = N'First_Fill_FactTrnsTap';

				SET @current_date = DATEADD(DAY, 1 ,@current_date);
			END

		EXEC [Global].LogAction
         @TableName     = N'FactTrnsTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactTrnsTap',
         @ProcedureName = N'First_Fill_FactTrnsTap';



	END;
Go;


/*********************    FactDailyTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactDailyTap
AS
	BEGIN
		SET NOCOUNT ON;

		/*-------------------------------------------------------------*/
		/* 0.  Safety – run only if FactDailyCardTap is empty                  */
		/*-------------------------------------------------------------*/
		IF EXISTS (SELECT 1 FROM Transport.FactDailyTap)
		BEGIN
			RAISERROR(N'FactDailyTap already contains data. Aborting first load.',16,1);
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
			 @Description   = N'Starting FIRST load of FactDailyTap',
			 @ProcedureName = N'First_Fill_FactDailyTap';

		/*-------------------------------------------------------------*/
		/* 2.  Truncate & bulk insert                                  */
		/*-------------------------------------------------------------*/
		TRUNCATE TABLE Transport.FactDailyTap;          -- guarantees empty (idempotent)

		DECLARE 
				@end_date     DATE,
				@current_date DATE;


		--CONVERT(DATE,CAST(MAX(DateKey) AS CHAR(8)) , 112 /*style 112 (ISO “YYYYMMDD”)*/ )

		SELECT @current_date = CONVERT(DATE, CAST(MIN(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM Transport.FactTrnsTap

		SELECT @end_date	 = CONVERT(DATE, CAST(MAX(DateKey) AS CHAR(8)) , 112 /* style 112 (ISO “YYYYMMDD”) */ ) FROM Transport.FactTrnsTap

		IF @current_date IS NULL OR @end_date IS NULL 
		BEGIN 
			RAISERROR(N'FactTrnsTap does not contain data. Aborting first load.',16,1);
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
					 @ProcedureName = N'First_Fill_FactDailyTap';

				SET @current_date = DATEADD(DAY, 1 ,@current_date);


			END

		EXEC [Global].LogAction
         @TableName     = N'FactDailyTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Completed FIRST load of FactDailyTap',
         @ProcedureName = N'First_Fill_FactDailyTap';


	END;
GO;


/*********************    FactAccTap Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactAccTap
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0.  Start log                                               */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactAccTap',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST (day-by-day) load of FactAccTap',
         @ProcedureName = N'First_Fill_FactAccTap';

    /*-------------------------------------------------------------*/
    /* 1.  Date range                                              */
    /*-------------------------------------------------------------*/
    DECLARE @currentDay INT, @endDay INT
          , @des NVARCHAR(MAX), @row_count INT;

    SELECT @currentDay = MIN(DateKey),
           @endDay     = MAX(DateKey)
    FROM   [Transport].FactDailyTap;

    IF @currentDay IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccTap',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactDailyTap is empty – aborting.',
             @ProcedureName = N'First_Fill_FactAccTap';
        RETURN;
    END

    TRUNCATE TABLE [Transport].FactAccTap;
    TRUNCATE TABLE [Transport].TimeAccFactTap;

    TRUNCATE TABLE [Temp].temp4_FactAccTap;
    TRUNCATE TABLE [Temp].temp5_FactAccTap;
    TRUNCATE TABLE [Temp].temp6_FactAccTap;

    /*-------------------------------------------------------------*/
    /* 2.  Loop through each day                                   */
    /*-------------------------------------------------------------*/
    WHILE @currentDay <= @endDay
    BEGIN
        -- Clear temp tables
        TRUNCATE TABLE [Temp].temp5_FactAccTap;
        TRUNCATE TABLE [Temp].temp6_FactAccTap;

        -- Copy previous accumulated data
        INSERT INTO [Temp].temp5_FactAccTap
            (StationKey, RouteKey, PaymentMethodKey,
             TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue)
        SELECT StationKey, RouteKey, PaymentMethodKey,
               TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
        FROM   [Temp].temp4_FactAccTap;

        -- Load today's data
        INSERT INTO [Temp].temp6_FactAccTap
            (StationKey, RouteKey, PaymentMethodKey,
             TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue)
        SELECT StationKey, RouteKey, PaymentMethodKey,
               TotalBoardings, TotalRevenue,
               TotalRevenue,   -- MaxRevenue
               TotalRevenue    -- MinRevenue
        FROM   [Transport].FactDailyTap
        WHERE  DateKey = @currentDay;

        -- Accumulate day + previous into temp4
        TRUNCATE TABLE [Temp].temp4_FactAccTap;
        INSERT INTO  [Temp].temp4_FactAccTap
               (StationKey, RouteKey, PaymentMethodKey,
                TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue)
        SELECT
            COALESCE(t6.StationKey , t5.StationKey) AS StationKey,
            COALESCE(t6.RouteKey   , t5.RouteKey) AS RouteKey,
            COALESCE(t6.PaymentMethodKey, t5.PaymentMethodKey) AS PaymentMethodKey,
            ISNULL(t5.TotalBoardings, 0) + ISNULL(t6.TotalBoardings, 0) AS TotalBoardings,
            ISNULL(t5.TotalRevenue , 0) + ISNULL(t6.TotalRevenue , 0) AS TotalRevenue,
            CASE WHEN ISNULL(t5.MaxRevenue, 0) > ISNULL(t6.MaxRevenue, 0)
                 THEN t5.MaxRevenue ELSE t6.MaxRevenue END AS MaxRevenue,
            CASE
                 WHEN ISNULL(t5.MinRevenue, 0) = 0 THEN ISNULL(t6.MinRevenue, 0)
                 WHEN ISNULL(t6.MinRevenue, 0) = 0 THEN ISNULL(t5.MinRevenue, 0)
                 WHEN t5.MinRevenue < t6.MinRevenue THEN t5.MinRevenue
                 ELSE t6.MinRevenue END AS MinRevenue
        FROM   [Temp].temp5_FactAccTap t5
        FULL OUTER JOIN [Temp].temp6_FactAccTap t6
               ON  t5.StationKey       = t6.StationKey
               AND t5.RouteKey         = t6.RouteKey
               AND t5.PaymentMethodKey = t6.PaymentMethodKey;

        -- Daily log
        SET @des = N'Processed DateKey=' + CAST(@currentDay AS NVARCHAR(8));
        SET @row_count = (SELECT COUNT(*) FROM [Temp].temp6_FactAccTap);

        EXEC [Global].LogAction
             @TableName     = N'FactAccTap',
             @RowsAffected  = @row_count,
             @SeverityLevel = 'INFO',
             @Description   = @des,
             @ProcedureName = N'First_Fill_FactAccTap';

        -- Bookmark the processed day
        --INSERT INTO [Transport].TimeAccFactTap ([Date])
        --VALUES (CONVERT(date, CAST(@currentDay AS char(8)), 112));

        -- Go to next day
        SET @currentDay = CONVERT(INT, CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATE, CAST(@currentDay AS CHAR(8)), 112)), 112));
    END

    /*-------------------------------------------------------------*/
    /* 3.  Final save into FactAccTap                              */
    /*-------------------------------------------------------------*/
    INSERT INTO [Transport].FactAccTap
        (StationKey, RouteKey, PaymentMethodKey,
         TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue)
    SELECT StationKey, RouteKey, PaymentMethodKey,
           TotalBoardings, TotalRevenue, MaxRevenue, MinRevenue
    FROM   [Temp].temp4_FactAccTap;

	
    TRUNCATE TABLE [Transport].TimeAccFactTap;
    INSERT INTO  [Transport].TimeAccFactTap ([Date])
    VALUES (CONVERT(DATE, CAST(@endDay AS CHAR(8)), 112) );
    /*-------------------------------------------------------------*/
    /* 4.  End log                                                 */
    /*-------------------------------------------------------------*/
    SET @des = N'FIRST load finished up to DateKey=' + CAST(@endDay AS NVARCHAR(8));
    SET @row_count = (SELECT COUNT(*) FROM [Temp].temp4_FactAccTap);

    EXEC [Global].LogAction
         @TableName     = N'FactAccTap',
         @RowsAffected  = @row_count,
         @SeverityLevel = 'INFO',
         @Description   = @des,
         @ProcedureName = N'First_Fill_FactAccTap';
END;

GO;


/*********************    FactTrnsArrival Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactTrnsArrival
    @option INT = 0          -- 0 = abort if fact not empty, 1 = rebuild
AS
BEGIN
    SET NOCOUNT ON;


    IF @option = 0 AND EXISTS (SELECT 1 FROM [Transport].FactTrnsArrival)
    BEGIN
        RAISERROR (N'FactTrnsArrival already contains data. Use @option = 1 to rebuild.',16,1);
        RETURN;
    END

	TRUNCATE TABLE [Transport].FactTrnsArrival;
   
    EXEC [Global].LogAction
         @TableName     = N'FactTrnsArrival',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of FactTrnsArrival (day-by-day)',
         @ProcedureName = N'First_Fill_FactTrnsArrival';

   
    DECLARE @current_date  DATE,
            @end_date     DATE,
            @rowsToday   INT,
            @msg         NVARCHAR(200);

    SELECT  @current_date = CAST(MIN(ActualArrivalDT) AS DATE),
            @end_date     = CAST(MAX(ActualArrivalDT) AS DATE)
    FROM    TransitSA.dbo.SA_ArrivalEvent;

    IF @current_date IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactTrnsArrival',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'SA_ArrivalEvent is empty – nothing to load.',
             @ProcedureName = N'First_Fill_FactTrnsArrival';
        RETURN;
    END

  
    WHILE @current_date <= @end_date
    BEGIN

        INSERT INTO [Transport].FactTrnsArrival
                ( 
					JourneyID_BK, StationKey, DateKey,
					PlannedStartTK, ActualStartTK, PlannedEndTK, ActualEndTK,
					VehicleKey, RouteKey, DriverKey, JourneyStatusKey,
					DistanceKM, PassengerCount,
					CardBoarded, TicketBoarded, BoardedCnt, AlightedCnt, DelaySeconds
				)
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
             @ProcedureName = N'First_Fill_FactTrnsArrival';


        SET @current_date = DATEADD(DAY, 1, @current_date);
    END  /* WHILE */


	SET @msg = N'FIRST load complete up to ' + CONVERT(char(10), @end_date, 120);
	SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactTrnsArrival);
    EXEC [Global].LogAction
         @TableName     = N'FactTrnsArrival',
         @RowsAffected  = @rowsToday,
         @SeverityLevel = 'INFO',
         @Description   = @msg,
         @ProcedureName = N'First_Fill_FactTrnsArrival';
END;
GO;


/*********************    FactAccJourney Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactAccJourney
	@option INT = 0 
AS
BEGIN
	SET NOCOUNT ON;


    IF @option = 0 AND EXISTS (SELECT 1 FROM [Transport].FactAccJourney)
    BEGIN
        RAISERROR (N'FactAccJourney already contains data. Use @option = 1 to rebuild.',16,1);
        RETURN;
    END

	TRUNCATE TABLE Transport.FactAccJourney;
	   
    EXEC [Global].LogAction
         @TableName     = N'FactAccJourney',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of FactAccJourney (day-by-day)',
         @ProcedureName = N'First_Fill_FactAccJourney';
  
    DECLARE @current_date  DATE,
            @end_date     DATE,
            @rowsToday   INT,
            @msg         NVARCHAR(200);

    SELECT  @current_date = CAST(CONVERT(VARCHAR(8), MIN(DateKey), 112) AS DATE),
            @end_date     = CAST(CONVERT(VARCHAR(8), MAX(DateKey), 112) AS DATE)
    FROM    [Transport].FactTrnsArrival;

    IF @current_date IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactAccJourney',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactTrnsArrival is empty – nothing to load.',
             @ProcedureName = N'First_Fill_FactAccJourney';
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
             @ProcedureName = N'First_Fill_FactAccJourney';


		SET @current_date = DATEADD(DAY, 1, @current_date);

	END

	SET @msg = N'FIRST load complete up to ' + CONVERT(char(10), @end_date, 120);
	SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactAccJourney);
    EXEC [Global].LogAction
         @TableName     = N'FactAccJourney',
         @RowsAffected  = @rowsToday,
         @SeverityLevel = 'INFO',
         @Description   = @msg,
         @ProcedureName = N'First_Fill_FactAccJourney';
END
GO;


/*********************    FactDailyVehicleStatus Table    *********************/
CREATE OR ALTER PROCEDURE [Transport].First_Fill_FactDailyVehicleStatus
	@option INT = 0 
AS
BEGIN
	SET NOCOUNT ON;


    IF @option = 0 AND EXISTS (SELECT 1 FROM [Transport].FactDailyVehicleStatus)
    BEGIN
        RAISERROR (N'FactDailyVehicleStatus already contains data. Use @option = 1 to rebuild.',16,1);
        RETURN;
    END

	TRUNCATE TABLE  [Transport].FactDailyVehicleStatus;

    EXEC [Global].LogAction
         @TableName     = N'FactDailyVehicleStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of FactDailyVehicleStatus (day-by-day)',
         @ProcedureName = N'First_Fill_FactDailyVehicleStatus';
  
    DECLARE @current_date  DATE,
            @end_date     DATE,
            @rowsToday   INT,
            @msg         NVARCHAR(200);

	SELECT  @current_date = CAST(CONVERT(VARCHAR(8), MIN(DateKey), 112) AS DATE),
			@end_date     = CAST(CONVERT(VARCHAR(8), MAX(DateKey), 112) AS DATE)

    FROM    [Transport].FactTrnsArrival;

    IF @current_date IS NULL
    BEGIN
        EXEC [Global].LogAction
             @TableName     = N'FactDailyVehicleStatus',
             @RowsAffected  = 0,
             @SeverityLevel = 'WARN',
             @Description   = N'FactDailyVehicleStatus is empty – nothing to load.',
             @ProcedureName = N'First_Fill_FactDailyVehicleStatus';
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
					 @ProcedureName = N'First_Fill_FactDailyVehicleStatus';


				SET @current_date = DATEADD(DAY , 1 , @current_date);
		END

		SET @msg = N'FIRST load complete up to ' + CONVERT(char(10), @end_date, 120);
		SET @rowsToday = (SELECT COUNT(*) FROM [Transport].FactAccJourney);
		EXEC [Global].LogAction
			 @TableName     = N'FactDailyVehicleStatus',
			 @RowsAffected  = @rowsToday,
			 @SeverityLevel = 'INFO',
			 @Description   = @msg,
			 @ProcedureName = N'First_Fill_FactDailyVehicleStatus';

	END
GO;


/*********************    FactlessRouteStation Table    *********************/
CREATE OR ALTER  PROCEDURE [Transport].First_Fill_FactlessRouteStation
AS
BEGIN
    SET NOCOUNT ON;

    /*-------------------------------------------------------------*/
    /* 0. Safety – run once only                                   */
    /*-------------------------------------------------------------*/
    IF EXISTS (SELECT 1 FROM Transport.FactlessRouteStation)
    BEGIN
        RAISERROR(N'FactlessRouteStation already contains data. Aborting first load.',
                  16, 1);
        RETURN;
    END

    /*-------------------------------------------------------------*/
    /* 1. Start-of-run audit                                       */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting FIRST load of FactlessRouteStation',
         @ProcedureName = N'First_Fill_FactlessRouteStation';

    /*-------------------------------------------------------------*/
    /* 2. Truncate + bulk insert                                   */
    /*-------------------------------------------------------------*/
    TRUNCATE TABLE Transport.FactlessRouteStation;      -- guarantees empty

    INSERT INTO Transport.FactlessRouteStation
           (RouteKey, StationKey,SeqNo)
    SELECT RouteID, StationID,SeqNo
    FROM   TransitSA.dbo.SA_RouteStation;           -- source lookup

    DECLARE @rows INT = @@ROWCOUNT;

    /*-------------------------------------------------------------*/
    /* 3. Log rows inserted                                        */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = @rows,
         @SeverityLevel = 'INFO',
         @Description   = N'First load complete – rows inserted into FactlessRouteStation.',
         @ProcedureName = N'First_Fill_FactlessRouteStation';

    /*-------------------------------------------------------------*/
    /* 4. End-of-run audit                                         */
    /*-------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'FactlessRouteStation',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End of FIRST load procedure',
         @ProcedureName = N'First_Fill_FactlessRouteStation';
END;
GO;

