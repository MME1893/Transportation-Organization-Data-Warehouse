/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/




/* 4. Maintenance ---------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Maintenance')
    EXEC (N'CREATE SCHEMA [Maintenance]');
GO


-- Step 1: Drop all foreign key constraints referencing the Maintenance tables
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] 
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('Maintenance.FuelingEvent'),
    OBJECT_ID('Maintenance.WorkOrderPartReplacement'),
    OBJECT_ID('Maintenance.MaintenanceWorkOrder'),
    OBJECT_ID('Maintenance.Supplier'),
    OBJECT_ID('Maintenance.Part')
);

EXEC sp_executesql @sql;

-- Step 2: Drop the Maintenance tables if they exist
IF OBJECT_ID(N'Maintenance.FuelingEvent', N'U') IS NOT NULL
    DROP TABLE Maintenance.FuelingEvent;

IF OBJECT_ID(N'Maintenance.WorkOrderPartReplacement', N'U') IS NOT NULL
    DROP TABLE Maintenance.WorkOrderPartReplacement;

IF OBJECT_ID(N'Maintenance.MaintenanceWorkOrder', N'U') IS NOT NULL
    DROP TABLE Maintenance.MaintenanceWorkOrder;

IF OBJECT_ID(N'Maintenance.Supplier', N'U') IS NOT NULL
    DROP TABLE Maintenance.Supplier;

IF OBJECT_ID(N'Maintenance.Part', N'U') IS NOT NULL
    DROP TABLE Maintenance.Part;


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
