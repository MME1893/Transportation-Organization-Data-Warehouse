Use TransitDW;

go
-- CREATE SCHEMA [Global];


IF OBJECT_ID('[Global].[DimDate]', 'U') IS NOT NULL DROP TABLE [Global].[DimDate];
IF OBJECT_ID('[Global].DimTime', 'U') IS NOT NULL DROP TABLE [Global].DimTime;
IF OBJECT_ID('[Global].DimStation', 'U') IS NOT NULL DROP TABLE [Global].DimStation;
IF OBJECT_ID('[Global].DimRoute', 'U') IS NOT NULL DROP TABLE [Global].DimRoute;
IF OBJECT_ID('[Global].DimVehicle', 'U') IS NOT NULL DROP TABLE [Global].DimVehicle;
IF OBJECT_ID('[Global].DimVehicleStatus', 'U') IS NOT NULL DROP TABLE [Global].DimVehicleStatus;
IF OBJECT_ID('[Global].DimEmployee', 'U') IS NOT NULL DROP TABLE [Global].DimEmployee;
IF OBJECT_ID('[Global].DimPaymentMethod', 'U') IS NOT NULL DROP TABLE [Global].DimPaymentMethod;








/*===============================================================================
						 Global / Shared Dimentions
===============================================================================*/




--/*********************    DimDate Table    *********************/--

Go
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



CREATE TABLE [Global].[DimDate](
	[time_Date_Id] [int] NOT NULL,
	--[time_Key_Year_Month_Day_Hour_Native] [int] NULL,
	[time_Key_Year_Month_Day_Native] [int] NULL,
	[time_Key_Year_Week_Native] [int] NULL,
	[time_Key_Year_Month_Native] [int] NULL,
	[time_Key_Year_Half_Native] [smallint] NULL,
	[time_Key_Year_Season_Native] [smallint] NULL,
	[time_Key_Year_Native] [smallint] NULL,
	--[time_Key_Year_Month_Day_Hour] [bigint] NULL,
	[time_Key_Year_Month_Day] [int] NULL,
	[time_Key_Year_Week] [int] NULL,
	[time_Key_Year_Month] [int] NULL,
	[time_Key_Year_Half] [smallint] NULL,
	[time_Key_Year_Season] [smallint] NULL,
	[time_Key_Year] [smallint] NULL,
	--[time_Title_Year_Month_Day_Hour] [nvarchar](128) NULL,
	[time_Title_Year_Month_Day] [nvarchar](64) NULL,
	[time_Title_Year_Week] [nvarchar](64) NULL,
	[time_Title_Year_Month] [nvarchar](64) NULL,
	[time_Title_Year_Half] [nvarchar](64) NULL,
	[time_Title_Year_Season] [nvarchar](64) NULL,
	[time_Title_Year] [nvarchar](16) NULL,
	[time_Year_Native] [smallint] NULL,
	[time_Month_Native] [tinyint] NULL,
	[time_Month_Native_2Char] [char](2) NULL,
	[time_Day_Native] [tinyint] NULL,
	[time_Day_Native_2Char] [char](2) NULL,
	--[time_Hour] [tinyint] NULL,
	--[time_Hour_2Char] [char](2) NULL,
	[time_Date_Name] [nvarchar](128) NULL,
	[time_Year] [smallint] NULL,
	[time_Month_Of_Year] [tinyint] NULL,
	[time_Month_Of_Year_2Char] [char](2) NULL,
	[time_Month_Of_Season] [tinyint] NULL,
	[time_Month_Name] [nvarchar](32) NULL,
	[time_Day_Of_Year] [smallint] NULL,
	[time_Day_Of_Month] [tinyint] NULL,
	[time_Day_Of_Month_2Char] [char](2) NULL,
	[time_Day_Of_Week] [tinyint] NULL,
	[time_Day_Of_Week_Name] [nvarchar](128) NULL,
	[time_Week_Of_Year] [tinyint] NULL,
	[time_Season_Of_Year] [tinyint] NULL,
	[time_Season_Name] [nvarchar](32) NULL,
	[time_Half_Of_Year] [tinyint] NULL,
	[time_Half_Of_Year_Name] [nvarchar](32) NULL,
	[full_Date] DATE
 CONSTRAINT [PK_global_Dim_Times] PRIMARY KEY CLUSTERED 
(
	[time_Date_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
);



--/*********************    DimTime Table    *********************/--

CREATE TABLE [Global].DimTime (          -- grain = minute
    TimeKey         SMALLINT   ,-- 1420
    HourNo          TINYINT    ,
    MinuteNo        TINYINT    
	-- add label for persian and english both 
	
);


--/*********************    DimStation Table    *********************/--

CREATE TABLE [Global].DimStation (
    StationID_BK   INT           , -- UNIQUE
    StationName    NVARCHAR(150) , -- 50 char more
    Latitude       DECIMAL(9,6)  ,
    Longitude      DECIMAL(9,6)  ,
	StreetAddress  NVARCHAR(200) , -- 50 more
    City           NVARCHAR(100) , -- 50 more
    ZoneCode       VARCHAR(15)   , -- 5 more
    OpeningDate    DATE   , -- yyyymmdd
    IsAccessible   VARCHAR(10) -- yes or no 
);



--/*********************    DimRoute Table    *********************/--


CREATE TABLE [Global].DimRoute (
    RouteID_BK     INT         , -- UNIQUE
    RouteCode      VARCHAR(15), -- 5 char more
    RouteName      NVARCHAR(150), -- 50 char more
    PeakFrequency  TINYINT ,
	OffPeakFreq    TINYINT ,
    RouteStatusID  INT         ,               -- FK to lookup
    StatusCode     VARCHAR(50),
    Status_EN      VARCHAR(100),
    Status_FA      NVARCHAR(100)
);

--/*********************    DimVehicle Table    *********************/--

CREATE TABLE [Global].DimVehicle ( 
	VehicleID_SK    INT         ,
    VehicleID_BK    INT         , -- UNIQUE
    PlateNo         VARCHAR(15),
    Capacity        SMALLINT,
    YearCreated     SMALLINT  ,
    Manufacturer    VARCHAR(100) ,
    Model           VARCHAR(100) ,
    PurchaseDate    DATE ,
    EngineNumber    VARCHAR(50) ,
    GPSUnitSerial   VARCHAR(50) ,
    LastOdometerKM  INT ,
	VehicleTypeID   INT         ,
    TypeCode        VARCHAR(50),
    Type_EN         VARCHAR(100),
    Type_FA         NVARCHAR(100),
    CurrentStatusID INT         ,
    StatusCode      VARCHAR(50),
    Status_EN       VARCHAR(100),
    Status_FA       NVARCHAR(100),
    SCD_StartDate   DATE      ,
    SCD_EndDate     DATE       ,
    IsCurrent       BIT       
);


--/*********************    DimVehicleStatus Table    *********************/--


CREATE TABLE [Global].DimVehicleStatus (
    VehicleStatusIDـBK  INT , -- UNIQUE,       -- business key from LkpVehicleStatus
    StatusCode          VARCHAR(50)  ,
    Label_EN            VARCHAR(100)  ,
    Label_FA            NVARCHAR(100) 
);


--/*********************    DimEmployee Table    *********************/--

CREATE TABLE [Global].DimEmployee (
	EmpID_SK            INT,
    EmpID_BK            INT, -- UNIQUE    -- business key from Employee.EmpID
    FirstName           NVARCHAR(100) ,
    LastName            NVARCHAR(100) ,
    NationalID          CHAR(15),
    Email               NVARCHAR(100) ,
    PhoneNumber         VARCHAR(50)   ,
    Gender              VARCHAR(20) ,
    DateOfBirth         DATE          ,
    HireDate            DATE          ,
    [Address]           NVARCHAR(250) ,
    EmergencyName       NVARCHAR(150) ,
    EmergencyPhone      VARCHAR(50) ,
    BankAccountNo       VARCHAR(50) ,
    BaseSalary          MONEY ,
    DepartmentID        INT           ,
    DeptCode            VARCHAR(50)   ,
    Dept_EN             VARCHAR(100)   ,
    Dept_FA             NVARCHAR(100)  ,
    CurrentRoleID       INT           ,
    RoleCode            VARCHAR(50)   ,
    Role_EN             VARCHAR(100)   ,
    Role_FA             NVARCHAR(100)  ,
    
    SCD_StartDate       DATE          ,
    SCD_EndDate         DATE          ,
    IsCurrent           BIT      
);



--/*********************    DimPaymentMethod Table    *********************/--

CREATE TABLE [Global].DimPaymentMethod (
    PaymentMethodID_BK  INT        , -- UNIQUE
    MethodCode          VARCHAR(50),
    Label_EN            VARCHAR(100),
    Label_FA            NVARCHAR(100)
);




--/*********************    Log Table    *********************/--


CREATE TABLE [Global].[Log] (
    LogID               BIGINT       IDENTITY,    
        -- Surrogate key for easy reference and clustering
    
    LogDate             DATETIME2    NOT NULL
        CONSTRAINT DF_Log_LogDate DEFAULT SYSUTCDATETIME(), 
        -- When the event was logged (default = current UTC‐adjusted timestamp)
    
    ProcedureName       VARCHAR(128) NOT NULL,                
        -- Name (or identifier) of the stored procedure/job
    
    ExecutedBy          VARCHAR(128) NULL,                    
        -- Optional: user or service account that executed it (e.g. Svc_ETL, DOMAIN\User)
    
    TableName           VARCHAR(128) NULL,                    
        -- Which target table was affected (if any)
    
    RowsAffected        INT          NULL,                    
        -- Number of rows inserted/updated/deleted (INT rather than VARCHAR)
    
    SeverityLevel       VARCHAR(20)  NOT NULL 
        CONSTRAINT DF_Log_SeverityLevel DEFAULT 'INFO',  
        -- e.g. INFO, WARN, ERROR; helps classify log entries
        
    Description         VARCHAR(512) NULL,                    
        -- Free‐text details: success message, error message, etc.

    CONSTRAINT CK_Log_SeverityLevel 
        CHECK (SeverityLevel IN ('DEBUG','INFO','WARN','ERROR','FATAL'))
        -- Restrict to known levels
);



