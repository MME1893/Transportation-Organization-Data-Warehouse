Use TransitDW;

go
CREATE SCHEMA [Financial]



IF OBJECT_ID('[Financial].[DimCardType]', 'U') IS NOT NULL DROP TABLE [Financial].[DimCardType];
IF OBJECT_ID('[Financial].[DimCardStatus]', 'U') IS NOT NULL DROP TABLE [Financial].[DimCardStatus];
IF OBJECT_ID('[Financial].[DimSalesChannel]', 'U') IS NOT NULL DROP TABLE [Financial].[DimSalesChannel];

IF OBJECT_ID('[Financial].[FactTrnsCardTopUp]', 'U') IS NOT NULL DROP TABLE [Financial].[FactTrnsCardTopUp];
IF OBJECT_ID('[Financial].[FactDailyCardTopUp]', 'U') IS NOT NULL DROP TABLE [Financial].[FactDailyCardTopUp];
IF OBJECT_ID('[Financial].[FactAccCardTopUp]', 'U') IS NOT NULL DROP TABLE [Financial].[FactAccCardTopUp];
IF OBJECT_ID('[Financial].[FactTrnsTicketSale]', 'U') IS NOT NULL DROP TABLE [Financial].[FactTrnsTicketSale];
IF OBJECT_ID('[Financial].[FactDailyTicketSale]', 'U') IS NOT NULL DROP TABLE [Financial].[FactDailyTicketSale];
IF OBJECT_ID('[Financial].[FactAccTicketSale]', 'U') IS NOT NULL DROP TABLE [Financial].[FactAccTicketSale];








/*===============================================================================
						 Financial Mart Dimentions
===============================================================================*/




/*********************    DimCardType Table    *********************/--


CREATE TABLE [Financial].DimCardType (
    CardTypeID_BK   INT NOT NULL UNIQUE,
    TypeCode        VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);


/*********************    DimCardStatus Table    *********************/--


CREATE TABLE [Financial].DimCardStatus (
    CardStatusID_BK INT NOT NULL UNIQUE,
    StatusCode      VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);


/*********************    DimSalesChannel Table (scd1)   *********************/--


CREATE TABLE [Financial].DimSalesChannel (
    SalesChannelID_BK INT NOT NULL UNIQUE,
    ChannelCode     VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);



/*===============================================================================
						 Financial Mart Facts
===============================================================================*/



/*********************    FactTrnsCardTopUp Table    *********************/--


CREATE TABLE [Financial].FactTrnsCardTopUp (            -- transactional
    DateKey        INT , --NOT NULL REFERENCES DimDate(DateKey),
	StationKey     INT , --NULL REFERENCES DimStation(StationKey),
    TimeKey        SMALLINT , --NOT NULL REFERENCES DimTime(TimeKey),
	SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
    CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),
    CardStatusKey  INT , --NOT NULL REFERENCES DimCardStatus(CardStatusKey),
    Amount         MONEY --NOT NULL
);


/*********************    FactDailyCardTopUp Table    *********************/--


CREATE TABLE [Financial].FactDailyCardTopUp ( 
    DateKey        INT , --NOT NULL REFERENCES DimDate(DateKey),
    CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),
    SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
    StationKey     INT , --NULL REFERENCES DimStation(StationKey),
    TotalTopUpAmt  MONEY , --NOT NULL,
    TotalTopUps    INT   --NOT NULL,
    --PRIMARY KEY (DateKey, TimeKey, CardTypeKey, SalesChannelKey, StationKey)
);


/*********************    FactAccCardTopUp Table    *********************/--


CREATE TABLE [Financial].FactAccCardTopUp (
	 StationKey     INT , --NULL REFERENCES DimStation(StationKey),
	 SalesChannelKey INT , --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
	 CardTypeKey    INT , --NOT NULL REFERENCES DimCardType(CardTypeKey),	
	 TotalTopUpAmt  MONEY , --NOT NULL,
	 MaxTopUpAmt  MONEY , --NOT NULL,
	 AvgTopUpAmt  MONEY , --NOT NULL,
	 TotalTopUps    INT   --NOT NULL
);

CREATE TABLE [Financial].TimeFactAccCardTopUp
(
	[Date] DATE
);

/*********************    FactTrnsTicketSale Table    *********************/

CREATE TABLE [Financial].FactTrnsTicketSale (       -- transactional
    DateKey        INT	, --NOT NULL REFERENCES DimDate(DateKey),
	StationKey     INT	, --NOT NULL REFERENCES DimStation(StationKey),
    TimeKey        SMALLINT		, --NOT NULL REFERENCES DimTime(TimeKey),
    SalesChannelKey INT			, --NOT NULL REFERENCES DimSalesChannel(SalesChannelKey),
    TicketRevenue  MONEY		 --NOT NULL,
    --TicketsSoldCnt INT   --NOT NULL
);


/*********************    FactDailyTicketSale Table    *********************/


CREATE TABLE [Financial].FactDailyTicketSale (
    DateKey          INT   ,-- NOT NULL REFERENCES DimDate(DateKey),
    StationKey       INT   ,-- NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT   ,-- NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT   ,-- NOT NULL,
    TotalRevenue     MONEY 
);


/*********************    FactAccTicketSale Table    *********************/
CREATE TABLE [Financial].FactAccTicketSale (
    StationKey       INT    , --NOT NULL REFERENCES DimStation(StationKey),
    SalesChannelKey  INT    , --NOT NULL REFERENCES DimSalesChannel(SalesChannelID),
    TotalTicketsSold INT    , --NOT NULL DEFAULT 0,
    TotalRevenue     MONEY  , --NOT NULL DEFAULT 0,
);


CREATE TABLE [Financial].TimeFactAccTicketSale
(
	[Date] DATE
);
