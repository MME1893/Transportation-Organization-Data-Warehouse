Use TransitDW;

go
 CREATE SCHEMA [Transport];


IF OBJECT_ID('[Transport].[DimJourneyStatus]', 'U')		IS NOT NULL			DROP TABLE [Transport].[DimJourneyStatus];
IF OBJECT_ID('[Transport].[DimRouteStatus]', 'U')		IS NOT NULL			DROP TABLE [Transport].[DimRouteStatus];
IF OBJECT_ID('[Transport].[DimDevice]', 'U')			IS NOT NULL				DROP TABLE [Transport].DimDevice;

IF OBJECT_ID('[Transport].[FactTrnsTap]', 'U') IS NOT NULL				DROP TABLE [Transport].[FactTrnsTap];
IF OBJECT_ID('[Transport].[FactDailyTap]', 'U') IS NOT NULL				DROP TABLE [Transport].[FactDailyTap];
IF OBJECT_ID('[Transport].[FactAccTap]', 'U') IS NOT NULL				DROP TABLE [Transport].[FactAccTap];
IF OBJECT_ID('[Transport].[FactTrnsArrival]', 'U') IS NOT NULL			DROP TABLE [Transport].[FactTrnsArrival];
IF OBJECT_ID('[Transport].[FactAccJourney]', 'U') IS NOT NULL			DROP TABLE [Transport].[FactAccJourney];
IF OBJECT_ID('[Transport].[FactDailyVehicleStatus]', 'U') IS NOT NULL	DROP TABLE [Transport].[FactDailyVehicleStatus];








/*===============================================================================
						 Transport Mart Dimentions
===============================================================================*/


/*********************    DimJourneyStatus Table    *********************/
CREATE TABLE [Transport].DimJourneyStatus (
	JourneyStatusID_BK INT      ,
	StatusCode    VARCHAR(50)   ,  
	Label_EN      VARCHAR(100)  ,
	Label_FA      NVARCHAR(100) 
);


/*********************    DimRouteStatus Table    *********************/
CREATE TABLE [Transport].DimRouteStatus (
    RouteStatusID_BK INT     ,
    StatusCode       VARCHAR(50),
    Label_EN         VARCHAR(100),
    Label_FA         NVARCHAR(100)
);


/*********************    DimDevice Table (scd1)   *********************/
CREATE TABLE [Transport].DimDevice (
    DeviceID_BK      INT  ,
    DeviceCode       VARCHAR(50),
    DeviceTypeID     INT,
    TypeCode         VARCHAR(50),
    Type_EN          VARCHAR(100),
    Type_FA          NVARCHAR(100),
    DeviceStatusID   INT,
    StatusCode       VARCHAR(50),
    Status_EN        VARCHAR(100),
    Status_FA        NVARCHAR(100),
	InstallDate      DATE, -- زمان به کار بگیری در سازمان 
    SerialNo         VARCHAR(50),
	FirmwareVersion  VARCHAR(50) ,
    LastServiceDT    DATE,
    IPAddress        VARCHAR(50)
);


/*===============================================================================
						 Transport Mart Facts
===============================================================================*/


/*********************    FactTrnsTap Table    *********************/--
CREATE TABLE [Transport].FactTrnsTap (        -- transactional tap‐in
    DateKey         INT , --NOT NULL REFERENCES DimDate(DateKey),
    TimeKey         SMALLINT , --NOT NULL REFERENCES DimTime(TimeKey),
    StationKey      INT , --NOT NULL REFERENCES DimStation(StationKey),
    RouteKey        INT , --NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey INT , --NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    DeviceKey       INT , --NOT NULL REFERENCES DimDevice(DeviceKey),
    FareAmount      MONEY --  NOT NULL
);


/*********************    FactDailyCardTap Table    *********************/--
CREATE TABLE [Transport].FactDailyTap (
    DateKey          INT , -- NOT NULL REFERENCES DimDate(DateKey)
    StationKey       INT , -- NOT NULL REFERENCES DimStation(StationKey),
    RouteKey         INT , -- NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey INT , -- NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    TotalBoardings   INT ,
    TotalRevenue     MONEY
    -- we will have : PRIMARY KEY (DateKey, TimeKey, StationKey, RouteKey, PaymentMethodKey)
);


/*********************    FactAccTap Table    *********************/--
CREATE TABLE [Transport].FactAccTap (
    StationKey        INT , --   NOT NULL REFERENCES DimStation(StationKey),
    RouteKey          INT , --  NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey  INT , -- NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    TotalBoardings    INT , --   NOT NULL DEFAULT 0, sum of all taps
    TotalRevenue      MONEY , -- NOT NULL DEFAULT 0, sum of FareAmount
	MaxRevenue		  MONEY  , -- NOT NULL DEFAULT 0, 
	MinRevenue		  MONEY  -- NOT NULL DEFAULT 0,
   -- we will have :    PRIMARY KEY (SnapshotDateKey, StationKey, RouteKey, PaymentMethodKey)
);

CREATE TABLE [Transport].TimeAccFactTap( [Date] DATE PRIMARY KEY );


/*********************    FactTrnsArrival Table    *********************/
CREATE TABLE [Transport].FactTrnsArrival (
    /* ─────────────── grain identifiers ─────────────── */
    JourneyID_BK       BIGINT   ,                      -- business key from OLTP
    StationKey         INT      ,					   --   NOT NULL REFERENCES DimStation(StationKey),

    /* ────────── dimension foreign keys ─────────────── */
    DateKey            INT      ,	--   NOT NULL REFERENCES DimDate(DateKey),   -- arrival date

    PlannedStartTK     SMALLINT		,
    ActualStartTK      SMALLINT		,
    PlannedEndTK       SMALLINT		,
    ActualEndTK        SMALLINT		,


    VehicleKey         INT      ,	--   NOT NULL REFERENCES DimVehicle(VehicleKey),
    RouteKey           INT      ,	--   NOT NULL REFERENCES DimRoute(RouteKey),
    DriverKey          INT      ,	--   NOT NULL REFERENCES DimEmployee(EmployeeKey),
    JourneyStatusKey   INT      ,	--   NOT NULL REFERENCES LkpJourneyStatus(JourneyStatusID),

    /* ─────────────── header-level data (duplicated) ───────────────── */

    DistanceKM         DECIMAL(7,2) ,
    PassengerCount     INT          ,
    -- TotalRevenue       MONEY        , we dont have this souce :)

    /* ─────────────── stop-level measures ─────────────────────────── */
    CardBoarded        SMALLINT     , --NOT NULL DEFAULT 0,
    TicketBoarded      SMALLINT     , --NOT NULL DEFAULT 0,
	BoardedCnt          SMALLINT    ,
    AlightedCnt        SMALLINT     , --NOT NULL DEFAULT 0,
    DelaySeconds       INT          --NULL,

    /* ─────────────── composite primary key ───────────────────────── */
    --PRIMARY KEY (JourneyID_BK, StationKey)
);


/*********************    FactAccJourney Table    *********************/
CREATE TABLE [Transport].FactAccJourney (
    JourneyID_BK       BIGINT ,                      -- business key from OLTP
	DateKey INT,
	VehicleKey INT ,	--	NOT NULL REFERENCES DimVehicle(VehicleKey),
	RouteKey INT ,	-- NOT NULL REFERENCES DimRoute(RouteKey), 
	DriverKey INT  ,	-- NOT NULL REFERENCES DimEmployee(EmployeeKey),
	TotalPassengers INT, 
	MaxPassengers INT, 
	AvgPassengers INT, 
	TotalDelay INT, 
	DistanceKM DECIMAL(9,2)
);


/*********************    FactDailyVehicleStatus Table    *********************/
CREATE TABLE [Transport].FactDailyVehicleStatus (   -- daily snapshot
    DateKey			INT  ,	-- NOT NULL REFERENCES DimDate(DateKey),
    VehicleKey		INT  ,	-- NOT NULL REFERENCES DimVehicle(VehicleKey),
	StatusKey		INT  ,	-- NOT NULL REFERENCES DimVehicleStatus(VehicleStatusKey),
    --KMRunToday		INT, -- i doubt if we really need this field ... 
    ActiveHours		DECIMAL(6,2),
    TotalPassengers INT
);