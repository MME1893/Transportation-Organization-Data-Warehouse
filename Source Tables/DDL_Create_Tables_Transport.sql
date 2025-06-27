/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/



/* 2. Transport ------------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Transport')
    EXEC (N'CREATE SCHEMA [Transport]');
GO



-- Step 1: Drop all foreign key constraints referencing these Transport tables
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] 
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('Transport.Station'),
    OBJECT_ID('Transport.Route'),
    OBJECT_ID('Transport.RouteStation'),
    OBJECT_ID('Transport.Vehicle'),
    OBJECT_ID('Transport.VehicleStatusHistory'),
    OBJECT_ID('Transport.Journey'),
    OBJECT_ID('Transport.JourneyStatusEvent'),
    OBJECT_ID('Transport.ArrivalEvent'),
    OBJECT_ID('Transport.PaymentDevice'),
    OBJECT_ID('Transport.DeviceAssignment'),
    OBJECT_ID('Transport.PaymentTxn')
);

EXEC sp_executesql @sql;

-- Step 2: Drop the Transport tables if they exist
IF OBJECT_ID(N'Transport.PaymentTxn', N'U') IS NOT NULL
    DROP TABLE Transport.PaymentTxn;

IF OBJECT_ID(N'Transport.DeviceAssignment', N'U') IS NOT NULL
    DROP TABLE Transport.DeviceAssignment;

IF OBJECT_ID(N'Transport.PaymentDevice', N'U') IS NOT NULL
    DROP TABLE Transport.PaymentDevice;

IF OBJECT_ID(N'Transport.ArrivalEvent', N'U') IS NOT NULL
    DROP TABLE Transport.ArrivalEvent;

IF OBJECT_ID(N'Transport.JourneyStatusEvent', N'U') IS NOT NULL
    DROP TABLE Transport.JourneyStatusEvent;

IF OBJECT_ID(N'Transport.Journey', N'U') IS NOT NULL
    DROP TABLE Transport.Journey;

IF OBJECT_ID(N'Transport.VehicleStatusHistory', N'U') IS NOT NULL
    DROP TABLE Transport.VehicleStatusHistory;

IF OBJECT_ID(N'Transport.Vehicle', N'U') IS NOT NULL
    DROP TABLE Transport.Vehicle;

IF OBJECT_ID(N'Transport.RouteStation', N'U') IS NOT NULL
    DROP TABLE Transport.RouteStation;

IF OBJECT_ID(N'Transport.Route', N'U') IS NOT NULL
    DROP TABLE Transport.Route;

IF OBJECT_ID(N'Transport.Station', N'U') IS NOT NULL
    DROP TABLE Transport.Station;



/*===============================================================================
  1) TRANSPORT DOMAIN (feeds Transport Mart)
  -----------------------------------------------------------------------------
  These tables capture static and historical data for stations, routes, vehicles,
  journeys, and arrival events. They also track payment devices and transactions.
===============================================================================*/

-- =============================================================================
-- Table: Station
-- Purpose: Stores metadata for each bus stop or transit station.
-- Columns:
--   StationID      : Surrogate PK, auto-increment.
--   StationName    : Descriptive name, e.g. 'Central Station'.
--   Latitude       : Geographic latitude (decimal degrees).
--   Longitude      : Geographic longitude (decimal degrees).
--   StreetAddress  : Physical street address (optional).
--   City           : City or municipality (optional).
--   ZoneCode       : Fare zone code (optional).
--   OpeningDate    : Date when station opened (optional).
--   IsAccessible   : Flag indicating ADA accessibility (1 = yes).
-- =============================================================================
CREATE TABLE [Transport].Station (
    StationID      INT IDENTITY PRIMARY KEY,
    StationName    NVARCHAR(100) NOT NULL,   
    Latitude       DECIMAL(9,6) NULL,          
    Longitude      DECIMAL(9,6) NULL,             
    StreetAddress  NVARCHAR(150) NULL,              
    City           NVARCHAR(50)  NULL,              
    ZoneCode       VARCHAR(10)   NULL,               
    OpeningDate    DATE          NULL,               
    IsAccessible   BIT           NOT NULL DEFAULT 1  
);


-- =============================================================================
-- Table: Route
-- Purpose: Defines each bus route with service characteristics.
-- Columns:
--   RouteID        : Surrogate PK, auto-increment.
--   RouteCode      : Internal route code, e.g. '12A' (unique).
--   RouteName      : Official route name, e.g. 'Downtown - Airport'.
--   PeakFrequency  : Buses per hour during peak demand (optional).
--   OffPeakFreq    : Buses per hour during off-peak times (optional).
--   RouteStatusID  : FK → LkpRouteStatus, indicates if active/inactive.
-- =============================================================================
CREATE TABLE [Transport].[Route] (
    RouteID        INT IDENTITY PRIMARY KEY,         
    RouteCode      VARCHAR(10) UNIQUE,               
    RouteName      NVARCHAR(100) NOT NULL,           
    PeakFrequency  TINYINT NULL,                     
    OffPeakFreq    TINYINT NULL,                     
    RouteStatusID  INT NOT NULL                      
        FOREIGN KEY REFERENCES [Lookup].LkpRouteStatus(RouteStatusID)
);


-- =============================================================================
-- Table: RouteStation
-- Purpose: Maps each route to its ordered list of stations.
-- Columns:
--   RouteID        : FK → Route(RouteID).
--   SeqNo          : Sequence number of station on route (1 = first stop).
--   StationID      : FK → Station(StationID).
-- Constraints:
--   PK (RouteID, SeqNo): Ensures unique order value for each route.
--   UNIQUE(RouteID, StationID) can be added if a station must not repeat.
-- =============================================================================
CREATE TABLE [Transport].RouteStation (
    RouteID   INT      NOT NULL
        FOREIGN KEY REFERENCES [Transport].Route(RouteID),     
    SeqNo     SMALLINT NOT NULL,                   
    StationID INT      NOT NULL
        FOREIGN KEY REFERENCES [Transport].Station(StationID), 
    CONSTRAINT PK_RouteStation PRIMARY KEY (RouteID, SeqNo)
);


-- =============================================================================
-- Table: Vehicle
-- Purpose: Records each bus in the fleet with static attributes.
-- Columns:
--   VehicleID      : Surrogate PK, auto-increment.
--   VehicleTypeID  : FK → LkpVehicleType, category of bus.
--   PlateNo        : License plate number (unique).
--   Capacity       : Total passenger capacity (seated + standing).
--   YearCreated    : Year the vehicle was manufactured or entered service.
--   Manufacturer   : Bus manufacturer (optional).
--   Model          : Vehicle model (optional).
--   PurchaseDate   : Date acquired (optional).
--   EngineNumber   : Serial number of engine (optional).
--   GPSUnitSerial  : Serial of installed GPS device (optional).
--   LastOdometerKM : Last recorded odometer reading in kilometers (optional).
-- =============================================================================
CREATE TABLE [Transport].Vehicle (
    VehicleID       INT IDENTITY PRIMARY KEY,       
    VehicleTypeID   INT NOT NULL                    
        FOREIGN KEY REFERENCES [Lookup].LkpVehicleType(VehicleTypeID),
    PlateNo         VARCHAR(15)   UNIQUE,           
    Capacity        SMALLINT      NOT NULL,         
    YearCreated     SMALLINT      NOT NULL,         
    Manufacturer    VARCHAR(50)   NULL,             
    Model           VARCHAR(50)   NULL,             
    PurchaseDate    DATE          NULL,             
    EngineNumber    VARCHAR(30)   NULL,             
    GPSUnitSerial   VARCHAR(40)   NULL,             
    LastOdometerKM  INT           NULL              
);


-- =============================================================================
-- Table: VehicleStatusHistory
-- Purpose: Maintains a full history of each vehicle’s operational status.
-- Columns:
--   StatusHistID   : Surrogate PK, auto-increment.
--   VehicleID      : FK → Vehicle(VehicleID), which bus.
--   VehicleStatusID: FK → LkpVehicleStatus, current state.
--   StatusStartDT  : Timestamp when this status began.
--   StatusEndDT    : Timestamp when this status ended (NULL = still current).
-- Constraints:
--   CK_VSH_Date    : Ensures StatusEndDT > StatusStartDT if not NULL.
-- =============================================================================
CREATE TABLE [Transport].VehicleStatusHistory (
    StatusHistID     BIGINT IDENTITY PRIMARY KEY,     
    VehicleID        INT      NOT NULL                
        FOREIGN KEY REFERENCES [Transport].Vehicle(VehicleID),
    VehicleStatusID  INT      NOT NULL                
        FOREIGN KEY REFERENCES [Lookup].LkpVehicleStatus(VehicleStatusID),
    StatusStartDT    DATETIME NOT NULL,               
    StatusEndDT      DATETIME NULL,                   
    CONSTRAINT CK_VSH_Date CHECK (StatusEndDT IS NULL OR StatusEndDT > StatusStartDT)
);
CREATE INDEX IX_VehicleStatus_Vehicle_Time
    ON [Transport].VehicleStatusHistory (VehicleID, StatusStartDT DESC);  -- Quick lookup of latest status


-- =============================================================================
-- Table: Journey
-- Purpose: Stores each complete trip of a vehicle along a route.
-- Columns:
--   JourneyID       : Surrogate PK, auto-increment.
--   VehicleID       : FK → Vehicle(VehicleID), bus used.
--   RouteID         : FK → Route(RouteID), route traveled.
--   DriverEmpID     : FK → Employee.EmpID (not yet defined), driver assigned.
--   PlannedStartDT  : Scheduled departure datetime.
--   ActualStartDT   : Actual departure datetime (NULL if not started).
--   PlannedEndDT    : Scheduled arrival datetime.
--   ActualEndDT     : Actual arrival datetime (NULL if not finished).
--   DistanceKM      : Total distance covered in km (filled at end).
--   PassengerCount  : Total boardings (calculated at end).
-- =============================================================================
CREATE TABLE [Transport].Journey (
    JourneyID       BIGINT IDENTITY PRIMARY KEY,      
    VehicleID       INT      NOT NULL                 
        FOREIGN KEY REFERENCES [Transport].Vehicle(VehicleID),
    RouteID         INT      NOT NULL                 
        FOREIGN KEY REFERENCES [Transport].[Route](RouteID),
    DriverEmpID     INT      NOT NULL,                
    PlannedStartDT  DATETIME NOT NULL,                
    ActualStartDT   DATETIME NULL,                    
    PlannedEndDT    DATETIME NOT NULL,                
    ActualEndDT     DATETIME NULL,                    
    DistanceKM      DECIMAL(7,2) NULL,                
    PassengerCount  INT NULL -- no need for this ... denormalized                            
);


-- =============================================================================
-- Table: JourneyStatusEvent
-- Purpose: Captures each status change (e.g. accident, resumed) during a journey.
-- Columns:
--   JourneyID       : FK → Journey(JourneyID), journey affected.
--   StatusDT        : Exact datetime of status change.
--   JourneyStatusID : FK → LkpJourneyStatus, new status code.
-- Constraints:
--   PK (JourneyID, StatusDT): Ensures unique timestamp per journey.
-- =============================================================================
CREATE TABLE [Transport].JourneyStatusEvent (
    JourneyID       BIGINT      NOT NULL               
        FOREIGN KEY REFERENCES [Transport].Journey(JourneyID),
    StatusDT        DATETIME    NOT NULL,              
    JourneyStatusID INT         NOT NULL               
        FOREIGN KEY REFERENCES [Lookup].LkpJourneyStatus(JourneyStatusID),
    CONSTRAINT PK_JourneyStatus PRIMARY KEY (JourneyID, StatusDT)
);


-- =============================================================================
-- Table: ArrivalEvent
-- Purpose: Logs when a journey’s vehicle arrives and departs each station.
-- Columns:
--   JourneyID        : FK → Journey(JourneyID), journey ID.
--   StationID        : FK → Station(StationID), station reached.
--   ActualArrivalDT  : Actual arrival datetime (not NULL).
--   ActualDepartureDT: Actual departure datetime (NULL if still here).
--   BoardedCnt       : # of passengers who boarded at this stop.
--   AlightedCnt      : # of passengers who got off at this stop.
--   CardBoarded      : # who paid by card.
--   TicketBoarded    : # who paid by ticket.
-- Constraints:
--   PK (JourneyID, StationID): Ensures one row per station per journey.
-- =============================================================================
CREATE TABLE [Transport].ArrivalEvent (
    JourneyID         BIGINT      NOT NULL        
        FOREIGN KEY REFERENCES [Transport].Journey(JourneyID),
    StationID         INT         NOT NULL        
        FOREIGN KEY REFERENCES [Transport].Station(StationID),
    ActualArrivalDT   DATETIME    NOT NULL,       
    ActualDepartureDT DATETIME    NULL,                    
    BoardedCnt        SMALLINT    NOT NULL DEFAULT 0,      
    AlightedCnt       SMALLINT    NOT NULL DEFAULT 0,      
    CardBoarded       SMALLINT    NOT NULL DEFAULT 0,      
    TicketBoarded     SMALLINT    NOT NULL DEFAULT 0,      
    CONSTRAINT PK_ArrivalEvent PRIMARY KEY (JourneyID, StationID)
);


-- =============================================================================
-- Table: PaymentDevice
-- Purpose: Catalog of fare-collection devices installed on buses or at stations.
-- Columns:
--   DeviceID         : Surrogate PK, auto-increment.
--   DeviceCode       : Unique business code/identifier (e.g. 'DV-001').
--   DeviceTypeID     : FK → LkpDeviceType, type of device.
--   DeviceStatusID   : FK → LkpDeviceStatus, current state.
--   InstallDate      : Date when device was first used (optional).
--   SerialNo         : Hardware serial number (unique).
--   FirmwareVersion  : Installed firmware version (optional).
--   LastServiceDT    : Last maintenance date (optional).
--   IPAddress        : Network address if device is networked (optional).
-- =============================================================================
CREATE TABLE [Transport].PaymentDevice (
    DeviceID         INT IDENTITY PRIMARY KEY,           
    DeviceCode       VARCHAR(20) NOT NULL UNIQUE,        
    DeviceTypeID     INT NOT NULL                        
        FOREIGN KEY REFERENCES [Lookup].LkpDeviceType(DeviceTypeID),
    DeviceStatusID   INT NOT NULL                        
        FOREIGN KEY REFERENCES [Lookup].LkpDeviceStatus(DeviceStatusID),
    InstallDate      DATE      NULL,                     
    SerialNo         VARCHAR(40) NOT NULL,               
    FirmwareVersion  VARCHAR(30) NULL,                   
    LastServiceDT    DATE      NULL,                     
    IPAddress        VARCHAR(45) NULL                    
);


-- =============================================================================
-- Table: DeviceAssignment
-- Purpose: Tracks which device is assigned to which bus or station over time.
-- Columns:
--   AssignmentID     : Surrogate PK, auto-increment.
--   DeviceID         : FK → PaymentDevice(DeviceID), device being assigned.
--   AssignedToType   : 'Vehicle' or 'Station' (indicates assignment target).
--   VehicleID        : FK → Vehicle(VehicleID), when AssignedToType='Vehicle'.
--   StationID        : FK → Station(StationID), when AssignedToType='Station'.
--   AssignmentStart  : Date/time when assignment began.
--   AssignmentEnd    : Date/time when assignment ended (NULL if current).
-- Constraints:
--   CK_DeviceAssignment_Type: Ensures either VehicleID or StationID is non-NULL (matching AssignedToType).
--   Trigger trg_DeviceAssignment_NoOverlap: Prevents overlapping assignments for same device.
-- =============================================================================
CREATE TABLE [Transport].DeviceAssignment (
    AssignmentID     BIGINT      IDENTITY PRIMARY KEY,    
    DeviceID         INT         NOT NULL                 
        FOREIGN KEY REFERENCES [Transport].PaymentDevice(DeviceID),
    AssignedToType   VARCHAR(12) NOT NULL,                
    VehicleID        INT         NULL                     
        FOREIGN KEY REFERENCES [Transport].Vehicle(VehicleID),
    StationID        INT         NULL                     
        FOREIGN KEY REFERENCES [Transport].Station(StationID),
    AssignmentStart  DATETIME    NOT NULL,                
    AssignmentEnd    DATETIME    NULL,                    
    CONSTRAINT CK_DeviceAssignment_Type
        CHECK (
            (AssignedToType = 'Vehicle' AND VehicleID IS NOT NULL AND StationID IS NULL) 
         OR (AssignedToType = 'Station' AND StationID IS NOT NULL AND VehicleID IS NULL)
        )
);


-- =============================================================================
-- Table: PaymentTxn
-- Purpose: Records each payment transaction (card or ticket) at a device.
-- Columns:
--   TxnID           : Surrogate PK, auto-increment.
--   PaymentMethodID : FK → LkpPaymentMethod, 'Card' or 'Ticket'.
--   CardID          : FK → Card(CardID) when payment by card (NULL if ticket).
--   TicketID        : FK → Ticket(TicketID) when payment by ticket (NULL if card).
--   RouteID         : FK → Route(RouteID), route on which payment occurred.
--   DeviceID        : FK → PaymentDevice(DeviceID), device used for the transaction.
--   TxnDT           : Timestamp of transaction.
--   FareAmount      : Amount charged (monetary).
-- Index:
--   IX_Payment_Station_Time: Intended to index StationID (if present) and TxnDT for time-based queries.
-- =============================================================================
CREATE TABLE [Transport].PaymentTxn (
    TxnID            BIGINT IDENTITY PRIMARY KEY,        -- Surrogate key
    PaymentMethodID  INT NOT NULL                          -- FK to payment method
        FOREIGN KEY REFERENCES [Lookup].LkpPaymentMethod(PaymentMethodID),
    CardID           BIGINT NULL,                          -- FK to Card (if card payment)
    TicketID         BIGINT NULL,                          -- FK to Ticket (if ticket payment)
    StationID      INT   NOT NULL FOREIGN KEY REFERENCES [Transport].Station(StationID), 
    RouteID          INT NOT NULL FOREIGN KEY REFERENCES [Transport].[Route](RouteID),   -- Route, for analytics
    DeviceID         INT NOT NULL FOREIGN KEY REFERENCES [Transport].PaymentDevice(DeviceID), -- Which device
    TxnDT            DATETIME NOT NULL,                    -- When transaction occurred
    FareAmount       MONEY NOT NULL                        -- Amount charged
);
-- Intended index on StationID & TxnDT; uncomment if StationID is added back:
 CREATE INDEX IX_Payment_Station_Time ON [Transport].PaymentTxn (StationID, TxnDT);
