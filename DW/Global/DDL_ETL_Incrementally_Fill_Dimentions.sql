USE TransitDW;
GO;

/*********************    Procedure to fill Log for     *********************/
CREATE OR ALTER PROCEDURE [Global].LogAction
    @TableName       NVARCHAR(128),            -- required
    @RowsAffected    INT,                      -- required
    @SeverityLevel   NVARCHAR(50),             -- e.g. 'INFO', 'WARN', 'ERROR'
    @Description     NVARCHAR(MAX),            -- free‐form text
    @ProcedureName   NVARCHAR(128) = NULL      -- optional override
AS
BEGIN
    SET NOCOUNT ON;

    -- enforce required inputs
    IF @TableName IS NULL OR LTRIM(RTRIM(@TableName)) = ''
        THROW 50000, 'Parameter @TableName is required.', 1;

    IF @RowsAffected IS NULL
        THROW 50001, 'Parameter @RowsAffected is required.', 1;

    -- default the proc name if not supplied
    IF @ProcedureName IS NULL
        SET @ProcedureName = OBJECT_NAME(@@PROCID);

    INSERT INTO [Global].Log
        ( ProcedureName
        , ExecutedBy
        , TableName
        , RowsAffected
        , SeverityLevel
        , Description
        )
    VALUES
        ( @ProcedureName
        , SUSER_SNAME()      -- now captured inside the proc
        , @TableName
        , @RowsAffected
        , @SeverityLevel
        , @Description
        );
END;
GO;


/*********************    Procedure to fill DimDate for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimDate
@endDate SMALLINT -- until when we should fill and update DimDate, IT SHOULD BE IN JALALI FORMAT.
AS 
	BEGIN 
		-- Logging Procedure Start

		DECLARE @desc NVARCHAR(MAX);

		SET @desc = N'Strting Procedure Incrementally_Fill_DimDate to update DimDate until '
				  + CAST(@endDate AS NVARCHAR(10)) + N' .';

		-- Execute the log action, using @@ROWCOUNT for rows affected
		EXEC [Global].LogAction
			 @TableName     = N'DimDate'
		   , @RowsAffected  = 0
		   , @SeverityLevel = 'INFO'
		   , @Description   = @desc
		   , @ProcedureName = N'Incrementally_Fill_DimDate';



		IF NOT EXISTS (SELECT 1 FROM [Global].DimDate)
			BEGIN
				-- Logging Procedure Error
				-- Declare a variable for the Description
				

				SET @desc = N'DimDate is Empty. Use [Global].First_Fill_DimDate to initialize it first.';

				-- Call the LogAction proc, passing 0 for RowsAffected since nothing was updated
				EXEC [Global].LogAction
					 @TableName     = N'DimDate'
				   , @RowsAffected  = 0
				   , @SeverityLevel = 'ERROR'
				   , @Description   = @desc
				   , @ProcedureName = N'Incrementally_Fill_DimDate';


				RAISERROR('DimDate is Empty. Use [Global].First_Fill_DimDate to initialize it first.', 16, 1);
				RETURN;
			END


		DECLARE @last_DimDate_Year SMALLINT;
		SELECT @last_DimDate_Year = MAX(time_Year) FROM [Global].DimDate;

		IF @endDate <= @last_DimDate_Year
			BEGIN
				-- Logging Procedure Error
				SET @desc = 
					N'Input @endDate is smaller than maximum year in DimDate. '
				  + N'Be aware to enter year in JALALI format. @endDate: '
				  + CAST(@endDate AS NVARCHAR(10))
				  + N' .';

				-- Call the LogAction proc, passing 0 for RowsAffected since nothing was processed
				EXEC [Global].LogAction
					 @TableName     = N'DimDate'
				   , @RowsAffected  = 0
				   , @SeverityLevel = 'ERROR'
				   , @Description   = @desc
				   , @ProcedureName = N'Incrementally_Fill_DimDate';

				RAISERROR('Input @endDate is smaller than maximum year in DimDate.Be aware to enter year in gorgian format.', 16, 1);
				RETURN;
			END
		
		DECLARE @YearStart	smallint
		DECLARE @YearEnd	smallint

		DECLARE @DateStart	datetime
		DECLARE @DateEnd	datetime

		DECLARE @mDate		datetime
		DECLARE @mYear		smallint
		DECLARE @mMonth		tinyint
		DECLARE @mDay		tinyint

		DECLARE @sDate		char(10)
		DECLARE @sYear		smallint
		DECLARE @sMonth		tinyint
		DECLARE @sDay		tinyint

		DECLARE @Hour		tinyint

		DECLARE @sYearCH	char(4)
		DECLARE @sMonthCH	char(2)
		DECLARE @sDayCH		char(2)

		DECLARE @HourCH		char(2)

		DECLARE @sDayOfYear		smallint
		DECLARE @mDayOfYear		smallint
		DECLARE @sWeekOfYear	tinyint
		DECLARE @mWeekOfYear	tinyint
		DECLARE @sDayOfWeek		tinyint
		DECLARE @mDayOfWeek		tinyint


		DECLARE @sMonthName		nvarchar(32)
		DECLARE @sSeasonName	nvarchar(32)
		DECLARE @sHalfYearName	nvarchar(32)
		DECLARE @sDayOfWeekName	nvarchar(32)

		DECLARE @FirstDayOfYearWeekDay tinyint
 
		-- تنظیم سالهایی که می خواهید در بعد زمان ثبت شوند
		--------------------------------------------------
		SET @YearStart	= @last_DimDate_Year + 1;
		SET @YearEnd	= @endDate;
		--------------------------------------------------

		SET @DateStart = [Global].ShamsiToMiladi (CAST(@YearStart AS varchar(4)) + '/01/01')
		SET @DateEnd = [Global].ShamsiToMiladi (CAST(@YearEnd+1 AS varchar(4)) + '/01/01')

		SET @mDate = @DateStart

		--WHILE @mDate < @DateEnd
		--BEGIN
		--	SET @mYear = DATEPART(yy , @mDate)
		--	SET @mMonth = DATEPART(mm , @mDate)
		--	SET @mDay = DATEPART(dd , @mDate)
	
		--	SET @sDate = [Global].MiladiTOShamsi(@mDate)	
		--	SET @sDay = CAST (RIGHT (@sDate , 2) AS smallint)
		--	SET @sMonth = CAST (SUBSTRING(@sDate , 6,2) AS smallint)
		--	SET @sYear = CAST (LEFT(@sDate , 4) AS smallint)

		--	SET @sDayCH = RIGHT (@sDate , 2) 
		--	SET @sMonthCH = SUBSTRING(@sDate , 6,2) 
		--	SET @sYearCH = LEFT(@sDate , 4)
		
		--	SET @mDayOfWeek =  DATEPART (dw,@mDate) 
		--	SET @sDayOfWeek =  DATEPART (dw,@mDate) +1
		--	IF @sDayOfWeek > 7 
		--			SET @sDayOfWeek = @sDayOfWeek - 7
	
		--	SET @mDayOfYear = DATEPART (dy ,@mDate)
		--	IF (@sMonth = 1) AND (@sDay = 1)
		--	BEGIN 
		--		SET @sDayOfYear =  1
		--		SET @FirstDayOfYearWeekDay = @sDayOfWeek		
		--	END
		--	ELSE
		--	BEGIN
		--		SET @sDayOfYear = @sDayOfYear + 1
		--	END
	
		--	--print @sDayOfYear
		--	--print @FirstDayOfYearWeekDay
	
		--	SET @sMonthName = 
		--		CASE @sMonth 
		--		WHEN 1 THEN N'فروردين'
		--		WHEN 2 THEN N'ارديبهشت'
		--		WHEN 3 THEN N'خرداد'
		--		WHEN 4 THEN N'تير'
		--		WHEN 5 THEN N'مرداد'
		--		WHEN 6 THEN N'شهريور'
		--		WHEN 7 THEN N'مهر'
		--		WHEN 8 THEN N'آبان'
		--		WHEN 9 THEN N'آذر'
		--		WHEN 10 THEN N'دي'
		--		WHEN 11 THEN N'بهمن'
		--		WHEN 12 THEN N'اسفند'
		--		END
		
		--	SET @sDayOfWeekName = 
		--		CASE @sDayOfWeek
		--		WHEN 1 THEN N'شنبه'
		--		WHEN 2 THEN N'يکشنبه'
		--		WHEN 3 THEN N'دوشنبه'
		--		WHEN 4 THEN N'سه شنبه'
		--		WHEN 5 THEN N'چهار شنبه'
		--		WHEN 6 THEN N'پنج شنبه'
		--		WHEN 7 THEN N'جمعه'
		--		END		

		--	SET @sSeasonName = 
		--		CASE CEILING(CAST(@sMonth AS float) / 3 ) 
		--		WHEN 1 THEN N'سه ماهه اول'
		--		WHEN 2 THEN N'سه ماهه دوم'
		--		WHEN 3 THEN N'سه ماهه سوم'
		--		WHEN 4 THEN N'سه ماهه چهارم'
		--		END		
	
		--	SET @sHalfYearName = 
		--		CASE CEILING(CAST(@sMonth AS float) / 6 ) 
		--		WHEN 1 THEN N'نيمسال اول'
		--		WHEN 2 THEN N'نيمسال دوم'
		--	END		

		--	SET @mWeekOfYear =  DATEPART (ww , @mDate)
		--	SET @sWeekOfYear =  CEILING( (CAST(@sDayOfYear AS float)+ CAST(@FirstDayOfYearWeekDay AS float)-1)  / 7)
	
		--	SET @Hour = 1 
		--	WHILE @Hour <= 24
		--	BEGIN		
		--		SET @HourCH =  REPLICATE ('0' , 2 - LEN(LTRIM(CAST(@Hour AS varchar(2)))) )  + CAST(@Hour AS varchar(2))
		
		--		INSERT INTO [Global].[DimDate](
		--			[time_Id],[time_Date_Id],[time_Key_Year_Month_Day_Hour_Native],[time_Key_Year_Month_Day_Native],
		--			[time_Key_Year_Week_Native],[time_Key_Year_Month_Native],[time_Key_Year_Half_Native],
		--			[time_Key_Year_Season_Native],[time_Key_Year_Native],[time_Key_Year_Month_Day_Hour],
		--			[time_Key_Year_Month_Day],[time_Key_Year_Week],[time_Key_Year_Month],[time_Key_Year_Half],
		--			[time_Key_Year_Season],[time_Key_Year],[time_Title_Year_Month_Day_Hour],[time_Title_Year_Month_Day],
		--			[time_Title_Year_Week],[time_Title_Year_Month],[time_Title_Year_Half],[time_Title_Year_Season],
		--			[time_Title_Year],[time_Year_Native],[time_Month_Native],[time_Month_Native_2Char],
		--			[time_Day_Native],[time_Day_Native_2Char],[time_Hour],[time_Hour_2Char],[time_Date_Name],[time_Year],
		--			[time_Month_Of_Year],[time_Month_Of_Year_2Char],[time_Month_Of_Season],[time_Month_Name],
		--			[time_Day_Of_Year],[time_Day_Of_Month],[time_Day_Of_Month_2Char],[time_Day_Of_Week],[time_Day_Of_Week_Name],
		--			[time_Week_Of_Year],[time_Season_Of_Year],[time_Season_Name],[time_Half_Of_Year],[time_Half_Of_Year_Name]
		--		)
		--		VALUES
		--		(
		--			CAST(@mDate AS int) * 100 + @Hour ,CAST(@mDate AS int) , 
		--			CAST(@mYear  * 1000000	+ @mMonth * 10000	+ @mDay * 100 + @Hour  AS BIGINT),
		--			@mYear  * 10000		+ @mMonth * 100		+ @mDay  ,
		--			@mYear  * 100		+ @mWeekOfYear 	,
		--			@mYear  * 100		+ @mMonth ,
		--			@mYear  * 10		+ CEILING(CAST(@mMonth AS float) / 6 ) ,
		--			@mYear  * 10		+ CEILING(CAST(@mMonth AS float) / 3 )  ,
		--			@mYear  ,
		--			CAST(@sYear  * 1000000	+ @sMonth * 10000	+ @sDay * 100 + @Hour AS BIGINT) ,
		--			@sYear  * 10000		+ @sMonth * 100		+ @sDay  ,
		--			@sYear  * 100		+ @sWeekOfYear 	,
		--			@sYear  * 100		+ @sMonth ,
		--			@sYear  * 10		+ CEILING(CAST(@sMonth AS float) / 6 ) ,
		--			@sYear  * 10		+ CEILING(CAST(@sMonth AS float) / 3 )  ,
		--			@sYear  ,			
		--			N'ساعت ' + CAST(@Hour AS nvarchar(2))+ N' ' + N'روز' + N' ' + @sDate ,
		--			@sDate ,N'هفته ' + CAST(@sDayOfWeek AS nvarchar(2))+ N' سال ' + @sYearCH ,
		--			@sMonthName + N' ' + @sYearCH , @sHalfYearName + N' ' + @sYearCH ,@sSeasonName + N' ' + @sYearCH  , 
		--			N'سال ' + @sYearCH , @sYear ,@sMonth ,@sMonthCH  ,@sDay ,@sDayCH ,@Hour ,@HourCH , 
		--			N'روز' + CAST (@sDay AS nvarchar(2)) + N' ' + @sMonthName + N' ' + @sYearCH, @sYear ,@sMonth ,@sMonthCH ,
		--			CASE WHEN @sMonth % 3 = 0 THEN 3 ELSE @sMonth % 3 END, @sMonthName ,@sDayOfYear ,
		--			@sDay ,@sDayCH ,@sDayOfWeek ,@sDayOfWeekName ,@sWeekOfYear,
		--			CEILING(CAST(@sMonth AS float) / 3) , @sSeasonName ,
		--			CEILING(CAST(@sMonth AS float) / 6 ) ,@sHalfYearName
		--		)
		--		SET @Hour = @Hour + 1
		--	END
	
		--	SET @mDate = DATEADD(day , 1, @mDate )
		--END -- while loop


		-- Logging Procedure End
		
		WHILE @mDate < @DateEnd
		BEGIN
			/* Gregorian break-out */
			SET @mYear  = DATEPART(yy, @mDate);
			SET @mMonth = DATEPART(mm, @mDate);
			SET @mDay   = DATEPART(dd, @mDate);

			/* Jalali break-out */
			SET @sDate   = [Global].MiladiTOShamsi(@mDate);       -- yyyy/MM/dd
			SET @sDay    = CAST(RIGHT(@sDate , 2)   AS SMALLINT);
			SET @sMonth  = CAST(SUBSTRING(@sDate ,6,2) AS SMALLINT);
			SET @sYear   = CAST(LEFT(@sDate , 4)     AS SMALLINT);
			SET @sDayCH  = RIGHT(@sDate , 2);
			SET @sMonthCH= SUBSTRING(@sDate , 6,2);
			SET @sYearCH = LEFT(@sDate , 4);

			/* DOW, DOY, WOW --------------------------------------------- */
			SET @mDayOfWeek = DATEPART(dw,@mDate);
			SET @sDayOfWeek = @mDayOfWeek + 1;       -- 1 = شنبه
			IF @sDayOfWeek > 7 SET @sDayOfWeek = @sDayOfWeek - 7;

			SET @mDayOfYear = DATEPART(dy,@mDate);

			IF (@sMonth = 1 AND @sDay = 1)
			BEGIN
				SET @sDayOfYear = 1;
				SET @FirstDayOfYearWeekDay = @sDayOfWeek;
			END
			ELSE
				SET @sDayOfYear = @sDayOfYear + 1;

			SET @sWeekOfYear = CEILING( (@sDayOfYear + @FirstDayOfYearWeekDay - 1) / 7.0 );
			SET @mWeekOfYear = DATEPART(ww,@mDate);

			/* Persian names ---------------------------------------------- */
			SET @sMonthName =
				CASE @sMonth
						WHEN 1 THEN N'فروردين' WHEN 2 THEN N'ارديبهشت'
						WHEN 3 THEN N'خرداد'   WHEN 4 THEN N'تير'
						WHEN 5 THEN N'مرداد'   WHEN 6 THEN N'شهريور'
						WHEN 7 THEN N'مهر'     WHEN 8 THEN N'آبان'
						WHEN 9 THEN N'آذر'     WHEN 10 THEN N'دي'
						WHEN 11 THEN N'بهمن'   WHEN 12 THEN N'اسفند'
				END;

			SET @sDayOfWeekName =
				CASE @sDayOfWeek
						WHEN 1 THEN N'شنبه'      WHEN 2 THEN N'يکشنبه'
						WHEN 3 THEN N'دوشنبه'    WHEN 4 THEN N'سه شنبه'
						WHEN 5 THEN N'چهار شنبه' WHEN 6 THEN N'پنج شنبه'
						WHEN 7 THEN N'جمعه'
				END;

			SET @sSeasonName =
				CASE CEILING(@sMonth / 3.0)
						WHEN 1 THEN N'سه ماهه اول'
						WHEN 2 THEN N'سه ماهه دوم'
						WHEN 3 THEN N'سه ماهه سوم'
						WHEN 4 THEN N'سه ماهه چهارم'
				END;

			SET @sHalfYearName =
				CASE CEILING(@sMonth / 6.0)
						WHEN 1 THEN N'نيمسال اول'
						WHEN 2 THEN N'نيمسال دوم'
				END;

			/* === single INSERT (no hour loop) =========================== */
			INSERT INTO [Global].[DimDate] (
				time_Date_Id              ,
				time_Key_Year_Month_Day_Native ,
				time_Key_Year_Week_Native, time_Key_Year_Month_Native,
				time_Key_Year_Half_Native, time_Key_Year_Season_Native,
				time_Key_Year_Native     ,
				time_Key_Year_Month_Day  ,
				time_Key_Year_Week       , time_Key_Year_Month       ,
				time_Key_Year_Half       , time_Key_Year_Season      ,
				time_Key_Year            ,
				time_Title_Year_Month_Day, time_Title_Year_Week      ,
				time_Title_Year_Month    , time_Title_Year_Half      ,
				time_Title_Year_Season   , time_Title_Year           ,
				time_Year_Native , time_Month_Native , time_Month_Native_2Char ,
				time_Day_Native , time_Day_Native_2Char ,
				time_Date_Name  , time_Year ,
				time_Month_Of_Year, time_Month_Of_Year_2Char ,
				time_Month_Of_Season , time_Month_Name ,
				time_Day_Of_Year  , time_Day_Of_Month     , time_Day_Of_Month_2Char ,
				time_Day_Of_Week  , time_Day_Of_Week_Name ,
				time_Week_Of_Year , time_Season_Of_Year   , time_Season_Name ,
				time_Half_Of_Year , time_Half_Of_Year_Name ,
				full_Date          -- << new DATE column
			)
			VALUES (
				/*CAST(@mDate AS INT) ,                         -- time_Id  (days since 1900-01-01)*/
				CAST(@mDate AS INT) ,                         -- time_Date_Id
				@mYear * 10000 + @mMonth * 100 + @mDay ,      -- native YM-D
				@mYear * 100   + @mWeekOfYear ,
				@mYear * 100   + @mMonth ,
				@mYear * 10    + CEILING(@mMonth / 6.0) ,
				@mYear * 10    + CEILING(@mMonth / 3.0) ,
				@mYear ,
				@sYear * 10000 + @sMonth * 100 + @sDay ,      -- shamsi key
				@sYear * 100   + @sWeekOfYear ,
				@sYear * 100   + @sMonth ,
				@sYear * 10    + CEILING(@sMonth / 6.0) ,
				@sYear * 10    + CEILING(@sMonth / 3.0) ,
				@sYear ,
				@sDate ,                                      -- title YM-D
				N'هفته ' + CAST(@sDayOfWeek AS NVARCHAR(2)) + N' سال ' + @sYearCH ,
				@sMonthName + N' ' + @sYearCH ,
				@sHalfYearName + N' ' + @sYearCH ,
				@sSeasonName   + N' ' + @sYearCH ,
				N'سال ' + @sYearCH ,
				@sYear , @sMonth , @sMonthCH ,
				@sDay , @sDayCH ,
				N'روز' + CAST(@sDay AS NVARCHAR(2)) + N' ' + @sMonthName + N' ' + @sYearCH ,
				@sYear ,
				@sMonth , @sMonthCH ,
				CASE WHEN @sMonth % 3 = 0 THEN 3 ELSE @sMonth % 3 END ,
				@sMonthName ,
				@sDayOfYear , @sDay , @sDayCH ,
				@sDayOfWeek , @sDayOfWeekName ,
				@sWeekOfYear ,
				CEILING(@sMonth / 3.0) , @sSeasonName ,
				CEILING(@sMonth / 6.0) , @sHalfYearName ,
				CAST(@mDate AS DATE)      -- FullDate
			);

			/* advance one day */
			SET @mDate = DATEADD(DAY, 1, @mDate);
		END;

	

		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].[DimDate] AS d WHERE d.time_Key_Year_Native >= @YearStart;

		EXEC [Global].LogAction
			 @TableName     = N'DimDate'
		   , @RowsAffected  = @number_of_rows
		   , @SeverityLevel = 'INFO'
		   , @Description   = N'Procedure completed. Rows inserted into DimDate.'
		   , @ProcedureName = N'Incrementally_Fill_DimDate';

	END
GO;


/*********************    Procedure to fill DimEmployee for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimEmployee
AS
	BEGIN 
	
		SET NOCOUNT ON;

		DECLARE @number_of_rows INT = 0, @desc NVARCHAR(MAX);

	---------------------------------------------------------------
	-- 0.  Start-of-run audit
	---------------------------------------------------------------

	-- Logging Procedure Start
	EXEC [Global].LogAction
			@TableName     = N'DimEmployee'
		, @RowsAffected  = 0
		, @SeverityLevel = 'INFO'
		, @Description   = N'Strting Procedure Incrementally_Fill_DimEmployee to update DimEmployee.'
		, @ProcedureName = N'Incrementally_Fill_DimEmployee';
		

    ---------------------------------------------------------------
    -- 1.  “Previous-run failed?” safety check
    ---------------------------------------------------------------
	IF NOT 
		(
				(NOT EXISTS (SELECT 1 FROM [Global].DimEmployee)
			AND 
				EXISTS(SELECT 1 FROM [Temp].[temp1_DimEmployee]))
		)

	BEGIN

        -----------------------------------------------------------
        -- 2.  Stage CURRENT dimension  ➜ temp1
        -----------------------------------------------------------

		TRUNCATE TABLE [Temp].[temp1_DimEmployee];


 		INSERT INTO [Temp].[temp1_DimEmployee]
        ( 
		  EmpID_SK, EmpID_BK, FirstName, LastName, NationalID, Email, PhoneNumber,
          Gender, DateOfBirth, HireDate, [Address],
          EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary,
          DepartmentID, DeptCode, Dept_EN, Dept_FA,
          CurrentRoleID, RoleCode, Role_EN, Role_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent
		)
        SELECT EmpID_SK, EmpID_BK, FirstName, LastName, NationalID, Email, PhoneNumber,
               Gender, DateOfBirth, HireDate, [Address],
               EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary,
               DepartmentID, DeptCode, Dept_EN, Dept_FA,
               CurrentRoleID, RoleCode, Role_EN, Role_FA,
               SCD_StartDate, SCD_EndDate, IsCurrent
        FROM   [Global].DimEmployee;

		
		SELECT @number_of_rows = COUNT(*) FROM [Temp].[temp1_DimEmployee];


		SET @desc = N'Inserting Employees from DimEmployee to temp1_DimEmployee';

		EXEC [Global].LogAction
			 @TableName     = N'DimEmployee'
		   , @RowsAffected  = @number_of_rows
		   , @SeverityLevel = 'INFO'
		   , @Description   = @desc
		   , @ProcedureName = N'Incrementally_Fill_DimEmployee';


        -----------------------------------------------------------
        -- 3.  Build INCREMENTAL source rows  ➜ temp2
        -----------------------------------------------------------
		TRUNCATE TABLE [Temp].temp2_DimEmployee;

		/*-- 3-A.  Get “last loaded” SCD_StartDate for each employee --*/
        ;WITH dim_last AS
        (
            SELECT EmpID_BK,
                   MAX(SCD_StartDate) AS LastLoadedStart
            FROM   [Temp].temp1_DimEmployee
            GROUP  BY EmpID_BK
        ),
        /*-- 3-B.  New (or first-time) role-history rows since last load --*/
        role_delta AS
        (
            SELECT  rh.EmpID,
                    rh.RoleID,
                    rh.RoleStartDT,
                    rh.RoleEndDT
            FROM    TransitSA.dbo.SA_EmployeeRoleHistory rh
            LEFT    JOIN dim_last dl ON dl.EmpID_BK = rh.EmpID
            WHERE   dl.EmpID_BK IS NULL                    -- brand-new employee
                   OR rh.RoleStartDT > dl.LastLoadedStart   -- or promotion since last load
        ),
        /*-- 3-C.  Current role snapshot (RoleEndDT IS NULL) ---------*/
        latest_role AS
        (
            SELECT  rh.EmpID,
                    rh.RoleID,
                    rh.RoleStartDT,
                    rh.RoleEndDT,
                    ROW_NUMBER() OVER (PARTITION BY rh.EmpID
                                       ORDER BY rh.RoleStartDT DESC) AS rn
            FROM    TransitSA.dbo.SA_EmployeeRoleHistory rh
            WHERE   rh.RoleEndDT IS NULL
        )
        /*-- 3-D.  UNION ALL:    ① incremental role rows
                                 ② one “today snapshot” row   --*/
        INSERT INTO [Temp].temp2_DimEmployee
        ( EmpID_BK, FirstName, LastName, NationalID, Email, PhoneNumber,
          Gender, DateOfBirth, HireDate, [Address],
          EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary,
          DepartmentID, DeptCode, Dept_EN, Dept_FA,
          CurrentRoleID, RoleCode, Role_EN, Role_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent )
        /*—— Rows for *new promotions / demotions* since last load —*/
        SELECT  e.EmpID,
                e.FirstName, e.LastName, e.NationalID, e.Email, e.PhoneNumber,
                e.Gender, e.DateOfBirth, e.HireDate, e.[Address],
                e.EmergencyName, e.EmergencyPhone, e.BankAccountNo, e.BaseSalary,
                d.DepartmentID, d.DeptCode, d.Label_EN, d.Label_FA,
                r.RoleID, r.RoleCode, r.Label_EN, r.Label_FA,
                CONVERT(DATE, rd.RoleStartDT)                AS SCD_StartDate,
                CONVERT(DATE, rd.RoleEndDT)                  AS SCD_EndDate,
                CASE WHEN rd.RoleEndDT IS NULL THEN 1 ELSE 0 END AS IsCurrent
        FROM        role_delta           rd
        JOIN        TransitSA.dbo.SA_Employee        e ON e.EmpID = rd.EmpID
        LEFT JOIN   TransitSA.dbo.SA_LkpRole         r ON r.RoleID = rd.RoleID
        LEFT JOIN   TransitSA.dbo.SA_LkpDepartment   d ON d.DepartmentID = e.DepartmentID

        UNION ALL

        /*—— Always add one row that reflects “today” for salary/department changes —*/
        SELECT  e.EmpID,
                e.FirstName, e.LastName, e.NationalID, e.Email, e.PhoneNumber,
                e.Gender, e.DateOfBirth, e.HireDate, e.[Address],
                e.EmergencyName, e.EmergencyPhone, e.BankAccountNo, e.BaseSalary,
                d.DepartmentID, d.DeptCode, d.Label_EN, d.Label_FA,
                lr.RoleID, r.RoleCode, r.Label_EN, r.Label_FA,
                CONVERT(DATE, lr.RoleStartDT)                AS SCD_StartDate,
                NULL                                         AS SCD_EndDate,
                1                                            AS IsCurrent
        FROM        latest_role           lr
        JOIN        TransitSA.dbo.SA_Employee        e ON e.EmpID = lr.EmpID
        LEFT JOIN   TransitSA.dbo.SA_LkpRole         r ON r.RoleID = lr.RoleID
        LEFT JOIN   TransitSA.dbo.SA_LkpDepartment   d ON d.DepartmentID = e.DepartmentID
        WHERE       lr.rn = 1
		AND NOT EXISTS ( SELECT 1    -- DEDUPLICATING
                   FROM role_delta rd
                   WHERE rd.EmpID    = lr.EmpID
                     AND rd.RoleID   = lr.RoleID
                     AND rd.RoleStartDT = lr.RoleStartDT );
					 -- one current row per EmpID



		SELECT @number_of_rows = COUNT(*) FROM [Temp].[temp2_DimEmployee];
		SET @desc = N'Inserting Employees new records from SA which RoleEndDT is null';

		EXEC [Global].LogAction
			 @TableName     = N'DimEmployee'
		   , @RowsAffected  = @number_of_rows
		   , @SeverityLevel = 'INFO'
		   , @Description   = @desc
		   , @ProcedureName = N'Incrementally_Fill_DimEmployee';

        -----------------------------------------------------------
        -- 4.  Build NEXT dimension  ➜ temp3
        -----------------------------------------------------------
		TRUNCATE TABLE [Temp].temp3_DimEmployee;

		
        /*-- 4-A.  Carry forward unchanged rows --------------------*/
        INSERT INTO [Temp].temp3_DimEmployee
        SELECT t1.*
        FROM   [Temp].temp1_DimEmployee AS t1
        WHERE  t1.IsCurrent = 0                               -- already historical
           OR NOT EXISTS ( SELECT 1
                           FROM   [Temp].temp2_DimEmployee AS t2
                           WHERE  t2.EmpID_BK = t1.EmpID_BK
                             AND (    t2.SCD_StartDate     > t1.SCD_StartDate      -- any *newer* version exists
                                   --OR t2.BaseSalary        <> t1.BaseSalary
                                   --OR t2.DepartmentID      <> t1.DepartmentID
                                   OR t2.CurrentRoleID     <> t1.CurrentRoleID ) );

		/*-- 4-B.  Expire “current” rows that have a newer version –*/
        ;WITH nextStart AS
        (
            SELECT EmpID_BK,
                   MIN(SCD_StartDate) AS NewStart
            FROM   [Temp].temp2_DimEmployee
            GROUP  BY EmpID_BK
        )
        INSERT INTO [Temp].temp3_DimEmployee
        SELECT  t1.EmpID_SK, t1.EmpID_BK, t1.FirstName, t1.LastName, t1.NationalID,
                t1.Email, t1.PhoneNumber, t1.Gender, t1.DateOfBirth, t1.HireDate,
                t1.[Address], t1.EmergencyName, t1.EmergencyPhone, t1.BankAccountNo,
                t1.BaseSalary, t1.DepartmentID, t1.DeptCode, t1.Dept_EN, t1.Dept_FA,
                t1.CurrentRoleID, t1.RoleCode, t1.Role_EN, t1.Role_FA,
                t1.SCD_StartDate,
                ns.NewStart,                      -- close at first new StartDate
                0         AS IsCurrent
        FROM   [Temp].temp1_DimEmployee t1
        JOIN   nextStart               ns ON ns.EmpID_BK = t1.EmpID_BK
        WHERE  t1.IsCurrent = 1
          AND  ns.NewStart > t1.SCD_StartDate;     -- really a “newer” row

        /*-- 4-C.  Insert *all* rows from temp2 as NEW versions ----*/
        DECLARE @max_sk INT = ISNULL((SELECT MAX(EmpID_SK) FROM [Temp].temp1_DimEmployee),0);

        INSERT INTO [Temp].temp3_DimEmployee
        ( EmpID_SK, EmpID_BK, FirstName, LastName, NationalID, Email, PhoneNumber,
          Gender, DateOfBirth, HireDate, [Address],
          EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary,
          DepartmentID, DeptCode, Dept_EN, Dept_FA,
          CurrentRoleID, RoleCode, Role_EN, Role_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent )
        SELECT  @max_sk + ROW_NUMBER() OVER (ORDER BY t2.EmpID_BK, t2.SCD_StartDate) AS NewSK,
                t2.EmpID_BK, t2.FirstName, t2.LastName, t2.NationalID, t2.Email, t2.PhoneNumber,
                t2.Gender, t2.DateOfBirth, t2.HireDate, t2.[Address],
                t2.EmergencyName, t2.EmergencyPhone, t2.BankAccountNo, t2.BaseSalary,
                t2.DepartmentID, t2.DeptCode, t2.Dept_EN, t2.Dept_FA,
                t2.CurrentRoleID, t2.RoleCode, t2.Role_EN, t2.Role_FA,
                t2.SCD_StartDate, t2.SCD_EndDate, t2.IsCurrent
        FROM   [Temp].temp2_DimEmployee t2;


		SELECT @number_of_rows = COUNT(*) FROM [Temp].temp3_DimEmployee;
		SET @desc = N'Inserting delta data';

		EXEC [Global].LogAction
			 @TableName     = N'[Temp].temp3_DimEmployee'
		   , @RowsAffected  = @number_of_rows
		   , @SeverityLevel = 'INFO'
		   , @Description   = @desc
		   , @ProcedureName = N'Incrementally_Fill_DimEmployee';


        -----------------------------------------------------------
        -- 5.  Reload dimension from temp3
        -----------------------------------------------------------
        TRUNCATE TABLE [Global].DimEmployee;

        INSERT INTO [Global].DimEmployee
        SELECT EmpID_SK, EmpID_BK, FirstName, LastName, NationalID, Email, PhoneNumber,
          Gender, DateOfBirth, HireDate, [Address],
          EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary,
          DepartmentID, DeptCode, Dept_EN, Dept_FA,
          CurrentRoleID, RoleCode, Role_EN, Role_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent
        FROM   [Temp].temp3_DimEmployee;

		SELECT @number_of_rows = COUNT(*) FROM [Global].DimEmployee;
		
		EXEC [Global].LogAction
			 @TableName     = N'[Global].DimEmployee'
		   , @RowsAffected  = @number_of_rows
		   , @SeverityLevel = 'INFO'
		   , @Description   = N'Inserting data to dim'
		   , @ProcedureName = N'Incrementally_Fill_DimEmployee';


	END
	---------------------------------------------------------------
    -- 6.  End-of-run audit
    ---------------------------------------------------------------
	

	EXEC [Global].LogAction
		@TableName     = N'[Global].DimEmployee'
		, @RowsAffected  = 0
		, @SeverityLevel = 'INFO'
		, @Description   = N'End run procedure'
		, @ProcedureName = N'Incrementally_Fill_DimEmployee';


END;
GO;


/*********************    Procedure to fill DimStation for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimStation
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @number_of_rows INT = 0, @desc NVARCHAR(MAX);
    /*---------------------------------------------------------------
      0.  Start-of-run audit
    ----------------------------------------------------------------*/
	EXEC [Global].LogAction
		@TableName     = N'DimStation'
	, @RowsAffected  = 0
	, @SeverityLevel = 'INFO'
	, @Description   = N'Strting Procedure Incrementally_Fill_DimStation to update DimStation.'
	, @ProcedureName = N'Incrementally_Fill_DimStation';

    /*---------------------------------------------------------------
      1.  Stage latest snapshot ➜ [Temp].temp_DimStation
          (temp table must have the same column list as DimStation,
           except StationID_BK is NOT a key/identity here)
    ----------------------------------------------------------------*/
    TRUNCATE TABLE [Temp].temp1_DimStation;

    INSERT INTO [Temp].temp1_DimStation
        (StationID_BK, StationName, Latitude, Longitude,
         StreetAddress, City, ZoneCode, OpeningDate, IsAccessible)
    SELECT  StationID, StationName, Latitude, Longitude,
            StreetAddress, City, ZoneCode, OpeningDate, IsAccessible
    FROM    TransitSA.dbo.SA_Station;     -- ➊  source


	SELECT @number_of_rows = COUNT(*) FROM [Temp].temp1_DimStation;

	
	SET @desc = N'Inserting Stations from DimStations to temp1_DimStations';

	EXEC [Global].LogAction
			@TableName     = N'DimStation'
		, @RowsAffected  = @number_of_rows
		, @SeverityLevel = 'INFO'
		, @Description   = @desc
		, @ProcedureName = N'Incrementally_Fill_DimStation';

    /*---------------------------------------------------------------
      2.  Up-sert into dimension (MERGE)
    ----------------------------------------------------------------*/
    DECLARE @mergeResults TABLE (action NVARCHAR(10));

    MERGE  [Global].DimStation  AS tgt
    USING  [Temp].temp_DimStation       AS src
          ON tgt.StationID_BK = src.StationID_BK

    /*—— update only when ANY attribute changes ————————————*/
    WHEN MATCHED AND
         (   ISNULL(tgt.StationName  , '') <> ISNULL(src.StationName  , '')
          OR ISNULL(tgt.Latitude     , 0 ) <> ISNULL(src.Latitude     , 0 )
          OR ISNULL(tgt.Longitude    , 0 ) <> ISNULL(src.Longitude    , 0 )
          OR ISNULL(tgt.StreetAddress, '') <> ISNULL(src.StreetAddress, '')
          OR ISNULL(tgt.City         , '') <> ISNULL(src.City         , '')
          OR ISNULL(tgt.ZoneCode     , '') <> ISNULL(src.ZoneCode     , '')
          OR ISNULL(tgt.OpeningDate  , '1300-01-01') <> ISNULL(src.OpeningDate, '1300-01-01')
          OR ISNULL(tgt.IsAccessible , '') <> ISNULL(src.IsAccessible , '')
         )
      THEN UPDATE SET
           tgt.StationName   = src.StationName,
           tgt.Latitude      = src.Latitude,
           tgt.Longitude     = src.Longitude,
           tgt.StreetAddress = src.StreetAddress,
           tgt.City          = src.City,
           tgt.ZoneCode      = src.ZoneCode,
           tgt.OpeningDate   = src.OpeningDate,
           tgt.IsAccessible  = src.IsAccessible

    /*—— new SA stations ———————————————————————————————*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (StationID_BK, StationName, Latitude, Longitude,
                   StreetAddress, City, ZoneCode, OpeningDate, IsAccessible)
           VALUES (src.StationID_BK, src.StationName, src.Latitude, src.Longitude,
                   src.StreetAddress, src.City, src.ZoneCode, src.OpeningDate, src.IsAccessible)

    /*—— keep removed stations for history; no delete clause ———*/
    OUTPUT $action INTO @mergeResults(action);

    /*---------------------------------------------------------------
      3.  Audit inserted vs updated rows
    ----------------------------------------------------------------*/
    DECLARE @rowsInserted INT = (SELECT COUNT(*) FROM @mergeResults WHERE action = 'INSERT');
    DECLARE @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeResults WHERE action = 'UPDATE');

    INSERT INTO DatawareHouse.dbo.Log
           (procedure_name, [date], [description], table_name, number_of_row_inserted)
    VALUES ('fill_dim_station', GETDATE(),
            'rows inserted', '[Global].DimStation', @rowsInserted);

    INSERT INTO DatawareHouse.dbo.Log
           (procedure_name, [date], [description], table_name, number_of_row_inserted)
    VALUES ('fill_dim_station', GETDATE(),
            'rows updated', '[Global].DimStation', @rowsUpdated);

    /*---------------------------------------------------------------
      4.  End-of-run audit
    ----------------------------------------------------------------*/
    INSERT INTO DatawareHouse.dbo.Log
           (procedure_name, [date], [description], table_name, number_of_row_inserted)
    VALUES ('fill_dim_station', GETDATE(), 'end run procedure', '', 0);
END;
GO


/*********************    Procedure to fill DimRoute for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimRoute 
AS 
	BEGIN
		SET NOCOUNT ON;

		DECLARE @number_of_rows INT = 0, @desc NVARCHAR(MAX);
		/*---------------------------------------------------------------
		  0.  Start-of-run audit
		----------------------------------------------------------------*/
		EXEC [Global].LogAction
			@TableName     = N'DimRoute'
		, @RowsAffected  = 0
		, @SeverityLevel = 'INFO'
		, @Description   = N'Strting Procedure Incrementally_Fill_DimRoute to update DimRoute.'
		, @ProcedureName = N'Incrementally_Fill_DimRoute';

		IF NOT 
		(
				(NOT EXISTS (SELECT 1 FROM [Global].DimRoute)
			AND 
				EXISTS(SELECT 1 FROM [Temp].[temp1_DimRoute]))
		)

		BEGIN


			TRUNCATE TABLE [Temp].temp1_DimRoute;

			INSERT INTO [Temp].temp1_DimRoute
			(
				RouteID_BK, RouteCode, RouteName,
				PeakFrequency, OffPeakFreq,
				RouteStatusID, StatusCode, Status_EN, Status_FA
			)
			SELECT 
				RouteID_BK,
				RouteCode,
				RouteName,
				PeakFrequency,
				OffPeakFreq,
				RouteStatusID,
				StatusCode,
				Status_EN,
				Status_FA
			FROM [Global].DimRoute

			TRUNCATE TABLE [Temp].temp2_DimRoute;

			INSERT INTO [Temp].temp2_DimRoute
				(
					RouteID_BK, RouteCode, RouteName,
					PeakFrequency, OffPeakFreq,
					RouteStatusID, StatusCode, Status_EN, Status_FA
				)
			SELECT  r.RouteID,
					r.RouteCode,
					r.RouteName,
					r.PeakFrequency,
					r.OffPeakFreq,
					r.RouteStatusID,
					s.StatusCode,
					s.Label_EN,
					s.Label_FA
			FROM        TransitSA.dbo.SA_Route              AS r
			LEFT JOIN   TransitSA.dbo.SA_LkpRouteStatus     AS s
				   ON    s.RouteStatusID = r.RouteStatusID;     -- brings text labels

			
			SELECT @number_of_rows = COUNT(*) FROM [Temp].temp2_DimRoute;

			EXEC [Global].LogAction
				@TableName     = N'DimRoute'
			, @RowsAffected  = @number_of_rows
			, @SeverityLevel = 'INFO'
			, @Description   = N'Inserting to [Temp].temp2_DimRoute from SA.'
			, @ProcedureName = N'Incrementally_Fill_DimRoute';
		
			TRUNCATE TABLE [Global].DimRoute;

			INSERT INTO [Global].DimRoute
			(
				RouteID_BK,
				RouteCode,
				RouteName,
				PeakFrequency,
				OffPeakFreq,
				RouteStatusID,
				StatusCode,
				Status_EN,
				Status_FA
			)
			SELECT 
				ISNULL(t2.RouteID_BK	,t1.RouteID_BK)    ,
				ISNULL(t2.RouteCode		,t1.RouteCode)     ,
				ISNULL(t2.RouteName		,t1.RouteName)	   ,
				ISNULL(t2.PeakFrequency ,t1.PeakFrequency) ,
				ISNULL(t2.OffPeakFreq   ,t1.OffPeakFreq)   ,
				ISNULL(t2.RouteStatusID ,t1.RouteStatusID) ,
				ISNULL(t2.StatusCode    ,t1.StatusCode)    ,
				ISNULL(t2.Status_EN     ,t1.Status_EN)	   ,
				ISNULL(t2.Status_FA     ,t1.Status_FA)     
			FROM 
							[Temp].temp1_DimRoute t1
			FULL OUTER JOIN [Temp].temp2_DimRoute t2
			ON				t1.RouteID_BK = t2.RouteID_BK



			SELECT @number_of_rows = COUNT(*) FROM [Global].DimRoute;

			EXEC [Global].LogAction
				@TableName     = N'DimRoute'
			, @RowsAffected  = @number_of_rows
			, @SeverityLevel = 'INFO'
			, @Description   = N'Inserting to [Global].DimRoute from TEMP.'
			, @ProcedureName = N'Incrementally_Fill_DimRoute';



		END
	END
GO


/*********************    Procedure to fill DimVehicle for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimVehicle
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @rows           INT          = 0,
        @desc           NVARCHAR(MAX);

    /*-----------------------------------------------------------------
      0.   Start-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimVehicle',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimVehicle ETL',
         @ProcedureName = N'Incrementally_Fill_DimVehicle';
		

    /*-----------------------------------------------------------------
      1.  Safety check – previous run left temp tables half-full?
    -----------------------------------------------------------------*/
    IF NOT (
				NOT EXISTS (SELECT 1 FROM [Global].DimVehicle)
            AND 
				EXISTS (SELECT 1 FROM [Temp].temp1_DimVehicle) 
			)
    BEGIN
		/*-------------------------------------------------------------
			2.  Stage CURRENT dimension  ➜  temp1
		-------------------------------------------------------------*/
		TRUNCATE TABLE [Temp].temp1_DimVehicle;

		INSERT INTO [Temp].temp1_DimVehicle
			( VehicleID_SK
			, VehicleID_BK
			, PlateNo
			, Capacity
			, YearCreated
			, Manufacturer
			, Model
			, PurchaseDate
			, EngineNumber
			, GPSUnitSerial
			, LastOdometerKM
			, VehicleTypeID
			, TypeCode
			, Type_EN
			, Type_FA
			, CurrentStatusID
			, StatusCode
			, Status_EN
			, Status_FA
			, SCD_StartDate
			, SCD_EndDate
			, IsCurrent
			)
		SELECT
			  VehicleID_SK
			, VehicleID_BK
			, PlateNo
			, Capacity
			, YearCreated
			, Manufacturer
			, Model
			, PurchaseDate
			, EngineNumber
			, GPSUnitSerial
			, LastOdometerKM
			, VehicleTypeID
			, TypeCode
			, Type_EN
			, Type_FA
			, CurrentStatusID
			, StatusCode
			, Status_EN
			, Status_FA
			, SCD_StartDate
			, SCD_EndDate
			, IsCurrent
		FROM [Global].DimVehicle;

        SELECT @rows = COUNT(*) FROM [Temp].temp1_DimVehicle;
        SET @desc =  N'Copied current DimVehicle to temp1 ('+CONVERT(VARCHAR(20),@rows)+N' rows)';
        EXEC [Global].LogAction
             @TableName     = N'DimVehicle',
             @RowsAffected  = @rows,
             @SeverityLevel = 'INFO',
             @Description   = @desc,
             @ProcedureName = N'Incrementally_Fill_DimVehicle';

        /*-------------------------------------------------------------
          3.  Build incremental SOURCE rows  ➜  temp2
        -------------------------------------------------------------*/
        TRUNCATE TABLE [Temp].temp2_DimVehicle;

        /* 3-A  : last loaded start date per vehicle */
        ;WITH dim_last AS (
            SELECT VehicleID_BK,
                   MAX(SCD_StartDate)  AS LastLoadedStart
            FROM   [Temp].temp1_DimVehicle
            GROUP  BY VehicleID_BK
        ),
        /* 3-B  : new status-history rows since last load */
        status_delta AS (
            SELECT  h.VehicleID                   AS VehicleID_BK,
                    h.VehicleStatusID            AS CurrentStatusID,
                    h.StatusStartDT,
                    h.StatusEndDT
            FROM    TransitSA.dbo.SA_VehicleStatusHistory h
            LEFT    JOIN dim_last dl
                   ON dl.VehicleID_BK = h.VehicleID
            WHERE   dl.VehicleID_BK IS NULL             -- brand-new vehicle
                OR  h.StatusStartDT > dl.LastLoadedStart -- new state slice
        ),
        /* 3-C  : current snapshot row (StatusEndDT IS NULL) */
        latest_status AS (
            SELECT  h.VehicleID,
                    h.VehicleStatusID,
                    h.StatusStartDT,
                    ROW_NUMBER() OVER (PARTITION BY h.VehicleID
                                       ORDER BY h.StatusStartDT DESC) AS rn
            FROM    TransitSA.dbo.SA_VehicleStatusHistory h
            WHERE   h.StatusEndDT IS NULL
        )
        INSERT INTO [Temp].temp2_DimVehicle
        ( VehicleID_BK, PlateNo, Capacity, YearCreated, Manufacturer, Model,
          PurchaseDate, EngineNumber, GPSUnitSerial, LastOdometerKM,
          VehicleTypeID, TypeCode, Type_EN, Type_FA,
          CurrentStatusID, StatusCode, Status_EN, Status_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent )
        /*—— 3-D-1  : incremental status slices ——————————————*/
        SELECT  v.VehicleID,
                v.PlateNo, v.Capacity, v.YearCreated, v.Manufacturer, v.Model,
                v.PurchaseDate, v.EngineNumber, v.GPSUnitSerial, v.LastOdometerKM,
                v.VehicleTypeID, vt.TypeCode, vt.Label_EN, vt.Label_FA,
                d.CurrentStatusID, vs.StatusCode, vs.Label_EN, vs.Label_FA,
                CONVERT(DATE,d.StatusStartDT), CONVERT(DATE,d.StatusEndDT),
                CASE WHEN d.StatusEndDT IS NULL THEN 1 ELSE 0 END
        FROM        status_delta               AS d
        JOIN        TransitSA.dbo.SA_Vehicle                 AS v  ON v.VehicleID = d.VehicleID_BK
        LEFT JOIN   TransitSA.dbo.SA_LkpVehicleType          AS vt ON vt.VehicleTypeID   = v.VehicleTypeID
        LEFT JOIN   TransitSA.dbo.SA_LkpVehicleStatus        AS vs ON vs.VehicleStatusID = d.CurrentStatusID

        UNION ALL
        /*—— 3-D-2  : one “today” snapshot row per vehicle ———*/
        SELECT  v.VehicleID,
                v.PlateNo, v.Capacity, v.YearCreated, v.Manufacturer, v.Model,
                v.PurchaseDate, v.EngineNumber, v.GPSUnitSerial, v.LastOdometerKM,
                v.VehicleTypeID, vt.TypeCode, vt.Label_EN, vt.Label_FA,
                ls.VehicleStatusID, vs.StatusCode, vs.Label_EN, vs.Label_FA,
                CONVERT(DATE, ls.StatusStartDT), NULL, 1
        FROM        latest_status              AS ls
        JOIN        TransitSA.dbo.SA_Vehicle                 AS v  ON v.VehicleID = ls.VehicleID
        LEFT JOIN   TransitSA.dbo.SA_LkpVehicleType          AS vt ON vt.VehicleTypeID   = v.VehicleTypeID
        LEFT JOIN   TransitSA.dbo.SA_LkpVehicleStatus        AS vs ON vs.VehicleStatusID = ls.VehicleStatusID
        WHERE       ls.rn = 1
        AND NOT EXISTS (       /* avoid duplicate if same slice already in status_delta */
              SELECT 1
              FROM   status_delta d
              WHERE  d.VehicleID_BK   = ls.VehicleID
                AND  d.CurrentStatusID = ls.VehicleStatusID
                AND  d.StatusStartDT  = ls.StatusStartDT );

        SELECT @rows = COUNT(*) FROM [Temp].temp2_DimVehicle;
        EXEC [Global].LogAction
             @TableName     = N'temp2_DimVehicle',
             @RowsAffected  = @rows,
             @SeverityLevel = 'INFO',
             @Description   = N'Staged incremental rows + snapshot',
             @ProcedureName = N'Incrementally_Fill_DimVehicle';

        /*-------------------------------------------------------------
          4.  Build NEXT dimension  ➜  temp3
        -------------------------------------------------------------*/
        TRUNCATE TABLE [Temp].temp3_DimVehicle;

        /* 4-A  : carry forward unchanged rows */
        INSERT INTO [Temp].temp3_DimVehicle
        SELECT t1.*
        FROM   [Temp].temp1_DimVehicle t1
        WHERE  t1.IsCurrent = 0
           OR NOT EXISTS (
                SELECT 1
                FROM   [Temp].temp2_DimVehicle t2
                WHERE  t2.VehicleID_BK = t1.VehicleID_BK
                  AND 
				  ( 
						t2.SCD_StartDate      >  t1.SCD_StartDate
                     OR 
						t2.CurrentStatusID    <> t1.CurrentStatusID
                     --OR t2.LastOdometerKM     <> t1.LastOdometerKM
					 ) );

        /* 4-B  : expire current rows that have a newer slice */
        ;WITH nextStart AS (
            SELECT VehicleID_BK,
                   MIN(SCD_StartDate) AS NewStart
            FROM   [Temp].temp2_DimVehicle
            GROUP  BY VehicleID_BK
        )
        INSERT INTO [Temp].temp3_DimVehicle
        SELECT  t1.VehicleID_SK,  t1.VehicleID_BK, t1.PlateNo, t1.Capacity,
                t1.YearCreated,   t1.Manufacturer, t1.Model,    t1.PurchaseDate,
                t1.EngineNumber,  t1.GPSUnitSerial, t1.LastOdometerKM,
                t1.VehicleTypeID, t1.TypeCode,     t1.Type_EN,  t1.Type_FA,
                t1.CurrentStatusID, t1.StatusCode, t1.Status_EN, t1.Status_FA,
                t1.SCD_StartDate,   ns.NewStart, 0
        FROM   [Temp].temp1_DimVehicle t1
        JOIN   nextStart               ns ON ns.VehicleID_BK = t1.VehicleID_BK
        WHERE  t1.IsCurrent = 1
          AND  ns.NewStart  > t1.SCD_StartDate;

        /* 4-C  : insert *all* rows from temp2 as new versions */
        DECLARE @max_sk INT = ISNULL((SELECT MAX(VehicleID_SK) FROM [Temp].temp1_DimVehicle),0);

        INSERT INTO [Temp].temp3_DimVehicle
        ( VehicleID_SK, VehicleID_BK, PlateNo, Capacity, YearCreated, Manufacturer, Model,
          PurchaseDate, EngineNumber, GPSUnitSerial, LastOdometerKM,
          VehicleTypeID, TypeCode, Type_EN, Type_FA,
          CurrentStatusID, StatusCode, Status_EN, Status_FA,
          SCD_StartDate, SCD_EndDate, IsCurrent )
        SELECT  @max_sk + ROW_NUMBER() OVER (ORDER BY t2.VehicleID_BK, t2.SCD_StartDate),
                t2.VehicleID_BK, t2.PlateNo, t2.Capacity, t2.YearCreated, t2.Manufacturer, t2.Model,
                t2.PurchaseDate, t2.EngineNumber, t2.GPSUnitSerial, t2.LastOdometerKM,
                t2.VehicleTypeID, t2.TypeCode, t2.Type_EN, t2.Type_FA,
                t2.CurrentStatusID, t2.StatusCode, t2.Status_EN, t2.Status_FA,
                t2.SCD_StartDate, t2.SCD_EndDate, t2.IsCurrent
        FROM   [Temp].temp2_DimVehicle t2;

        SELECT @rows = COUNT(*) FROM [Temp].temp3_DimVehicle;
        EXEC [Global].LogAction
             @TableName     = N'temp3_DimVehicle',
             @RowsAffected  = @rows,
             @SeverityLevel = 'INFO',
             @Description   = N'Built next-state dimension',
             @ProcedureName = N'Incrementally_Fill_DimVehicle';

        /*-------------------------------------------------------------
          5.  Reload dimension from temp3
        -------------------------------------------------------------*/
        TRUNCATE TABLE [Global].DimVehicle;

        INSERT INTO [Global].DimVehicle
        SELECT * FROM [Temp].temp3_DimVehicle;

        SELECT @rows = @@ROWCOUNT;
        EXEC [Global].LogAction
             @TableName     = N'DimVehicle',
             @RowsAffected  = @rows,
             @SeverityLevel = 'INFO',
             @Description   = N'Reloaded DimVehicle from temp3',
             @ProcedureName = N'Incrementally_Fill_DimVehicle';
    END   /* END safety check */

    /*-----------------------------------------------------------------
      6.  End-of-run audit
    -----------------------------------------------------------------*/
    EXEC [Global].LogAction
         @TableName     = N'DimVehicle',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimVehicle';
END;
GO


/*********************    Procedure to fill DimVehicleStatus for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimVehicleStatus
AS
BEGIN
    SET NOCOUNT ON;

    -----------------------------------------------------------------
    -- 0.  Start-of-run audit
    -----------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'DimVehicleStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimVehicleStatus (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimVehicleStatus';

    -----------------------------------------------------------------
    -- 1.  MERGE source → dimension
    -----------------------------------------------------------------
    DECLARE @mergeLog TABLE (action NVARCHAR(10));

    MERGE  [Global].DimVehicleStatus   AS tgt
    USING  TransitSA.dbo.SA_LkpVehicleStatus AS src
          ON  tgt.[VehicleStatusIDـBK] = src.VehicleStatusID     -- BK match
    /* ---------- rows that already exist but changed ------------- */
    WHEN MATCHED AND
         (   ISNULL(tgt.StatusCode, N'') <> ISNULL(src.StatusCode, N'')
          OR ISNULL(tgt.Label_EN , N'')  <> ISNULL(src.Label_EN , N'')
          OR ISNULL(tgt.Label_FA , N'')  <> ISNULL(src.Label_FA , N'') )
      THEN UPDATE SET
           tgt.StatusCode = src.StatusCode,
           tgt.Label_EN   = src.Label_EN,
           tgt.Label_FA   = src.Label_FA
    /* ---------- brand-new status codes --------------------------- */
    WHEN NOT MATCHED BY TARGET
      THEN INSERT ([VehicleStatusIDـBK] , StatusCode , Label_EN , Label_FA)
           VALUES (src.VehicleStatusID ,  src.StatusCode , src.Label_EN , src.Label_FA)
    /* ---------- keep codes missing from source ---------------- -- */
    OUTPUT $action INTO @mergeLog(action);
    /* no WHEN NOT MATCHED BY SOURCE  →  nothing is deleted */

    -----------------------------------------------------------------
    -- 2.  Per-action logging
    -----------------------------------------------------------------
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@desc NVARCHAR(MAX);

    IF @rowsInserted > 0
		BEGIN
			SET @desc =N'Rows inserted into DimVehicleStatus: ' + CAST(@rowsInserted AS NVARCHAR(10));
			EXEC [Global].LogAction
				 @TableName     = N'DimVehicleStatus',
				 @RowsAffected  = @rowsInserted,
				 @SeverityLevel = 'INFO',
				 @Description   = @desc,
				 @ProcedureName = N'Incrementally_Fill_DimVehicleStatus';
		END
    IF @rowsUpdated > 0
		BEGIN
			SET @desc = N'Rows updated in DimVehicleStatus: '  + CAST(@rowsUpdated  AS NVARCHAR(10));
			EXEC [Global].LogAction
				 @TableName     = N'DimVehicleStatus',
				 @RowsAffected  = @rowsUpdated,
				 @SeverityLevel = 'INFO',
				 @Description   = @desc,
				 @ProcedureName = N'Incrementally_Fill_DimVehicleStatus';
		END
    -----------------------------------------------------------------
    -- 3.  End-of-run audit
    -----------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'DimVehicleStatus',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimVehicleStatus';
END;
GO


/*********************    Procedure to fill DimPaymentMethod for the incrementally    *********************/
CREATE OR ALTER PROCEDURE [Global].Incrementally_Fill_DimPaymentMethod
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- 0.  Start-of-run audit
    ------------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'DimPaymentMethod',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'Starting Incrementally_Fill_DimPaymentMethod (MERGE)',
         @ProcedureName = N'Incrementally_Fill_DimPaymentMethod';

    ------------------------------------------------------------------
    -- 1.  One MERGE:  insert + update   (no delete)
    ------------------------------------------------------------------
    DECLARE @mergeLog TABLE(action NVARCHAR(10));

    MERGE  [Global].DimPaymentMethod              AS tgt
    USING  TransitSA.dbo.SA_LkpPaymentMethod      AS src
          ON  tgt.PaymentMethodID_BK = src.PaymentMethodID      -- match on BK
    /*--- update when any descriptive attribute differs ---------*/
    WHEN MATCHED AND
         (   ISNULL(tgt.MethodCode, N'') <> ISNULL(src.MethodCode, N'')
          OR ISNULL(tgt.Label_EN  , N'') <> ISNULL(src.Label_EN  , N'')
          OR ISNULL(tgt.Label_FA  , N'') <> ISNULL(src.Label_FA  , N'') )
      THEN UPDATE
           SET tgt.MethodCode = src.MethodCode,
               tgt.Label_EN   = src.Label_EN,
               tgt.Label_FA   = src.Label_FA
    /*--- insert brand-new payment methods ----------------------*/
    WHEN NOT MATCHED BY TARGET
      THEN INSERT (PaymentMethodID_BK, MethodCode, Label_EN, Label_FA)
           VALUES (src.PaymentMethodID, src.MethodCode, src.Label_EN, src.Label_FA)
    /*--- keep rows missing from source (no delete clause) ------*/
    OUTPUT $action INTO @mergeLog(action);

    ------------------------------------------------------------------
    -- 2.  Per-action logging
    ------------------------------------------------------------------
    DECLARE
        @rowsInserted INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'INSERT'),
        @rowsUpdated  INT = (SELECT COUNT(*) FROM @mergeLog WHERE action = 'UPDATE'),
		@desc NVARCHAR(MAX);

    IF @rowsInserted > 0
	BEGIN
		SET @desc = N'Rows inserted into DimPaymentMethod: ' + CAST(@rowsInserted AS NVARCHAR(10));
        EXEC [Global].LogAction
             @TableName     = N'DimPaymentMethod',
             @RowsAffected  = @rowsInserted,
             @SeverityLevel = 'INFO',
             @Description   = @desc,
             @ProcedureName = N'Incrementally_Fill_DimPaymentMethod';
	END

    IF @rowsUpdated > 0
	BEGIN
		SET @desc = N'Rows updated in DimPaymentMethod: '  + CAST(@rowsUpdated  AS NVARCHAR(10))
        EXEC [Global].LogAction
             @TableName     = N'DimPaymentMethod',
             @RowsAffected  = @rowsUpdated,
             @SeverityLevel = 'INFO',
             @Description   = @desc,
             @ProcedureName = N'Incrementally_Fill_DimPaymentMethod';
	END
    ------------------------------------------------------------------
    -- 3.  End-of-run audit
    ------------------------------------------------------------------
    EXEC [Global].LogAction
         @TableName     = N'DimPaymentMethod',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = N'End run procedure',
         @ProcedureName = N'Incrementally_Fill_DimPaymentMethod';
END;
GO
