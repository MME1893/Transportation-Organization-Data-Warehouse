/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/
CREATE SCHEMA [Lookup];
GO

CREATE SCHEMA Transport;
GO

CREATE SCHEMA Financial;
GO

CREATE SCHEMA Maintenance;
GO

CREATE SCHEMA HR;
GO






/*===============================================================================
  0) LOOKUP / MASTER TABLES
  -----------------------------------------------------------------------------
  These tables hold enumeration or reference values with bilingual labels.
  Each lookup has:
    - A surrogate primary key (IDENTITY INT).
    - A business code (TypeCode / StatusCode / etc.) that is UNIQUE.
    - English and Persian display labels.
===============================================================================*/

-- =============================================================================
-- Table: LkpVehicleType
-- Purpose: Defines bus categories (e.g. standard, articulated).
-- Columns:
--   VehicleTypeID  : Surrogate PK, auto-increment.
--   TypeCode       : Internal code, e.g. 'BUS_STD' (unique).
--   Label_EN       : English description, e.g. 'Standard Bus'.
--   Label_FA       : Persian description, e.g. 'اتوبوس عادی'.
-- =============================================================================
CREATE TABLE [Lookup].LkpVehicleType (
    VehicleTypeID   INT IDENTITY PRIMARY KEY,     
    TypeCode        VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpVehicleStatus
-- Purpose: Enumerates operational states of a vehicle (e.g. Active, Repair).
-- Columns:
--   VehicleStatusID: Surrogate PK, auto-increment.
--   StatusCode     : Internal code, e.g. 'Active' (unique).
--   Label_EN       : English description, e.g. 'Active'.
--   Label_FA       : Persian description, e.g. 'فعال'.
-- =============================================================================
CREATE TABLE [Lookup].LkpVehicleStatus (
    VehicleStatusID INT IDENTITY PRIMARY KEY,       
    StatusCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpRouteStatus
-- Purpose: Tracks whether a bus route is active or inactive.
-- Columns:
--   RouteStatusID  : Surrogate PK, auto-increment.
--   StatusCode     : Internal code, e.g. 'Active' (unique).
--   Label_EN       : English description, e.g. 'Active'.
--   Label_FA       : Persian description, e.g. 'فعال'.
-- =============================================================================
CREATE TABLE [Lookup].LkpRouteStatus (
    RouteStatusID   INT IDENTITY PRIMARY KEY,       
    StatusCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpJourneyStatus
-- Purpose: Defines lifecycle stages for a journey (e.g. Scheduled, InService).
-- Columns:
--   JourneyStatusID: Surrogate PK, auto-increment.
--   StatusCode     : Internal code, e.g. 'Scheduled' (unique).
--   Label_EN       : English description, e.g. 'Scheduled'.
--   Label_FA       : Persian description, e.g. 'زمان‌بندی‌شده'.
-- =============================================================================
CREATE TABLE [Lookup].LkpJourneyStatus (
    JourneyStatusID INT IDENTITY PRIMARY KEY,       
    StatusCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpDeviceType
-- Purpose: Enumerates payment device types (e.g. BusValidator, StationGate).
-- Columns:
--   DeviceTypeID   : Surrogate PK, auto-increment.
--   TypeCode       : Internal code, e.g. 'BusValidator' (unique).
--   Label_EN       : English description, e.g. 'Bus Validator'.
--   Label_FA       : Persian description, e.g. 'اعتبارسنج اتوبوس'.
-- =============================================================================
CREATE TABLE [Lookup].LkpDeviceType (
    DeviceTypeID    INT IDENTITY PRIMARY KEY,       
    TypeCode        VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpDeviceStatus
-- Purpose: Tracks operational state of a payment device (e.g. Active, Inactive).
-- Columns:
--   DeviceStatusID : Surrogate PK, auto-increment.
--   StatusCode     : Internal code, e.g. 'Active' (unique).
--   Label_EN       : English description, e.g. 'Active'.
--   Label_FA       : Persian description, e.g. 'فعال'.
-- =============================================================================
CREATE TABLE [Lookup].LkpDeviceStatus (
    DeviceStatusID  INT IDENTITY PRIMARY KEY,       
    StatusCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpCardType
-- Purpose: Defines passenger card types (Anonymous, Student, Senior).
-- Columns:
--   CardTypeID     : Surrogate PK, auto-increment.
--   TypeCode       : Internal code, e.g. 'Anonymous' (unique).
--   Label_EN       : English description, e.g. 'Anonymous'.
--   Label_FA       : Persian description, e.g. 'بی‌نام'.
-- =============================================================================
CREATE TABLE [Lookup].LkpCardType (
    CardTypeID      INT IDENTITY PRIMARY KEY,       
    TypeCode        VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpCardStatus
-- Purpose: Tracks card validity (Active vs. Blocked).
-- Columns:
--   CardStatusID   : Surrogate PK, auto-increment.
--   StatusCode     : Internal code, e.g. 'Active' (unique).
--   Label_EN       : English description, e.g. 'Active'.
--   Label_FA       : Persian description, e.g. 'فعال'.
-- =============================================================================
CREATE TABLE [Lookup].LkpCardStatus (
    CardStatusID    INT IDENTITY PRIMARY KEY,       
    StatusCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpPaymentMethod
-- Purpose: Indicates payment method used (Card vs. Ticket).
-- Columns:
--   PaymentMethodID: Surrogate PK, auto-increment.
--   MethodCode     : Internal code, e.g. 'Card' (unique).
--   Label_EN       : English description, e.g. 'Card'.
--   Label_FA       : Persian description, e.g. 'کارت'.
-- =============================================================================
CREATE TABLE [Lookup].LkpPaymentMethod (
    PaymentMethodID INT IDENTITY PRIMARY KEY,       
    MethodCode      VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpSalesChannel
-- Purpose: Specifies where a sale or top-up happened (Booth, MobileApp, Kiosk).
-- Columns:
--   SalesChannelID : Surrogate PK, auto-increment.
--   ChannelCode    : Internal code, e.g. 'Booth' (unique).
--   Label_EN       : English description, e.g. 'Booth'.
--   Label_FA       : Persian description, e.g. 'باجه'.
-- =============================================================================
CREATE TABLE [Lookup].LkpSalesChannel (
    SalesChannelID  INT IDENTITY PRIMARY KEY,       
    ChannelCode     VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN        VARCHAR(50)  NOT NULL,          
    Label_FA        NVARCHAR(50) NOT NULL           
);


-- =============================================================================
-- Table: LkpMaintenanceType
-- Purpose: Categorizes maintenance work orders (Preventive, Corrective, Overhaul).
-- Columns:
--   MaintenanceTypeID: Surrogate PK, auto-increment.
--   TypeCode         : Internal code, e.g. 'Preventive' (unique).
--   Label_EN         : English description, e.g. 'Preventive'.
--   Label_FA         : Persian description, e.g. 'پیشگیرانه'.
-- =============================================================================
CREATE TABLE [Lookup].LkpMaintenanceType (
    MaintenanceTypeID INT IDENTITY PRIMARY KEY,     
    TypeCode          VARCHAR(20)  NOT NULL UNIQUE, 
    Label_EN          VARCHAR(50)  NOT NULL,        
    Label_FA          NVARCHAR(50) NOT NULL         
);


-- =============================================================================
-- Table: LkpPartCategory
-- Purpose: Defines hierarchical spare-part families (Engine, Brake, HVAC, etc.).
-- Columns:
--   PartCategoryID  : Surrogate PK, auto-increment.
--   ParentCategoryID: FK to itself for hierarchy (may be NULL).
--   CategoryCode    : Internal code, e.g. 'Engine' (unique).
--   Label_EN        : English description, e.g. 'Engine'.
--   Label_FA        : Persian description, e.g. 'موتور'.
-- Constraints:
--   CK_ParentNotSelf: Ensures ParentCategoryID != PartCategoryID.
-- =============================================================================
CREATE TABLE [Lookup].LkpPartCategory (
    PartCategoryID   INT IDENTITY PRIMARY KEY,      
    ParentCategoryID INT NULL                        
        FOREIGN KEY REFERENCES [Lookup].LkpPartCategory(PartCategoryID),
    CategoryCode     VARCHAR(20)  NOT NULL UNIQUE,   
    Label_EN         VARCHAR(50)  NOT NULL,          
    Label_FA         NVARCHAR(50) NOT NULL,          
    CONSTRAINT CK_ParentNotSelf CHECK 
        (ParentCategoryID IS NULL OR ParentCategoryID <> PartCategoryID)
);


-- =============================================================================
-- Table: LkpRole
-- Purpose: Lists job titles (Driver, Mechanic, Clerk, Supervisor, etc.).
-- Columns:
--   RoleID          : Surrogate PK, auto-increment.
--   RoleCode        : Internal code, e.g. 'Driver' (unique).
--   Label_EN        : English description, e.g. 'Driver'.
--   Label_FA        : Persian description, e.g. 'راننده'.
-- =============================================================================
CREATE TABLE [Lookup].LkpRole (
    RoleID     INT IDENTITY PRIMARY KEY,            
    RoleCode   VARCHAR(20)  NOT NULL UNIQUE,        
    Label_EN   VARCHAR(50)  NOT NULL,               
    Label_FA   NVARCHAR(50) NOT NULL                
);


-- =============================================================================
-- Table: LkpDepartment
-- Purpose: Enumerates departments (Operations, Maintenance, HR, Planning, etc.).
-- Columns:
--   DepartmentID    : Surrogate PK, auto-increment.
--   DeptCode        : Internal code, e.g. 'OPS' (unique).
--   Label_EN        : English description, e.g. 'Operations'.
--   Label_FA        : Persian description, e.g. 'عملیات'.
-- =============================================================================
CREATE TABLE [Lookup].LkpDepartment (
    DepartmentID INT IDENTITY PRIMARY KEY,           
    DeptCode     VARCHAR(20)  NOT NULL UNIQUE,       
    Label_EN     VARCHAR(50)  NOT NULL,              
    Label_FA     NVARCHAR(50) NOT NULL               
);


-- =============================================================================
-- Table: LkpShiftType
-- Purpose: Defines shift patterns (Morning, Evening, Night, Split).
-- Columns:
--   ShiftTypeID     : Surrogate PK, auto-increment.
--   ShiftCode       : Internal code, e.g. 'Morning' (unique).
--   Label_EN        : English description, e.g. 'Morning'.
--   Label_FA        : Persian description, e.g. 'صبح'.
-- =============================================================================
CREATE TABLE [Lookup].LkpShiftType (
    ShiftTypeID INT IDENTITY PRIMARY KEY,            
    ShiftCode   VARCHAR(20)  NOT NULL UNIQUE,        
    Label_EN    VARCHAR(50)  NOT NULL,               
    Label_FA    NVARCHAR(50) NOT NULL                
);


-- =============================================================================
-- Table: LkpFuelType
-- Purpose: Lists types of fuel (Diesel, CNG, Oil) used in fueling events.
-- Columns:
--   FuelTypeID      : Surrogate PK, auto-increment.
--   FuelCode        : Internal code, e.g. 'Diesel' (unique).
--   Label_EN        : English description, e.g. 'Diesel'.
--   Label_FA        : Persian description, e.g. 'گازوئیل'.
-- =============================================================================
CREATE TABLE [Lookup].LkpFuelType (
    FuelTypeID INT IDENTITY PRIMARY KEY,            
    FuelCode   VARCHAR(20)  NOT NULL UNIQUE,        
    Label_EN   VARCHAR(50)  NOT NULL,               
    Label_FA   NVARCHAR(50) NOT NULL                
);




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




/*===============================================================================
  2) FINANCIAL DOMAIN (feeds Financial Mart)
  -----------------------------------------------------------------------------
  These tables support card issuance, top-ups, ticket sales, and balances.
===============================================================================*/


-- =============================================================================
-- Table: Card
-- Purpose: Master data for fare-payment cards issued to passengers.
-- Columns:
--   CardID          : Surrogate PK, auto-increment.
--   CardTypeID      : FK → LkpCardType, e.g. Anonymous, Student.
--   CardStatusID    : FK → LkpCardStatus, e.g. Active, Blocked.
--   IssueDate       : Date when card was issued.
--   ExpiryDate      : Expiration date (NULL if unlimited).
--   CurrentBalance  : Current monetary balance on card.
--   LastTopUpDT     : Timestamp of most recent top-up.
--   IsActive        : Flag indicating if card is active (1) or retired (0).
-- =============================================================================
CREATE TABLE [Financial].Card (
    CardID          BIGINT IDENTITY PRIMARY KEY,       
    CardTypeID      INT NOT NULL                       
        FOREIGN KEY REFERENCES [Lookup].LkpCardType(CardTypeID),
    CardStatusID    INT NOT NULL                         
        FOREIGN KEY REFERENCES [Lookup].LkpCardStatus(CardStatusID),
    IssueDate       DATE      NOT NULL,                   
    ExpiryDate      DATE      NULL,                       
    CurrentBalance  MONEY     NULL,                       
    LastTopUpDT     DATETIME  NULL,                       
    IsActive        BIT       NOT NULL DEFAULT 1          
);


-- =============================================================================
-- Table: CardTopUpTxn
-- Purpose: Records each top-up (recharge) of a fare card.
-- Columns:
--   TopUpID         : Surrogate PK, auto-increment.
--   CardID          : FK → Card(CardID).
--   TopUpDT         : Timestamp when top-up occurred.
--   Amount          : Monetary amount added.
--   SalesChannelID  : FK → LkpSalesChannel, where top-up was made.
-- Index:
--   IX_TopUp_Card_Time: Index to quickly find recent top-ups for a card.
-- =============================================================================
CREATE TABLE [Financial].CardTopUpTxn (
    TopUpID         BIGINT IDENTITY PRIMARY KEY,        
    CardID          BIGINT NOT NULL                        
        FOREIGN KEY REFERENCES [Financial].Card(CardID),
	StationID       INT NOT NULL                       
	FOREIGN KEY REFERENCES [Transport].Station(StationID),

    TopUpDT         DATETIME NOT NULL,                     
    Amount          MONEY NOT NULL,                        
    SalesChannelID  INT NOT NULL                           
        FOREIGN KEY REFERENCES [Lookup].LkpSalesChannel(SalesChannelID)
);
CREATE INDEX IX_TopUp_Card_Time ON [Financial].CardTopUpTxn (CardID, TopUpDT DESC);


-- =============================================================================
-- Table: Ticket
-- Purpose: Master data for electronic tickets issued to passengers.
-- Columns:
--   TicketID        : Surrogate PK, auto-increment.
--   IssueDate       : Date when ticket was created.
--   ExpiryDate      : Expiration date (NULL if perpetual).
--   IsActive        : Flag indicating if ticket is still valid (1) or used (0).
-- =============================================================================
CREATE TABLE [Financial].Ticket (
    TicketID        BIGINT IDENTITY PRIMARY KEY,       
    IssueDate       DATE      NOT NULL,                 
    ExpiryDate      DATE      NULL,                     
    IsActive        BIT       NOT NULL DEFAULT 1        
);


-- =============================================================================
-- Table: TicketSaleTxn
-- Purpose: Logs every time a ticket is sold (paper or e-ticket).
-- Columns:
--   SaleID          : Surrogate PK, auto-increment.
--   TicketID        : FK → Ticket(TicketID).
--   SaleDT          : Timestamp when sale occurred.
--   Amount          : Revenue from the ticket sale.
--   StationID       : FK → Station(StationID), where sold.
--   SalesChannelID  : FK → LkpSalesChannel, sales channel used.
-- Index:
--   IX_TicketSale_Time: Index to quickly query sales by datetime.
-- =============================================================================
CREATE TABLE TicketSaleTxn (
    SaleID          BIGINT IDENTITY PRIMARY KEY,       
    TicketID        BIGINT NOT NULL                    
        FOREIGN KEY REFERENCES [Financial].Ticket(TicketID),
    SaleDT          DATETIME NOT NULL,                 
    Amount          MONEY NOT NULL,                    
    StationID       INT NOT NULL                       
        FOREIGN KEY REFERENCES [Transport].Station(StationID),
    SalesChannelID  INT NOT NULL                       
        FOREIGN KEY REFERENCES [Lookup].LkpSalesChannel(SalesChannelID)
);
CREATE INDEX IX_TicketSale_Time ON TicketSaleTxn (SaleDT);




/*===============================================================================
  3) MAINTENANCE DOMAIN (feeds Maintenance Mart)
  -----------------------------------------------------------------------------
  These tables capture parts, suppliers, work orders, part replacements, and fuel events.
===============================================================================*/

-- =============================================================================
-- Table: Part
-- Purpose: Master data for spare parts used in maintenance.
-- Columns:
--   PartID          : Surrogate PK, auto-increment.
--   PartCategoryID  : FK → LkpPartCategory, part family.
--   PartName        : Descriptive name of the part.
--   UnitCostLatest  : Most recent purchase cost (optional).
-- =============================================================================
CREATE TABLE [Maintenance].Part (
    PartID           INT IDENTITY PRIMARY KEY,        
    PartCategoryID   INT NOT NULL                         
        FOREIGN KEY REFERENCES [Lookup].LkpPartCategory(PartCategoryID),
    PartName         VARCHAR(100) NOT NULL,               
    UnitCostLatest   MONEY       NULL                     
);


-- =============================================================================
-- Table: Supplier
-- Purpose: Records details about vendors supplying parts or services.
-- Columns:
--   SupplierID      : Surrogate PK, auto-increment.
--   SupplierName    : Company name.
--   ContactPhone    : Main phone number.
--   ContactEmail    : Contact email address (optional).
--   AddressLine1    : First line of vendor address (optional).
--   AddressLine2    : Second line of vendor address (optional).
--   City            : City where vendor is located (optional).
--   PostalCode      : Postal or ZIP code (optional).
--   Country         : Country name (optional).
--   Website         : Vendor website URL (optional).
--   TaxID           : Official tax identification (optional).
--   ContactPerson   : Name of primary contact (optional).
--   CreatedDate     : When this vendor record was created.
-- =============================================================================
CREATE TABLE [Maintenance].Supplier (
    SupplierID       INT          IDENTITY PRIMARY KEY,     
    SupplierName     NVARCHAR(100) NOT NULL,                
    ContactPhone     VARCHAR(20)   NULL,                    
    ContactEmail     VARCHAR(100)  NULL,                    
    AddressLine1     NVARCHAR(150) NULL,                    
    AddressLine2     NVARCHAR(150) NULL,                    
    City             NVARCHAR(50)  NULL,                    
    PostalCode       VARCHAR(20)   NULL,                    
    Country          NVARCHAR(50)  NULL,                    
    Website          VARCHAR(100)  NULL,                    
    TaxID            VARCHAR(20)   NULL,                    
    ContactPerson    NVARCHAR(100) NULL,                    
    CreatedDate      DATETIME      NOT NULL DEFAULT GETDATE() 
);


-- =============================================================================
-- Table: MaintenanceWorkOrder
-- Purpose: Represents each maintenance or repair order for a vehicle.
-- Columns:
--   WorkOrderID      : Surrogate PK, auto-increment.
--   VehicleID        : FK → Vehicle(VehicleID), bus under maintenance.
--   MaintenanceTypeID: FK → LkpMaintenanceType, category of work.
--   MechanicEmpID    : FK → Employee(EmpID), mechanic assigned.
--   OpenDT           : Date/time when work order was opened.
--   CloseDT          : Date/time when work order was closed (NULL if open).
--   OdometerAtService: Odometer reading at service start (optional).
--   RootCause        : Brief description of failure cause (optional).
--   LaborHours       : Total labor hours spent.
--   TotalCost        : Sum of parts cost + labor cost (optional).
--   WarrantyClaim    : Flag (1 = under warranty, 0 = not).
-- =============================================================================
CREATE TABLE [Maintenance].MaintenanceWorkOrder (
    WorkOrderID       BIGINT IDENTITY PRIMARY KEY,           
    VehicleID         INT     NOT NULL                         
        FOREIGN KEY REFERENCES [Transport].Vehicle(VehicleID),
    MaintenanceTypeID INT     NOT NULL                         
        FOREIGN KEY REFERENCES [Lookup].LkpMaintenanceType(MaintenanceTypeID),
    MechanicEmpID     INT     NOT NULL,                        
    OpenDT            DATETIME NOT NULL,                       
    CloseDT           DATETIME NULL,                           
    OdometerAtService INT     NULL,                            
    RootCause         NVARCHAR(200) NULL,                      
    LaborHours        DECIMAL(6,2) NOT NULL DEFAULT 0,         
    TotalCost         MONEY    NULL,                            
    WarrantyClaim     BIT      NOT NULL DEFAULT 0              
);


-- =============================================================================
-- Table: WorkOrderPartReplacement
-- Purpose: Junction table recording each part installed on a work order.
-- Columns:
--   WorkOrderID      : FK → MaintenanceWorkOrder(WorkOrderID).
--   PartID           : FK → Part(PartID).
--   SupplierID       : FK → Supplier(SupplierID), who supplied the part (optional).
--   Quantity         : Number of units installed.
--   UnitCost         : Cost per unit at installation time.
-- Constraints:
--   PK (WorkOrderID, PartID): Ensures unique part entry per work order.
-- =============================================================================
CREATE TABLE [Maintenance].WorkOrderPartReplacement (
    WorkOrderID    BIGINT      NOT NULL                    
        FOREIGN KEY REFERENCES [Maintenance].MaintenanceWorkOrder(WorkOrderID),
    PartID         INT         NOT NULL                    
        FOREIGN KEY REFERENCES [Maintenance].Part(PartID),
    SupplierID     INT         NULL                          
        FOREIGN KEY REFERENCES [Maintenance].Supplier(SupplierID),
    Quantity       SMALLINT    NOT NULL,                     
    UnitCost       MONEY       NOT NULL,                     
    CONSTRAINT PK_WO_Part PRIMARY KEY (WorkOrderID, PartID)  
);


-- =============================================================================
-- Table: FuelingEvent
-- Purpose: Logs every fueling or oil-change event for a vehicle.
-- Columns:
--   FuelEventID      : Surrogate PK, auto-increment.
--   VehicleID        : FK → Vehicle(VehicleID), bus fueled.
--   FuelTypeID       : FK → LkpFuelType(FuelTypeID), type of fuel.
--   FuelDT           : Date/time of fueling.
--   Liters           : Quantity of fuel in liters.
--   Cost             : Total cost for this fueling event.
-- =============================================================================
CREATE TABLE [Maintenance].FuelingEvent (
    FuelEventID    BIGINT IDENTITY PRIMARY KEY,        
    VehicleID      INT     NOT NULL                        
        FOREIGN KEY REFERENCES [Transport].Vehicle(VehicleID),
    FuelTypeID     INT     NOT NULL                        
        FOREIGN KEY REFERENCES [Lookup].LkpFuelType(FuelTypeID),
    FuelDT         DATETIME2 NOT NULL,                     
    Liters         DECIMAL(8,2) NOT NULL,                  
    Cost           MONEY      NOT NULL                   
);




/*===============================================================================
  4) HUMAN RESOURCE DOMAIN (feeds HR Mart)
  -----------------------------------------------------------------------------
  These tables manage employee data, role history, shifts, and payroll transactions.
===============================================================================*/

-- =============================================================================
-- Table: Employee
-- Purpose: Master data for each staff member (driver, mechanic, clerk, etc.).
-- Columns:
--   EmpID            : Surrogate PK, auto-increment.
--   FirstName        : Employee’s first name.
--   LastName         : Employee’s last name.
--   NationalID       : Government-issued ID (unique, optional).
--   DateOfBirth      : Birthdate (optional).
--   HireDate         : Date when employee joined (not NULL).
--   DepartmentID     : FK → LkpDepartment, department assignment.
--   Email            : Company email (unique, optional).
--   PhoneNumber      : Contact phone number (optional).
--   Gender           : 'M', 'F', or 'O' (optional).
--   Address          : Home address (optional).
--   EmergencyName    : Name of emergency contact (optional).
--   EmergencyPhone   : Phone number of emergency contact (optional).
--   BankAccountNo    : Bank account for payroll (optional).
--   BaseSalary       : Monthly base salary (optional).
--   PhotoUrl         : URL to employee photo (optional).
--   CreatedAt        : Record creation timestamp.
--   UpdatedAt        : Last record update timestamp.
-- =============================================================================
CREATE TABLE [HR].Employee (
    EmpID            INT IDENTITY PRIMARY KEY,
    FirstName        NVARCHAR(100) NOT NULL,
    LastName         NVARCHAR(100) NOT NULL,
    NationalID       CHAR(10) UNIQUE,
    DateOfBirth      DATE      NULL,
    HireDate         DATE      NOT NULL,
    DepartmentID     INT       NOT NULL    
        FOREIGN KEY REFERENCES [Lookup].LkpDepartment(DepartmentID),
    Email            NVARCHAR(100) UNIQUE NULL,
    PhoneNumber      VARCHAR(20)   NULL,
    Gender           CHAR(1)      NULL,
    Address          NVARCHAR(200) NULL,
    EmergencyName    NVARCHAR(100) NULL,
    EmergencyPhone   VARCHAR(20)   NULL,
    BankAccountNo    VARCHAR(34)   NULL,
    BaseSalary       MONEY        NULL,
    PhotoUrl         VARCHAR(255)  NULL,
    CreatedAt        DATETIME     NOT NULL DEFAULT GETDATE(),
    UpdatedAt        DATETIME     NOT NULL DEFAULT GETDATE()
);


-- =============================================================================
-- Table: EmployeeRoleHistory
-- Purpose: Tracks changes in employee job title over time.
-- Columns:
--   EmpID            : FK → Employee(EmpID), employee in question.
--   RoleStartDT      : Timestamp when new role began.
--   RoleEndDT        : Timestamp when role ended (NULL if current).
--   RoleID           : FK → LkpRole, job title code.
-- Constraints:
--   PK (EmpID, RoleStartDT): Ensures unique start time per employee.
-- =============================================================================
CREATE TABLE [HR].EmployeeRoleHistory (
    EmpID          INT        NOT NULL
        FOREIGN KEY REFERENCES [HR].Employee(EmpID),
    RoleStartDT    DATETIME   NOT NULL,
    RoleEndDT      DATETIME   NULL,
    RoleID         INT        NOT NULL
        FOREIGN KEY REFERENCES [Lookup].LkpRole(RoleID),
    CONSTRAINT PK_EmpRoleHist PRIMARY KEY (EmpID, RoleStartDT)
);


-- =============================================================================
-- Table: Shift
-- Purpose: Records each work shift for employees (for attendance and payroll).
-- Columns:
--   ShiftID          : Surrogate PK, auto-increment.
--   EmpID            : FK → Employee(EmpID), employee working.
--   ShiftTypeID      : FK → LkpShiftType, shift pattern (Morning, Night, etc.).
--   ShiftStartDT     : Datetime when shift began.
--   ShiftEndDT       : Datetime when shift ended.
--   HoursWorked      : Actual hours worked (may include break adjustments).
--   OvertimeHrs      : Hours beyond standard shift (default 0).
-- Index:
--   IX_Shift_Emp_Time: Speeds queries for latest shifts per employee.
-- =============================================================================
CREATE TABLE [HR].[Shift] (
    ShiftID        BIGINT      IDENTITY PRIMARY KEY,   
    EmpID          INT         NOT NULL                
        FOREIGN KEY REFERENCES [HR].Employee(EmpID),
    ShiftTypeID    INT         NOT NULL                
        FOREIGN KEY REFERENCES [Lookup].LkpShiftType(ShiftTypeID),
    ShiftStartDT   DATETIME    NOT NULL,               
    ShiftEndDT     DATETIME    NOT NULL,               
    HoursWorked    DECIMAL(6,2) NULL,                  
    OvertimeHrs    DECIMAL(5,2) NOT NULL DEFAULT 0     
);
CREATE INDEX IX_Shift_Emp_Time
    ON [HR].[Shift] (EmpID, ShiftStartDT DESC);


-- =============================================================================
-- Table: PayrollTxn
-- Purpose: Records monthly payroll for employees, including deductions.
-- Columns:
--   PayrollID      : Surrogate PK, auto-increment.
--   EmpID          : FK → Employee(EmpID), who is paid.
--   PeriodMonth    : Month string in format 'YYYY-MM'.
--   GrossPay       : Total pre-tax pay for the period.
--   NetPay         : Total after-tax pay.
--   TaxAmt         : Total tax withheld.
--   InsuranceAmt   : Total insurance deduction.
-- =============================================================================
CREATE TABLE [HR].PayrollTxn (
    PayrollID      BIGINT      IDENTITY PRIMARY KEY,
    EmpID          INT         NOT NULL
        FOREIGN KEY REFERENCES [HR].Employee(EmpID),
    PeriodMonth    CHAR(7)     NOT NULL,
    GrossPay       MONEY       NOT NULL,
    NetPay         MONEY       NOT NULL,
    TaxAmt         MONEY       NOT NULL,
    InsuranceAmt   MONEY       NOT NULL
);

