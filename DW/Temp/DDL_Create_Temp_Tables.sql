Use TransitDW;

CREATE SCHEMA Temp
go


--/*********************    DimEmployee Table    *********************/--

CREATE TABLE Temp.temp1_DimEmployee (
	EmpID_SK		INT,
    EmpID_BK        INT         , -- UNIQUE    -- business key from Employee.EmpID
    FirstName NVARCHAR(100) ,
    LastName NVARCHAR(100) ,
    NationalID CHAR(15),
    Email           NVARCHAR(100) ,
    PhoneNumber     VARCHAR(50)   ,
    Gender VARCHAR(20) ,
    DateOfBirth     DATE          ,
    HireDate        DATE          ,
    [Address] NVARCHAR(250) ,
    EmergencyName NVARCHAR(150) ,
    EmergencyPhone VARCHAR(50) ,
    BankAccountNo    VARCHAR(50) ,
    BaseSalary       MONEY ,
    DepartmentID    INT           ,
    DeptCode        VARCHAR(50)   ,
    Dept_EN         VARCHAR(100)   ,
    Dept_FA         NVARCHAR(100)  ,
    CurrentRoleID   INT           ,
    RoleCode        VARCHAR(50)   ,
    Role_EN         VARCHAR(100)   ,
    Role_FA         NVARCHAR(100)  ,
    
    SCD_StartDate   DATE          ,
    SCD_EndDate     DATE          ,
    IsCurrent       BIT      
);

CREATE TABLE Temp.temp2_DimEmployee (
	EmpID_SK		INT,
    EmpID_BK        INT         , -- UNIQUE    -- business key from Employee.EmpID
    FirstName NVARCHAR(100) ,
    LastName NVARCHAR(100) ,
    NationalID CHAR(15),
    Email           NVARCHAR(100) ,
    PhoneNumber     VARCHAR(50)   ,
    Gender VARCHAR(20) ,
    DateOfBirth     DATE          ,
    HireDate        DATE          ,
    [Address] NVARCHAR(250) ,
    EmergencyName NVARCHAR(150) ,
    EmergencyPhone VARCHAR(50) ,
    BankAccountNo    VARCHAR(50) ,
    BaseSalary       MONEY ,
    DepartmentID    INT           ,
    DeptCode        VARCHAR(50)   ,
    Dept_EN         VARCHAR(100)   ,
    Dept_FA         NVARCHAR(100)  ,
    CurrentRoleID   INT           ,
    RoleCode        VARCHAR(50)   ,
    Role_EN         VARCHAR(100)   ,
    Role_FA         NVARCHAR(100)  ,
    
    SCD_StartDate   DATE          ,
    SCD_EndDate     DATE          ,
    IsCurrent       BIT      
);

CREATE TABLE Temp.temp3_DimEmployee (
	EmpID_SK		INT,
    EmpID_BK        INT         , -- UNIQUE    -- business key from Employee.EmpID
    FirstName NVARCHAR(100) ,
    LastName NVARCHAR(100) ,
    NationalID CHAR(15),
    Email           NVARCHAR(100) ,
    PhoneNumber     VARCHAR(50)   ,
    Gender VARCHAR(20) ,
    DateOfBirth     DATE          ,
    HireDate        DATE          ,
    [Address] NVARCHAR(250) ,
    EmergencyName NVARCHAR(150) ,
    EmergencyPhone VARCHAR(50) ,
    BankAccountNo    VARCHAR(50) ,
    BaseSalary       MONEY ,
    DepartmentID    INT           ,
    DeptCode        VARCHAR(50)   ,
    Dept_EN         VARCHAR(100)   ,
    Dept_FA         NVARCHAR(100)  ,
    CurrentRoleID   INT           ,
    RoleCode        VARCHAR(50)   ,
    Role_EN         VARCHAR(100)   ,
    Role_FA         NVARCHAR(100)  ,
    
    SCD_StartDate   DATE          ,
    SCD_EndDate     DATE          ,
    IsCurrent       BIT      
);


CREATE TABLE Temp.temp1_DimStation(
    StationID_BK   INT          , -- UNIQUE
    StationName    NVARCHAR(150), -- 50 char more
    Latitude       DECIMAL(9,6),
    Longitude      DECIMAL(9,6),
	StreetAddress  NVARCHAR(200) , -- 50 more
    City           NVARCHAR(100)  , -- 50 more
    ZoneCode       VARCHAR(15)   , -- 5 more
    OpeningDate    DATE          ,
    IsAccessible   VARCHAR(10) -- yes or no 
);

CREATE TABLE [Temp].temp1_DimRoute
(
    RouteID_BK    INT PRIMARY KEY,           -- business key
    RouteCode     VARCHAR(15),
    RouteName     NVARCHAR(150),
    PeakFrequency TINYINT,
    OffPeakFreq   TINYINT,
    RouteStatusID INT,
    StatusCode    VARCHAR(50),
    Status_EN     VARCHAR(100),
    Status_FA     NVARCHAR(100)
);

CREATE TABLE [Temp].temp2_DimRoute
(
    RouteID_BK    INT PRIMARY KEY,           -- business key
    RouteCode     VARCHAR(15),
    RouteName     NVARCHAR(150),
    PeakFrequency TINYINT,
    OffPeakFreq   TINYINT,
    RouteStatusID INT,
    StatusCode    VARCHAR(50),
    Status_EN     VARCHAR(100),
    Status_FA     NVARCHAR(100)
);

CREATE TABLE [Temp].temp1_DimVehicle ( 
	VehicleID_SK	INT,

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


CREATE TABLE [Temp].temp2_DimVehicle ( 
	VehicleID_SK	INT,

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

CREATE TABLE [Temp].temp3_DimVehicle ( 
	VehicleID_SK	INT,

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

CREATE TABLE [Temp].temp1_FactAccTap (
    StationKey        INT , --   NOT NULL REFERENCES DimStation(StationKey),
    RouteKey          INT , --  NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey  INT , -- NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    TotalBoardings    INT , --   NOT NULL DEFAULT 0, sum of all taps
    TotalRevenue      MONEY , -- NOT NULL DEFAULT 0, sum of FareAmount
	MaxRevenue MONEY  , -- NOT NULL DEFAULT 0, 
	MinRevenue MONEY , -- NOT NULL DEFAULT 0,
);

CREATE TABLE [Temp].temp2_FactAccTap (
    StationKey        INT , --   NOT NULL REFERENCES DimStation(StationKey),
    RouteKey          INT , --  NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey  INT , -- NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    TotalBoardings    INT , --   NOT NULL DEFAULT 0, sum of all taps
    TotalRevenue      MONEY , -- NOT NULL DEFAULT 0, sum of FareAmount
	MaxRevenue MONEY  , -- NOT NULL DEFAULT 0, 
	MinRevenue MONEY , -- NOT NULL DEFAULT 0,
);

CREATE TABLE [Temp].temp3_FactAccTap (
    StationKey        INT , --   NOT NULL REFERENCES DimStation(StationKey),
    RouteKey          INT , --  NOT NULL REFERENCES DimRoute(RouteKey),
    PaymentMethodKey  INT , -- NOT NULL REFERENCES DimPaymentMethod(PaymentMethodKey),
    TotalBoardings    INT , --   NOT NULL DEFAULT 0, sum of all taps
    TotalRevenue      MONEY , -- NOT NULL DEFAULT 0, sum of FareAmount
	MaxRevenue MONEY  , -- NOT NULL DEFAULT 0, 
	MinRevenue MONEY , -- NOT NULL DEFAULT 0,
);

CREATE TABLE [Temp].temp4_FactAccTap 
	(StationKey INT, RouteKey INT, PaymentMethodKey INT,TotalBoardings INT, TotalRevenue MONEY, MaxRevenue MONEY, MinRevenue MONEY);
CREATE TABLE [Temp].temp5_FactAccTap 
	(StationKey INT, RouteKey INT, PaymentMethodKey INT,TotalBoardings INT, TotalRevenue MONEY, MaxRevenue MONEY, MinRevenue MONEY);
CREATE TABLE [Temp].temp6_FactAccTap 
	(StationKey INT, RouteKey INT, PaymentMethodKey INT,TotalBoardings INT, TotalRevenue MONEY, MaxRevenue MONEY, MinRevenue MONEY);

/***************************************************************************************/

CREATE TABLE [Temp].temp1_FactAccCardTopUp
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

CREATE TABLE [Temp].temp2_FactAccCardTopUp
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

CREATE TABLE [Temp].temp3_FactAccCardTopUp 
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

CREATE TABLE [Temp].temp4_FactAccCardTopUp
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL

);

CREATE TABLE [Temp].temp5_FactAccCardTopUp
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

CREATE TABLE [Temp].temp6_FactAccCardTopUp
(
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

/***************************************************************************************/

CREATE TABLE [Temp].temp1_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)

CREATE TABLE [Temp].temp2_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)

CREATE TABLE [Temp].temp3_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)

CREATE TABLE [Temp].temp4_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)

CREATE TABLE [Temp].temp5_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)

CREATE TABLE [Temp].temp6_FactAccTicketSale
(
	StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
)