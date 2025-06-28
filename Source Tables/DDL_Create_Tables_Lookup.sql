/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/
Use Transit
GO

/* 1. Lookup ---------------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Lookup')
    EXEC (N'CREATE SCHEMA [Lookup]');
GO


-- Step 1: Drop all foreign key constraints that reference Lookup tables
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] 
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('Lookup.LkpVehicleType'),
    OBJECT_ID('Lookup.LkpVehicleStatus'),
    OBJECT_ID('Lookup.LkpRouteStatus'),
    OBJECT_ID('Lookup.LkpJourneyStatus'),
    OBJECT_ID('Lookup.LkpDeviceType'),
    OBJECT_ID('Lookup.LkpDeviceStatus'),
    OBJECT_ID('Lookup.LkpCardType'),
    OBJECT_ID('Lookup.LkpCardStatus'),
    OBJECT_ID('Lookup.LkpPaymentMethod'),
    OBJECT_ID('Lookup.LkpSalesChannel'),
    OBJECT_ID('Lookup.LkpMaintenanceType'),
    OBJECT_ID('Lookup.LkpPartCategory'),
    OBJECT_ID('Lookup.LkpRole'),
    OBJECT_ID('Lookup.LkpDepartment'),
    OBJECT_ID('Lookup.LkpShiftType'),
    OBJECT_ID('Lookup.LkpFuelType')
);

EXEC sp_executesql @sql;

-- Step 2: Drop the Lookup tables if they exist
IF OBJECT_ID(N'Lookup.LkpVehicleType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpVehicleType;

IF OBJECT_ID(N'Lookup.LkpVehicleStatus', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpVehicleStatus;

IF OBJECT_ID(N'Lookup.LkpRouteStatus', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpRouteStatus;

IF OBJECT_ID(N'Lookup.LkpJourneyStatus', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpJourneyStatus;

IF OBJECT_ID(N'Lookup.LkpDeviceType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpDeviceType;

IF OBJECT_ID(N'Lookup.LkpDeviceStatus', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpDeviceStatus;

IF OBJECT_ID(N'Lookup.LkpCardType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpCardType;

IF OBJECT_ID(N'Lookup.LkpCardStatus', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpCardStatus;

IF OBJECT_ID(N'Lookup.LkpPaymentMethod', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpPaymentMethod;

IF OBJECT_ID(N'Lookup.LkpSalesChannel', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpSalesChannel;

IF OBJECT_ID(N'Lookup.LkpMaintenanceType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpMaintenanceType;

IF OBJECT_ID(N'Lookup.LkpPartCategory', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpPartCategory;

IF OBJECT_ID(N'Lookup.LkpRole', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpRole;

IF OBJECT_ID(N'Lookup.LkpDepartment', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpDepartment;

IF OBJECT_ID(N'Lookup.LkpShiftType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpShiftType;

IF OBJECT_ID(N'Lookup.LkpFuelType', N'U') IS NOT NULL
    DROP TABLE Lookup.LkpFuelType;




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