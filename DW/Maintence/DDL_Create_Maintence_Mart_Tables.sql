Use TransitDW

GO


IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Maintence')
    EXEC (N'CREATE SCHEMA [Maintence]');
GO



IF OBJECT_ID('[Maintence].DimMaintenanceType', 'U') IS NOT NULL DROP TABLE [Maintence].DimMaintenanceType;
IF OBJECT_ID('[Maintence].DimPartCategory', 'U')	IS NOT NULL DROP TABLE [Maintence].DimPartCategory;
IF OBJECT_ID('[Maintence].DimSupplier', 'U')		IS NOT NULL DROP TABLE [Maintence].DimSupplier;
IF OBJECT_ID('[Maintence].DimPart', 'U')					IS NOT NULL DROP TABLE [Maintence].DimPart;
IF OBJECT_ID('[Maintence].DimFuelType', 'U')				IS NOT NULL DROP TABLE [Maintence].DimFuelType;

IF OBJECT_ID('[Maintence].FactMaintenanceDetail', 'U')		IS NOT NULL DROP TABLE [Maintence].FactMaintenanceDetail;
IF OBJECT_ID('[Maintence].FactMonthlyMaintenanceWO', 'U')	IS NOT NULL DROP TABLE [Maintence].FactMonthlyMaintenanceWO;
IF OBJECT_ID('[Maintence].FactAccMaintenanceWO', 'U')		IS NOT NULL DROP TABLE [Maintence].FactAccMaintenanceWO;
IF OBJECT_ID('[Maintence].FactTrnsFueling', 'U')			IS NOT NULL DROP TABLE [Maintence].FactTrnsFueling;
IF OBJECT_ID('[Maintence].FactMonthlyFueling', 'U')			IS NOT NULL DROP TABLE [Maintence].FactMonthlyFueling;
IF OBJECT_ID('[Maintence].FactAccFueling', 'U')		IS NOT NULL DROP TABLE [Maintence].FactAccFueling;


/*===============================================================================
						 Maintence Mart Dimentions
===============================================================================*/


/*********************    DimMaintenanceType Table    *********************/
CREATE TABLE [Maintence].DimMaintenanceType (
    MaintenanceTypeID_BK INT , -- NOT NULL UNIQUE,
    TypeCode        VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);


/*********************    DimPartCategory Table    *********************/
CREATE TABLE [Maintence].DimPartCategory (
    PartCategoryID_BK INT , -- NOT NULL UNIQUE,
    CategoryCode    VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);


/*********************    DimSalesChannel Table    *********************/
CREATE TABLE [Maintence].DimSupplier (
    SupplierID_BK    INT    , --NOT NULL UNIQUE,        -- business key from source.S upplierID
    SupplierName     NVARCHAR(100) , --NOT NULL,
    ContactPhone     VARCHAR(20)  , --NULL,
    ContactEmail     VARCHAR(100) , --NULL,
    AddressLine1     NVARCHAR(150) , --NULL,
    AddressLine2     NVARCHAR(150) , --NULL,
    City             NVARCHAR(50)  , --NULL,
    PostalCode       VARCHAR(20)   , --NULL,
    Country          NVARCHAR(50)  , --NULL,
    Website          VARCHAR(100)  , --NULL,
    TaxID            VARCHAR(20)   , --NULL,
    ContactPerson    NVARCHAR(100) , --NULL,
    -- SCD fields
    SCD_StartDate    DATETIME      , --NOT NULL DEFAULT GETDATE(),
    SCD_EndDate      DATETIME      , --NULL,
    IsCurrent        BIT            --NOT NULL DEFAULT 1
);


/*********************    DimPart Table   *********************/
CREATE TABLE [Maintence].DimPart (
    PartID_BK       INT , --NOT NULL UNIQUE,
    PartName        VARCHAR(100),
    PartCategoryKey INT , --NOT NULL REFERENCES DimPartCategory(PartCategoryKey),
    UnitCostLatest  MONEY
);


/*********************    DimFuelType Table   *********************/
CREATE TABLE [Maintence].DimFuelType (
    FuelTypeID_BK   INT , --NOT NULL UNIQUE,
    FuelCode        VARCHAR(50),
    Label_EN        VARCHAR(100),
    Label_FA        NVARCHAR(100)
);



/*===============================================================================
						 Maintence Mart Facts
===============================================================================*/


/*********************    FactTrnsMaintenanceDetail Table    *********************/
-- “No part” dummy row for part-less WOs
IF NOT EXISTS (SELECT 1 FROM [Maintence].DimPart WHERE PartID_BK = -1)
INSERT INTO [Maintence].DimPart (PartID_BK, PartName, PartCategoryKey, UnitCostLatest)
VALUES (-1,'(No Part)',1,0);   -- assumes category 1 = 'Misc'


CREATE TABLE [Maintence].FactMaintenanceDetail (
	-- Grain: One part (or “no part”) per maintenance work order

	WorkOrderID_BK    BIGINT    , -- NOT NULL,    -- Business/natural key for work order (from source)
	PartKey           INT       , -- NOT NULL,    -- Foreign key to DimPart
	SupplierKry    INT       default -1 , -- NOT NULL , -- Foreign key to DimSupplie
	-- Additional dimension keys for star joins
	OpenDateKey       INT       , -- NOT NULL REFERENCES DimDate(DateKey),
	CloseDateKey      INT    default -1, -- NOT NULL REFERENCES DimDate(DateKey),
	OpentimeKey		INT,
	ClosetimeKey	INT default -1,
	VehicleKey        INT       , -- NOT NULL REFERENCES DimVehicle(VehicleKey),
	MaintTypeKey      INT       , -- NOT NULL REFERENCES DimMaintenanceType(MaintTypeKey),
	MechanicKey       INT       , -- NOT NULL REFERENCES DimEmployee(EmployeeKey),

	-- Fact measures
	DowntimeHours     DECIMAL(8,2) , -- NULL,     -- Total downtime for this work order
	LaborHours        DECIMAL(8,2) , -- NULL,     -- Total labor hours for this work order
	TotalWOCost       MONEY        , -- NULL,     -- Total cost for this work order (header-level)
	Quantity          SMALLINT     DEFAULT 0, -- NOT NULL DEFAULT 0,  -- Quantity of part (0 if “no part”)
	PartCost          MONEY          -- NULL,                -- Cost for this part (NULL/0 if “no part”)

	-- Composite primary key
	--PRIMARY KEY (WorkOrderID_BK, PartKey)
);


/*********************    FactMonthlyMaintenanceWO Table    *********************/
CREATE TABLE [Maintence].FactMonthlyMaintenanceWO (
    DateKey         INT           , -- NOT NULL REFERENCES DimDate(DateKey),   -- e.g. 20250501
    VehicleKey      INT			  , -- NOT NULL REFERENCES DimVehicle(VehicleKey),

    /* Measures aggregated DISTINCT by WorkOrderID_BK */
    WorkOrdersCnt   INT           , -- NOT NULL,           -- DISTINCT WOs in month
  --  DowntimeHours   DECIMAL(10,2) , -- NOT NULL DEFAULT 0,
    LaborHours      DECIMAL(10,2) , -- NOT NULL DEFAULT 0,
    PartsQty        INT           , -- NOT NULL DEFAULT 0,   -- total Quantity from parts
    PartsCost       MONEY         , -- NOT NULL DEFAULT 0,
    TotalCost       MONEY         -- NOT NULL DEFAULT 0,   -- Labor + Parts
);


/*********************    FactAccMaintenanceWO Table    *********************/
CREATE TABLE [Maintence].FactAccMaintenanceWO (

    VehicleKey      INT           , -- NOT NULL REFERENCES DimVehicle(VehicleKey),

    WorkOrdersCnt   INT			  , -- NOT NULL,
   -- DowntimeHours   DECIMAL(12,2) , -- NOT NULL DEFAULT 0,
    LaborHours      DECIMAL(12,2) , -- NOT NULL DEFAULT 0,
    AvgLaborHours   DECIMAL(10,2) , -- NOT NULL DEFAULT 0,
    PartsQty        INT           , -- NOT NULL DEFAULT 0,
    MinCost         MONEY         , -- NOT NULL DEFAULT 0,
    MaxCost         MONEY         , -- NOT NULL DEFAULT 0,
    TotalCost       MONEY           -- NOT NULL DEFAULT 0,
);


/*********************    FactTrnsFueling Table    *********************/
CREATE TABLE [Maintence].FactTrnsFueling (
    DateKey      INT , -- NOT NULL REFERENCES DimDate(DateKey),
    TimeKey      SMALLINT , -- NOT NULL REFERENCES DimTime(TimeKey),
    VehicleKey   INT , -- NOT NULL REFERENCES DimVehicle(VehicleKey),
    FuelTypeKey  INT , -- NOT NULL REFERENCES DimFuelType(FuelTypeKey),
    Liters       DECIMAL(8,2) , -- NOT NULL,
    FuelCost     MONEY  -- NOT NULL
);


/*********************    FactMonthlyFueling Table    *********************/
CREATE TABLE [Maintence].FactMonthlyFueling (
    DateKey INT , -- NOT NULL REFERENCES DimDate(DateKey),  -- e.g., first day of month
    VehicleKey      INT , -- NOT NULL REFERENCES DimVehicle(VehicleKey),
    FuelTypeKey     INT , -- NOT NULL REFERENCES DimFuelType(FuelTypeKey),

    TotalLiters    DECIMAL(12,2) , -- NOT NULL DEFAULT 0,
    TotalFuelCost  MONEY , -- NOT NULL DEFAULT 0,

    -- CONSTRAINT PK_FactMonthlyFueling PRIMARY KEY (SnapshotDateKey, VehicleKey, FuelTypeKey)
);


/*********************    FactAccFueling Table    *********************/
CREATE TABLE [Maintence].FactAccFueling (

    VehicleKey        INT            , -- NOT NULL  REFERENCES DimVehicle(VehicleKey),

    -- FuelTypeKey       INT            , -- NOT NULL  REFERENCES DimFuelType(FuelTypeKey),

    -- Aggregated measures (all-time or YTD, as defined in your ETL)
    FuelEventsCount   INT            , -- NOT NULL DEFAULT 0,        -- # fueling events
    TotalLiters       DECIMAL(14,2)  , -- NOT NULL DEFAULT 0,        -- sum of Liters
    TotalFuelCost     MONEY          , -- NOT NULL DEFAULT 0,        -- sum of FuelCost
    AvgCostPerLiter   DECIMAL(12,4)  , -- NOT NULL DEFAULT 0,        -- TotalFuelCost/TotalLiters
    MinCostPerLiter   DECIMAL(12,4)  , -- NOT NULL DEFAULT 0,        -- minimum FuelCost/Liters
    MaxCostPerLiter   DECIMAL(12,4)    -- NOT NULL DEFAULT 0         -- maximum FuelCost/Liters

    --CONSTRAINT PK_FactAccFueling 
    --    PRIMARY KEY (SnapshotDateKey, VehicleKey, FuelTypeKey)
);
