use TransitDW;
go 


/*********************    MiladiTOShamsi Function     *********************/
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION [Global].[MiladiTOShamsi] (@MDate DateTime) 
RETURNS Varchar(10)
AS 
BEGIN 
		DECLARE @SYear as Integer
		DECLARE @SMonth as Integer
		DECLARE @SDay as Integer
		DECLARE @AllDays as float
		DECLARE @ShiftDays as float
		DECLARE @OneYear as float
		DECLARE @LeftDays as float
		DECLARE @YearDay as Integer
		DECLARE @Farsi_Date as Varchar(100) 
		SET @MDate=@MDate-CONVERT(char,@MDate,114)

		SET @ShiftDays=466699 +2
		SET @OneYear= 365.24199


		SET @SYear = 0
		SET @SMonth = 0
		SET @SDay = 0
		SET @AllDays = CAst(@Mdate as Real)

		SET @AllDays = @AllDays + @ShiftDays

		SET @SYear = (@AllDays / @OneYear) --trunc
		SET @LeftDays = @AllDays - @SYear * @OneYear

		if (@LeftDays < 0.5)
		begin
		SET @SYear=@SYear-1
		SET @LeftDays = @AllDays - @SYear * @OneYear
		end;

		SET @YearDay = @LeftDays --trunc
		if (@LeftDays - @YearDay) >= 0.5 
		SET @YearDay=@YearDay+1

		if ((@YearDay / 31) > 6 )
		begin
		SET @SMonth = 6
		SET @YearDay=@YearDay-(6 * 31)
		SET @SMonth= @SMonth+( @YearDay / 30)
		if (@YearDay % 30) <> 0 
		SET @SMonth=@SMonth+1
		SET @YearDay=@YearDay-((@SMonth - 7) * 30)
		end 
		else
		begin
		SET @SMonth = @YearDay / 31
		if (@YearDay % 31) <> 0 
		SET @SMonth=@SMonth+1 
		SET @YearDay=@YearDay-((@SMonth - 1) * 31)
		end
		SET @SDay = @YearDay
		SET @SYear=@SYear+1

		SET @Farsi_Date = CAST (@SYear as VarChar(10)) + '/' + 
				REPLICATE('0',2-len(CAST (@SMonth as VarChar(10)))) + CAST (@SMonth as VarChar(10)) + '/' + 
				REPLICATE('0',2-len(CAST (@SDay as VarChar(10)))) + CAST (@SDay as VarChar(10))
Return @Farsi_Date

END


/*********************    ShamsiToMiladi Function     *********************/
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION [Global].[ShamsiToMiladi](@DateStr varchar(10))
RETURNS DATETIME
AS 
BEGIN 
	declare @YYear int
	declare @MMonth int
	declare @DDay int
	declare @epbase int
	declare @epyear int
	declare @mdays int
	declare @persian_jdn int
	declare @i int
	declare @j int
	declare @l int
	declare @n int
	declare @TMPRESULT varchar(10)
	declare @IsValideDate int
	declare @TempStr varchar(20)
	DECLARE @TmpDateStr varchar(10)

	SET @i=charindex('/',@DateStr)

--IF LEN(@DateStr) - CHARINDEX('/', @DateStr,CHARINDEX('/', @DateStr,1)+1) = 4
--BEGIN
--SET @TmpDateStr = dbo.ReversDate(@DateStr)
--IF ( ISDATE(@TmpDateStr) =1 ) 
--RETURN @TmpDateStr
--ELSE
--RETURN NULL
--END
--ELSE
	SET @TmpDateStr = @DateStr

	IF ((@i<>0) and 
	(ISNUMERIC(REPLACE(@TmpDateStr,'/',''))=1) and 
	(charindex('.',@TmpDateStr)=0)
	)
	BEGIN
	SET @YYear=CAST(SUBSTRING(@TmpDateStr,1,@i-1) AS INT)
	IF ( @YYear< 1300 )
	SET @YYear =@YYear + 1300
	IF @YYear > 9999
	RETURN NULL

	SET @TempStr= SUBSTRING(@TmpDateStr,@i+1,Len(@TmpDateStr))

	SET @i=charindex('/',@TempStr)
	SET @MMonth=CAST(SUBSTRING(@TempStr,1,@i-1) AS INT)
	SET @MMonth=@MMonth-- -1

	SET @TempStr= SUBSTRING(@TempStr,@i+1,Len(@TempStr)) 

	SET @DDay=CAST(@TempStr AS INT)
	SET @DDay=@DDay-- - 1

	IF ( @YYear >= 0 )
	SET @epbase = @YYear - 474
	Else
	SET @epbase = @YYear - 473
	SET @epyear = 474 + (@epbase % 2820)

	IF (@MMonth <= 7 )
	SET @mdays = ((@MMonth) - 1) * 31
	Else
	SET @mdays = ((@MMonth) - 1) * 30 + 6

	SET @persian_jdn =(@DDay) + @mdays + CAST((((@epyear * 682) - 110) / 2816) as int) + (@epyear - 1) * 365 + CAST((@epbase / 2820) as int ) * 1029983 + (1948321 - 1)



	IF (@persian_jdn > 2299160) 
		BEGIN
		SET @l = @persian_jdn + 68569
		SET @n = CAST(((4 * @l) / 146097) as int)
		SET @l = @l - CAST(((146097 * @n + 3) / 4) as int)
		SET @i = CAST(((4000 * (@l + 1)) / 1461001) as int)
		SET @l = @l - CAST( ((1461 * @i) / 4) as int) + 31
		SET @j = CAST(((80 * @l) / 2447) as int)
		SET @DDay = @l - CAST( ((2447 * @j) / 80) as int)
		SET @l = CAST((@j / 11) as int)
		SET @MMonth = @j + 2 - 12 * @l
		SET @YYear = 100 * (@n - 49) + @i + @l
		END

		SET @TMPRESULT=Cast(@MMonth as varchar(2))+'/'+CAST(@DDay as Varchar(2))+'/'+CAST(@YYear as varchar(4)) 
		RETURN Cast(@TMPRESULT as Datetime)

	END
RETURN NULL 

END
GO


/*********************    Procedure to fill DimDate for the first time    *********************/
--CREATE OR ALTER PROCEDURE [Global].First_Fill_DimDate
--AS
--BEGIN
--	IF NOT EXISTS (SELECT 1 FROM [Global].DimDate)
--		BEGIN

--			-- Logging Procedure Start
--			INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
--			VALUES (N'First_Fill_DimDate', SUSER_SNAME(), N'DimDate', null, 'INFO', N'Initial population of the DimDate table.');

--			DECLARE @YearStart	smallint
--			DECLARE @YearEnd	smallint

--			DECLARE @DateStart	datetime
--			DECLARE @DateEnd	datetime

--			DECLARE @mDate		datetime
--			DECLARE @mYear		smallint
--			DECLARE @mMonth		tinyint
--			DECLARE @mDay		tinyint

--			DECLARE @sDate		char(10)
--			DECLARE @sYear		smallint
--			DECLARE @sMonth		tinyint
--			DECLARE @sDay		tinyint

--			DECLARE @Hour		tinyint

--			DECLARE @sYearCH	char(4)
--			DECLARE @sMonthCH	char(2)
--			DECLARE @sDayCH		char(2)

--			DECLARE @HourCH		char(2)

--			DECLARE @sDayOfYear		smallint
--			DECLARE @mDayOfYear		smallint
--			DECLARE @sWeekOfYear	tinyint
--			DECLARE @mWeekOfYear	tinyint
--			DECLARE @sDayOfWeek		tinyint
--			DECLARE @mDayOfWeek		tinyint


--			DECLARE @sMonthName		nvarchar(32)
--			DECLARE @sSeasonName	nvarchar(32)
--			DECLARE @sHalfYearName	nvarchar(32)
--			DECLARE @sDayOfWeekName	nvarchar(32)

--			DECLARE @FirstDayOfYearWeekDay tinyint
 
--			-- تنظیم سالهایی که می خواهید در بعد زمان ثبت شوند
--			--------------------------------------------------
--			SET @YearStart	= 1380
--			SET @YearEnd	= 1450
--			--------------------------------------------------

--			SET @DateStart = [Global].ShamsiToMiladi (CAST(@YearStart AS varchar(4)) + '/01/01')
--			SET @DateEnd = [Global].ShamsiToMiladi (CAST(@YearEnd+1 AS varchar(4)) + '/01/01')

--			SET @mDate = @DateStart

--			WHILE @mDate < @DateEnd
--			BEGIN
--				SET @mYear = DATEPART(yy , @mDate)
--				SET @mMonth = DATEPART(mm , @mDate)
--				SET @mDay = DATEPART(dd , @mDate)
	
--				SET @sDate = [Global].MiladiTOShamsi(@mDate)	
--				SET @sDay = CAST (RIGHT (@sDate , 2) AS smallint)
--				SET @sMonth = CAST (SUBSTRING(@sDate , 6,2) AS smallint)
--				SET @sYear = CAST (LEFT(@sDate , 4) AS smallint)

--				SET @sDayCH = RIGHT (@sDate , 2) 
--				SET @sMonthCH = SUBSTRING(@sDate , 6,2) 
--				SET @sYearCH = LEFT(@sDate , 4)
		
--				SET @mDayOfWeek =  DATEPART (dw,@mDate) 
--				SET @sDayOfWeek =  DATEPART (dw,@mDate) +1
--				IF @sDayOfWeek > 7 
--					 SET @sDayOfWeek = @sDayOfWeek - 7
	
--				SET @mDayOfYear = DATEPART (dy ,@mDate)
--				IF (@sMonth = 1) AND (@sDay = 1)
--				BEGIN 
--					SET @sDayOfYear =  1
--					SET @FirstDayOfYearWeekDay = @sDayOfWeek		
--				END
--				ELSE
--				BEGIN
--					SET @sDayOfYear = @sDayOfYear + 1
--				END
	
--				--print @sDayOfYear
--				--print @FirstDayOfYearWeekDay
	
--				SET @sMonthName = 
--					CASE @sMonth 
--					WHEN 1 THEN N'فروردين'
--					WHEN 2 THEN N'ارديبهشت'
--					WHEN 3 THEN N'خرداد'
--					WHEN 4 THEN N'تير'
--					WHEN 5 THEN N'مرداد'
--					WHEN 6 THEN N'شهريور'
--					WHEN 7 THEN N'مهر'
--					WHEN 8 THEN N'آبان'
--					WHEN 9 THEN N'آذر'
--					WHEN 10 THEN N'دي'
--					WHEN 11 THEN N'بهمن'
--					WHEN 12 THEN N'اسفند'
--					END
		
--				SET @sDayOfWeekName = 
--					CASE @sDayOfWeek
--					WHEN 1 THEN N'شنبه'
--					WHEN 2 THEN N'يکشنبه'
--					WHEN 3 THEN N'دوشنبه'
--					WHEN 4 THEN N'سه شنبه'
--					WHEN 5 THEN N'چهار شنبه'
--					WHEN 6 THEN N'پنج شنبه'
--					WHEN 7 THEN N'جمعه'
--					END		

--				SET @sSeasonName = 
--					CASE CEILING(CAST(@sMonth AS float) / 3 ) 
--					WHEN 1 THEN N'سه ماهه اول'
--					WHEN 2 THEN N'سه ماهه دوم'
--					WHEN 3 THEN N'سه ماهه سوم'
--					WHEN 4 THEN N'سه ماهه چهارم'
--					END		
	
--				SET @sHalfYearName = 
--					CASE CEILING(CAST(@sMonth AS float) / 6 ) 
--					WHEN 1 THEN N'نيمسال اول'
--					WHEN 2 THEN N'نيمسال دوم'
--				END		

--				SET @mWeekOfYear =  DATEPART (ww , @mDate)
--				SET @sWeekOfYear =  CEILING( (CAST(@sDayOfYear AS float)+ CAST(@FirstDayOfYearWeekDay AS float)-1)  / 7)
	
--				SET @Hour = 1 
--				WHILE @Hour <= 24
--				BEGIN		
--					SET @HourCH =  REPLICATE ('0' , 2 - LEN(LTRIM(CAST(@Hour AS varchar(2)))) )  + CAST(@Hour AS varchar(2))
		
--					INSERT INTO [Global].[DimDate](
--						[time_Id],[time_Date_Id],[time_Key_Year_Month_Day_Hour_Native],[time_Key_Year_Month_Day_Native],
--						[time_Key_Year_Week_Native],[time_Key_Year_Month_Native],[time_Key_Year_Half_Native],
--						[time_Key_Year_Season_Native],[time_Key_Year_Native],[time_Key_Year_Month_Day_Hour],
--						[time_Key_Year_Month_Day],[time_Key_Year_Week],[time_Key_Year_Month],[time_Key_Year_Half],
--						[time_Key_Year_Season],[time_Key_Year],[time_Title_Year_Month_Day_Hour],[time_Title_Year_Month_Day],
--						[time_Title_Year_Week],[time_Title_Year_Month],[time_Title_Year_Half],[time_Title_Year_Season],
--						[time_Title_Year],[time_Year_Native],[time_Month_Native],[time_Month_Native_2Char],
--						[time_Day_Native],[time_Day_Native_2Char],[time_Hour],[time_Hour_2Char],[time_Date_Name],[time_Year],
--						[time_Month_Of_Year],[time_Month_Of_Year_2Char],[time_Month_Of_Season],[time_Month_Name],
--						[time_Day_Of_Year],[time_Day_Of_Month],[time_Day_Of_Month_2Char],[time_Day_Of_Week],[time_Day_Of_Week_Name],
--						[time_Week_Of_Year],[time_Season_Of_Year],[time_Season_Name],[time_Half_Of_Year],[time_Half_Of_Year_Name],[full_Date]
--					)
--					VALUES
--					(
--						CAST(@mDate AS int) * 100 + @Hour ,CAST(@mDate AS int) , 
--						CAST(@mYear  * 1000000	+ @mMonth * 10000	+ @mDay * 100 + @Hour  AS BIGINT),
--						@mYear  * 10000		+ @mMonth * 100		+ @mDay  ,
--						@mYear  * 100		+ @mWeekOfYear 	,
--						@mYear  * 100		+ @mMonth ,
--						@mYear  * 10		+ CEILING(CAST(@mMonth AS float) / 6 ) ,
--						@mYear  * 10		+ CEILING(CAST(@mMonth AS float) / 3 )  ,
--						@mYear  ,
--						CAST(@sYear  * 1000000	+ @sMonth * 10000	+ @sDay * 100 + @Hour AS BIGINT) ,
--						@sYear  * 10000		+ @sMonth * 100		+ @sDay  ,
--						@sYear  * 100		+ @sWeekOfYear 	,
--						@sYear  * 100		+ @sMonth ,
--						@sYear  * 10		+ CEILING(CAST(@sMonth AS float) / 6 ) ,
--						@sYear  * 10		+ CEILING(CAST(@sMonth AS float) / 3 )  ,
--						@sYear  ,			
--						N'ساعت ' + CAST(@Hour AS nvarchar(2))+ N' ' + N'روز' + N' ' + @sDate ,
--						@sDate ,N'هفته ' + CAST(@sDayOfWeek AS nvarchar(2))+ N' سال ' + @sYearCH ,
--						@sMonthName + N' ' + @sYearCH , @sHalfYearName + N' ' + @sYearCH ,@sSeasonName + N' ' + @sYearCH  , 
--						N'سال ' + @sYearCH , @sYear ,@sMonth ,@sMonthCH  ,@sDay ,@sDayCH ,@Hour ,@HourCH , 
--						N'روز' + CAST (@sDay AS nvarchar(2)) + N' ' + @sMonthName + N' ' + @sYearCH, @sYear ,@sMonth ,@sMonthCH ,
--						CASE WHEN @sMonth % 3 = 0 THEN 3 ELSE @sMonth % 3 END, @sMonthName ,@sDayOfYear ,
--						@sDay ,@sDayCH ,@sDayOfWeek ,@sDayOfWeekName ,@sWeekOfYear,
--						CEILING(CAST(@sMonth AS float) / 3) , @sSeasonName ,
--						CEILING(CAST(@sMonth AS float) / 6 ) ,@sHalfYearName,
--						CAST(@mDate AS DATE)      -- FullDate
--					)
--					SET @Hour = @Hour + 1
--				END
	
--				SET @mDate = DATEADD(day , 1, @mDate )
--			END -- while loop


--			-- Logging Procedure End

--			DECLARE @number_of_rows INT;
--			SELECT @number_of_rows = count(*) FROM [Global].[DimDate];

--			INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, [Description])
--			VALUES (N'First_Fill_DimDate', SUSER_SNAME(), N'DimDate', @number_of_rows, 'INFO', N'Procedure completed. Rows inserted into DimDate.');

--		END
--	ELSE
--		BEGIN
			
--			-- If DimDate already has data, raise an error
--			RAISERROR('DimDate table already contains data. Procedure will not run.', 16, 1)
--		END
--END
--GO;
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimDate
AS
BEGIN
    SET NOCOUNT ON;

    /* Abort if the dimension already has data */
    IF EXISTS (SELECT 1 FROM [Global].DimDate)
    BEGIN
        RAISERROR(N'DimDate table already contains data. Procedure will not run.',16,1);
        RETURN;
    END

    /* ---------- logging: start ---------- */
    INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected,
                                SeverityLevel, Description)
    VALUES (N'First_Fill_DimDate', SUSER_SNAME(), N'DimDate', NULL,
            'INFO', N'Initial population of DimDate (daily grain).');

    /* Parameter block ------------------------------------------------ */
    DECLARE
        @YearStart       SMALLINT = 1380,     -- inclusive  (Jalali)
        @YearEnd         SMALLINT = 1450,     -- inclusive  (Jalali)
        @DateStart       DATETIME,
        @DateEnd         DATETIME,
        @mDate           DATETIME,
        @mYear           SMALLINT,
        @mMonth          TINYINT,
        @mDay            TINYINT,
        @sDate           CHAR(10),            -- yyyy/MM/dd  (Jalali)
        @sYear           SMALLINT,
        @sMonth          TINYINT,
        @sDay            TINYINT,
        @sYearCH         CHAR(4),
        @sMonthCH        CHAR(2),
        @sDayCH          CHAR(2),
        @sDayOfYear      SMALLINT   = 0,
        @mDayOfYear      SMALLINT,
        @sWeekOfYear     TINYINT,
        @mWeekOfYear     TINYINT,
        @sDayOfWeek      TINYINT,
        @mDayOfWeek      TINYINT,
        @sMonthName      NVARCHAR(32),
        @sSeasonName     NVARCHAR(32),
        @sHalfYearName   NVARCHAR(32),
        @sDayOfWeekName  NVARCHAR(32),
        @FirstDayOfYearWeekDay TINYINT;

    /* Convert boundary years to Gregorian datetime ------------------- */
    SET @DateStart = [Global].ShamsiToMiladi(CAST(@YearStart AS VARCHAR(4)) + '/01/01');
    SET @DateEnd   = [Global].ShamsiToMiladi(CAST(@YearEnd + 1 AS VARCHAR(4)) + '/01/01');

    /* Main DAY loop -------------------------------------------------- */
    SET @mDate = @DateStart;

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

    /* ---------- logging: end ---------- */
    
	
	DECLARE @rows INT = (SELECT COUNT(*) FROM [Global].[DimDate]);

    INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected,
                                SeverityLevel, Description)
    VALUES (N'First_Fill_DimDate', SUSER_SNAME(), N'DimDate',
            @rows, 'INFO', N'Procedure completed. Rows (daily) inserted into DimDate.');
END
GO


/*********************    Procedure to fill DimTime for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimTime
AS
BEGIN
    -- Check if the table is empty before inserting new records
    IF NOT EXISTS (SELECT 1 FROM [Global].DimTime)
    BEGIN

		-- Logging Procedure Start
        INSERT INTO [Global].Log (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'First_Fill_DimTime', SUSER_SNAME(), N'DimTime', null, 'INFO', N'Initial population of the DimTime table.');

        -- Insert records for each minute of the day
        DECLARE @hour INT = 0;
        DECLARE @minute INT = 0;
        DECLARE @timeKey SMALLINT;
        
        -- Loop through hours (0 to 23)
        WHILE @hour < 24
        BEGIN
            -- Loop through minutes (0 to 59)
            SET @minute = 0;
            WHILE @minute < 60
            BEGIN
                -- Calculate TimeKey for the minute (e.g. 0000 for 00:00, 1420 for 14:20)
                SET @timeKey = (@hour * 100) + @minute;
                
                -- Insert into DimTime
                INSERT INTO [Global].DimTime (TimeKey, HourNo, MinuteNo)
                VALUES (@timeKey, @hour, @minute);
                
                -- Increment minute
                SET @minute = @minute + 1;
            END
            
            -- Increment hour
            SET @hour = @hour + 1;
        END

        -- Logging Procedure End
        DECLARE @rowsInserted INT = @@ROWCOUNT;
        INSERT INTO [Global].Log (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'First_Fill_DimTime', SUSER_SNAME(), N'DimTime', @rowsInserted, 'INFO', N'Procedure completed. Rows inserted into DimTime.');
    END
    ELSE
    BEGIN
        -- If DimTime already has data, raise an error
        RAISERROR('DimTime table already contains data. Procedure will not run.', 16, 1);
    END
END
Go;


/*********************    Procedure to fill DimEmployee for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimEmployee
    @option INT = 0  -- Default to 0 (raise error if not empty, 1 for truncating)
AS
BEGIN
    -- Check if the table is empty or not
    IF @option = 0  -- If @option is 0, raise an error if the table is not empty
    BEGIN
        IF EXISTS (SELECT 1 FROM [Global].DimEmployee)
        BEGIN
            RAISERROR('DimEmployee table is not empty. Please ensure the table is empty before loading data.', 16, 1);
            RETURN;
        END
    END
    ELSE IF @option = 1  -- If @option is 1, truncate the table
    BEGIN
        TRUNCATE TABLE [Global].DimEmployee;
    END
    
    -- Logging Procedure Start
    INSERT INTO [Global].Log (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (
        N'First_Fill_DimEmployee',
        SUSER_SNAME(), -- Current login
        N'DimEmployee',
        NULL,           -- Placeholder for RowsAffected
        'INFO',
        N'Initial population of the DimEmployee table with employee records from source system.'
    );


	-- Insert data from the source table to DimEmployee table
		INSERT INTO [Global].DimEmployee (
			  EmpID_SK , EmpID_BK ,
			  FirstName , LastName , NationalID , Email , PhoneNumber ,
			  Gender , DateOfBirth , HireDate , [Address] ,
			  EmergencyName , EmergencyPhone , BankAccountNo , BaseSalary ,
			  DepartmentID , DeptCode , Dept_EN , Dept_FA ,
			  CurrentRoleID , RoleCode , Role_EN , Role_FA ,
			  SCD_StartDate , SCD_EndDate , IsCurrent )
		SELECT
			  ROW_NUMBER() OVER (ORDER BY e.EmpID, rh.RoleStartDT)        AS EmpID_SK
			, e.EmpID                                                    AS EmpID_BK
			, e.FirstName , e.LastName , e.NationalID
			, e.Email , e.PhoneNumber , e.Gender , e.DateOfBirth , e.HireDate
			, e.[Address] , e.EmergencyName , e.EmergencyPhone , e.BankAccountNo
			, e.BaseSalary
			, d.DepartmentID , d.DeptCode , d.Label_EN , d.Label_FA
			, rh.RoleID , r.RoleCode , r.Label_EN , r.Label_FA
			, CONVERT(date, rh.RoleStartDT)                              AS SCD_StartDate
			, CONVERT(date, rh.RoleEndDT)                                AS SCD_EndDate
			, CASE WHEN rh.RoleEndDT IS NULL THEN 1 ELSE 0 END           AS IsCurrent
		FROM        TransitSA.dbo.SA_Employee                       AS e
		JOIN        TransitSA.dbo.SA_EmployeeRoleHistory            AS rh ON rh.EmpID = e.EmpID
		LEFT JOIN   TransitSA.dbo.SA_LkpRole                        AS r  ON r.RoleID = rh.RoleID
		LEFT JOIN   TransitSA.dbo.SA_LkpDepartment                  AS d  ON d.DepartmentID = e.DepartmentID;



	DECLARE @number_of_rows INT;
	SELECT @number_of_rows = count(*) FROM [Global].DimEmployee;

	-- Logging Procedure End
    INSERT INTO [Global].Log (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (
        N'First_Fill_DimEmployee',
        SUSER_SNAME(), -- Current login
        N'DimEmployee',
        @number_of_rows,           -- Placeholder for RowsAffected
        'INFO',
        N'Procedure completed. Rows inserted into DimEmployee.'
    );
END;
GO;


/*********************    Procedure to fill DimPaymentMethod for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimPaymentMethod
AS 
	BEGIN 
		

		TRUNCATE TABLE [Global].DimPaymentMethod;

		-- Logging Procedure Start
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimPaymentMethod',
			SUSER_SNAME(), -- Current login
			N'DimPaymentMethod',
			NULL,           -- Placeholder for RowsAffected
			'INFO',
			N'Initial population of the DimPaymentMethod table.'
		);

		INSERT INTO [Global].DimPaymentMethod
		(PaymentMethodID_BK, MethodCode, Label_EN, Label_FA)
		SELECT 
			p.PaymentMethodID,
			p.MethodCode,
			p.Label_EN,
			p.Label_FA
		FROM 
			TransitSA.dbo.[SA_LkpPaymentMethod] AS p


		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].DimPaymentMethod;

		-- Logging Procedure End
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimPaymentMethod',
			SUSER_SNAME(), -- Current login
			N'DimPaymentMethod',
			@number_of_rows,           -- Placeholder for RowsAffected
			'INFO',
			N'Procedure First_Fill_DimPaymentMethod completed. Rows inserted into DimPaymentMethod.'
		);

	END

GO;


/*********************    Procedure to fill DimRoute for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimRoute
AS 
	BEGIN 
		

		TRUNCATE TABLE [Global].DimRoute;

		-- Logging Procedure Start
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimRoute',
			SUSER_SNAME(), -- Current login
			N'DimRoute',
			NULL,           -- Placeholder for RowsAffected
			'INFO',
			N'Initial population of the DimRoute table.'
		);




		INSERT INTO [Global].DimRoute (RouteID_BK, RouteCode, RouteName, PeakFrequency, OffPeakFreq, RouteStatusID, StatusCode, Status_EN, Status_FA)
		SELECT 
			r.RouteID AS RouteID_BK, 
			r.RouteCode, 
			r.RouteName, 
			r.PeakFrequency, 
			r.OffPeakFreq, 
			r.RouteStatusID, 
			lrs.StatusCode, 
			lrs.Label_EN AS Status_EN, 
			lrs.Label_FA AS Status_FA
		FROM TransitSA.dbo.[SA_Route] r
		JOIN TransitSA.dbo.SA_LkpRouteStatus lrs ON r.RouteStatusID = lrs.RouteStatusID;



		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].DimRoute;

		-- Logging Procedure End
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimRoute',
			SUSER_SNAME(), -- Current login
			N'DimRoute',
			@number_of_rows,           -- Placeholder for RowsAffected
			'INFO',
			N'Procedure First_Fill_DimRoute completed. Rows inserted into DimRoute.'
		);

	END
GO;


/*********************    Procedure to fill DimRoute for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimStation
AS 
	BEGIN 
		

		TRUNCATE TABLE [Global].DimStation;

		-- Logging Procedure Start
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimStation',
			SUSER_SNAME(), -- Current login
			N'DimStation',
			NULL,           -- Placeholder for RowsAffected
			'INFO',
			N'Initial population of the DimStation table.'
		);




		INSERT INTO [Global].DimStation (StationID_BK, StationName, Latitude, Longitude, StreetAddress, City, ZoneCode, OpeningDate, IsAccessible)
		SELECT 
			s.StationID AS StationID_BK,
			s.StationName,
			s.Latitude,
			s.Longitude,
			s.StreetAddress,
			s.City,
			s.ZoneCode,
			s.OpeningDate,
			ISNULL(s.IsAccessible, 1) AS IsAccessible  -- If IsAccessible is NULL, default it to 1
		FROM TransitSA.dbo.SA_Station s;


		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].DimStation;

		-- Logging Procedure End
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimStation',
			SUSER_SNAME(), -- Current login
			N'DimStation',
			@number_of_rows,           -- Placeholder for RowsAffected
			'INFO',
			N'Procedure First_Fill_DimStation completed. Rows inserted into DimStation.'
		);

	END

GO;


/*********************    Procedure to fill DimVegicle for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimVehicle
AS 
	BEGIN 
		

		TRUNCATE TABLE [Global].DimVehicle;

		-- Logging Procedure Start
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimVehicle',
			SUSER_SNAME(), -- Current login
			N'DimVehicle',
			NULL,           -- Placeholder for RowsAffected
			'INFO',
			N'Initial population of the DimVehicle table.'
		);


				-- Insert into DimVehicle with history tracking
		WITH VehicleStatusHistoryCTE AS (
			-- This Common Table Expression (CTE) gets the status history for each vehicle
			SELECT 
				v.VehicleID,
				v.PlateNo,
				v.Capacity,
				v.YearCreated,
				v.Manufacturer,
				v.Model,
				v.PurchaseDate,
				v.EngineNumber,
				v.GPSUnitSerial,
				v.LastOdometerKM,
				v.VehicleTypeID,
				vt.TypeCode,
				vt.Label_EN AS Type_EN,
				vt.Label_FA AS Type_FA,
				vsh.VehicleStatusID,
				vs.StatusCode,
				vs.Label_EN AS Status_EN,
				vs.Label_FA AS Status_FA,
				vsh.StatusStartDT AS SCD_StartDate,
				vsh.StatusEndDT AS SCD_EndDate,
				CASE 
					WHEN vsh.StatusEndDT IS NULL THEN 1  -- Current status
					ELSE 0  -- Expired status
				END AS IsCurrent
			FROM TransitSA.dbo.SA_Vehicle AS v
			INNER JOIN TransitSA.dbo.SA_LkpVehicleType AS vt ON v.VehicleTypeID = vt.VehicleTypeID
			INNER JOIN TransitSA.dbo.SA_VehicleStatusHistory AS vsh ON v.VehicleID = vsh.VehicleID
			INNER JOIN TransitSA.dbo.SA_LkpVehicleStatus AS vs ON vsh.VehicleStatusID = vs.VehicleStatusID
		)
		-- Insert the records into DimVehicle
		INSERT INTO [Global].DimVehicle (
			VehicleID_SK,VehicleID_BK, PlateNo, Capacity, YearCreated, Manufacturer, 
			Model, PurchaseDate, EngineNumber, GPSUnitSerial, LastOdometerKM, 
			VehicleTypeID, TypeCode, Type_EN, Type_FA, CurrentStatusID, 
			StatusCode, Status_EN, Status_FA, SCD_StartDate, SCD_EndDate, IsCurrent
		)
		SELECT
			ROW_NUMBER() OVER (ORDER BY vsh.VehicleID),
			vsh.VehicleID AS VehicleID_BK,
			vsh.PlateNo,
			vsh.Capacity,
			vsh.YearCreated,
			vsh.Manufacturer,
			vsh.Model,
			vsh.PurchaseDate,
			vsh.EngineNumber,
			vsh.GPSUnitSerial,
			vsh.LastOdometerKM,
			vsh.VehicleTypeID,
			vsh.TypeCode,
			vsh.Type_EN,
			vsh.Type_FA,
			vsh.VehicleStatusID AS CurrentStatusID,
			vsh.StatusCode,
			vsh.Status_EN,
			vsh.Status_FA,
			vsh.SCD_StartDate,
			vsh.SCD_EndDate,
			vsh.IsCurrent
		FROM VehicleStatusHistoryCTE vsh
		-- Filter out only the current active statuses (or you can add other conditions)
		--WHERE vsh.IsCurrent = 1;






		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].DimVehicle;

		-- Logging Procedure End
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimVehicle',
			SUSER_SNAME(), -- Current login
			N'DimVehicle',
			@number_of_rows,           -- Placeholder for RowsAffected
			'INFO',
			N'Procedure First_Fill_DimVehicle completed. Rows inserted into DimVehicle.'
		);

	END
GO;


/*********************    Procedure to fill DimVehicleStatus for the first time    *********************/
CREATE OR ALTER PROCEDURE [Global].First_Fill_DimVehicleStatus
AS
	BEGIN 

		TRUNCATE TABLE [Global].DimVehicleStatus;

		-- Logging Procedure Start
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimVehicleStatus',
			SUSER_SNAME(), -- Current login
			N'DimVehicleStatus',
			NULL,           -- Placeholder for RowsAffected
			'INFO',
			N'Initial population of the DimVehicleStatus table.'
		);

		INSERT INTO [Global].DimVehicleStatus
		(VehicleStatusIDـBK, StatusCode, Label_EN, Label_FA)
		SELECT 
			v.VehicleStatusID,
			v.StatusCode,
			v.Label_EN,
			v.Label_FA
		FROM 
			TransitSA.dbo.[SA_LkpVehicleStatus] AS v


		DECLARE @number_of_rows INT;
		SELECT @number_of_rows = count(*) FROM [Global].DimVehicleStatus;

		-- Logging Procedure End
		INSERT INTO [Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
		VALUES (
			N'First_Fill_DimVehicleStatus',
			SUSER_SNAME(), -- Current login
			N'DimVehicleStatus',
			@number_of_rows,           -- Placeholder for RowsAffected
			'INFO',
			N'Procedure First_Fill_DimVehicleStatus completed. Rows inserted into DimVehicleStatus.'
		);

	END
GO;