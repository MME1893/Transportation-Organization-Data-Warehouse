USE TransitSA
Go
IF OBJECT_ID('SA_LkpVehicleType', 'U') IS NOT NULL DROP TABLE SA_LkpVehicleType;
IF OBJECT_ID('SA_LkpVehicleStatus', 'U') IS NOT NULL DROP TABLE SA_LkpVehicleStatus;
IF OBJECT_ID('SA_LkpRouteStatus', 'U') IS NOT NULL DROP TABLE SA_LkpRouteStatus;
IF OBJECT_ID('SA_LkpJourneyStatus', 'U') IS NOT NULL DROP TABLE SA_LkpJourneyStatus;
IF OBJECT_ID('SA_LkpDeviceType', 'U') IS NOT NULL DROP TABLE SA_LkpDeviceType;
IF OBJECT_ID('SA_LkpDeviceStatus', 'U') IS NOT NULL DROP TABLE SA_LkpDeviceStatus;
IF OBJECT_ID('SA_LkpCardType', 'U') IS NOT NULL DROP TABLE SA_LkpCardType;
IF OBJECT_ID('SA_LkpCardStatus', 'U') IS NOT NULL DROP TABLE SA_LkpCardStatus;
IF OBJECT_ID('SA_LkpPaymentMethod', 'U') IS NOT NULL DROP TABLE SA_LkpPaymentMethod;
IF OBJECT_ID('SA_LkpSalesChannel', 'U') IS NOT NULL DROP TABLE SA_LkpSalesChannel;
IF OBJECT_ID('SA_LkpMaintenanceType', 'U') IS NOT NULL DROP TABLE SA_LkpMaintenanceType;
IF OBJECT_ID('SA_LkpPartCategory', 'U') IS NOT NULL DROP TABLE SA_LkpPartCategory;
IF OBJECT_ID('SA_LkpRole', 'U') IS NOT NULL DROP TABLE SA_LkpRole;
IF OBJECT_ID('SA_LkpDepartment', 'U') IS NOT NULL DROP TABLE SA_LkpDepartment;
IF OBJECT_ID('SA_LkpShiftType', 'U') IS NOT NULL DROP TABLE SA_LkpShiftType;
IF OBJECT_ID('SA_LkpFuelType', 'U') IS NOT NULL DROP TABLE SA_LkpFuelType;
IF OBJECT_ID('SA_Station', 'U') IS NOT NULL DROP TABLE SA_Station;
IF OBJECT_ID('SA_Route', 'U') IS NOT NULL DROP TABLE SA_Route;
IF OBJECT_ID('SA_RouteStation', 'U') IS NOT NULL DROP TABLE SA_RouteStation;
IF OBJECT_ID('SA_Vehicle', 'U') IS NOT NULL DROP TABLE SA_Vehicle;
IF OBJECT_ID('SA_VehicleStatusHistory', 'U') IS NOT NULL DROP TABLE SA_VehicleStatusHistory;
IF OBJECT_ID('SA_Journey', 'U') IS NOT NULL DROP TABLE SA_Journey;
IF OBJECT_ID('SA_JourneyStatusEvent', 'U') IS NOT NULL DROP TABLE SA_JourneyStatusEvent;
IF OBJECT_ID('SA_ArrivalEvent', 'U') IS NOT NULL DROP TABLE SA_ArrivalEvent;
IF OBJECT_ID('SA_PaymentDevice', 'U') IS NOT NULL DROP TABLE SA_PaymentDevice;
IF OBJECT_ID('SA_DeviceAssignment', 'U') IS NOT NULL DROP TABLE SA_DeviceAssignment;
IF OBJECT_ID('SA_PaymentTxn', 'U') IS NOT NULL DROP TABLE SA_PaymentTxn;
IF OBJECT_ID('SA_Card', 'U') IS NOT NULL DROP TABLE SA_Card;
IF OBJECT_ID('SA_CardTopUpTxn', 'U') IS NOT NULL DROP TABLE SA_CardTopUpTxn;
IF OBJECT_ID('SA_Ticket', 'U') IS NOT NULL DROP TABLE SA_Ticket;
IF OBJECT_ID('SA_TicketSaleTxn', 'U') IS NOT NULL DROP TABLE SA_TicketSaleTxn;
IF OBJECT_ID('SA_Part', 'U') IS NOT NULL DROP TABLE SA_Part;
IF OBJECT_ID('SA_Supplier', 'U') IS NOT NULL DROP TABLE SA_Supplier;
IF OBJECT_ID('SA_MaintenanceWorkOrder', 'U') IS NOT NULL DROP TABLE SA_MaintenanceWorkOrder;
IF OBJECT_ID('SA_WorkOrderPartReplacement', 'U') IS NOT NULL DROP TABLE SA_WorkOrderPartReplacement;
IF OBJECT_ID('SA_FuelingEvent', 'U') IS NOT NULL DROP TABLE SA_FuelingEvent;
IF OBJECT_ID('SA_Employee', 'U') IS NOT NULL DROP TABLE SA_Employee;
IF OBJECT_ID('SA_EmployeeRoleHistory', 'U') IS NOT NULL DROP TABLE SA_EmployeeRoleHistory;
IF OBJECT_ID('SA_Shift', 'U') IS NOT NULL DROP TABLE SA_Shift;
IF OBJECT_ID('SA_PayrollTxn', 'U') IS NOT NULL DROP TABLE SA_PayrollTxn;



CREATE TABLE SA_LkpVehicleType (
    VehicleTypeID   INT,     
    TypeCode        VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)           
);

CREATE TABLE SA_LkpVehicleStatus (
    VehicleStatusID INT,       
    StatusCode      VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpRouteStatus (
    RouteStatusID   INT,       
    StatusCode      VARCHAR(50), --  30 more
    Label_EN        VARCHAR(100),    -- 50 more      
    Label_FA        NVARCHAR(100) -- 50 more
);

CREATE TABLE SA_LkpJourneyStatus (
    JourneyStatusID INT,       
    StatusCode      VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpDeviceType (
    DeviceTypeID    INT,       
    TypeCode        VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpDeviceStatus (
    DeviceStatusID  INT,       
    StatusCode      VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpCardType (
    CardTypeID      INT,       
    TypeCode        VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpCardStatus (
    CardStatusID    INT,       
    StatusCode      VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpPaymentMethod (
    PaymentMethodID INT,       
    MethodCode      VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpSalesChannel (
    SalesChannelID  INT,       
    ChannelCode     VARCHAR(50),   
    Label_EN        VARCHAR(100),          
    Label_FA        NVARCHAR(100)
);

CREATE TABLE SA_LkpMaintenanceType (
    MaintenanceTypeID INT,     
    TypeCode          VARCHAR(50), 
    Label_EN          VARCHAR(100),        
    Label_FA          NVARCHAR(100)
);

CREATE TABLE SA_LkpPartCategory (
    PartCategoryID   INT,      
    ParentCategoryID INT,
    CategoryCode     VARCHAR(50),   
    Label_EN         VARCHAR(100),          
    Label_FA         NVARCHAR(100)
);

CREATE TABLE SA_LkpRole (
    RoleID     INT,            
    RoleCode   VARCHAR(50),        
    Label_EN   VARCHAR(100),               
    Label_FA   NVARCHAR(100)
);

CREATE TABLE SA_LkpDepartment (
    DepartmentID INT,           
    DeptCode     VARCHAR(50),       
    Label_EN     VARCHAR(100),              
    Label_FA     NVARCHAR(100)
);

CREATE TABLE SA_LkpShiftType (
    ShiftTypeID INT,            
    ShiftCode   VARCHAR(50),        
    Label_EN    VARCHAR(100),               
    Label_FA    NVARCHAR(100)
);

CREATE TABLE SA_LkpFuelType (
    FuelTypeID INT,            
    FuelCode   VARCHAR(50),        
    Label_EN   VARCHAR(100),               
    Label_FA   NVARCHAR(100)
);

CREATE TABLE SA_Station (
    StationID      INT,
    StationName    NVARCHAR(150), -- 50 char more
    Latitude       DECIMAL(9,6),          
    Longitude      DECIMAL(9,6),             
    StreetAddress  NVARCHAR(200), -- 50 more              
    City           NVARCHAR(100), -- 50 more              
    ZoneCode       VARCHAR(15), -- 5 more              
    OpeningDate    DATE,               
    IsAccessible   VARCHAR(10) CHECK (IsAccessible in ('Yes', 'No'))
);

CREATE TABLE SA_Route (
    RouteID        INT,         
    RouteCode      VARCHAR(15),   -- 5 more            
    RouteName      NVARCHAR(150),    -- 50 char more       
    PeakFrequency  TINYINT,                     
    OffPeakFreq    TINYINT,                     
    RouteStatusID  INT
);


CREATE TABLE SA_RouteStation (
    RouteID   INT,   
    SeqNo     SMALLINT,                   
    StationID INT
);


CREATE TABLE SA_Vehicle (
    VehicleID       INT,       
    VehicleTypeID   INT,
    PlateNo         VARCHAR(15),           
    Capacity        SMALLINT      ,         
    YearCreated     SMALLINT      ,         
    Manufacturer    VARCHAR(100)  , -- 50 more              
    Model           VARCHAR(100)   , -- 50 more     
    PurchaseDate    DATE          ,             
    EngineNumber    VARCHAR(50)   ,             
    GPSUnitSerial   VARCHAR(50)   ,             
    LastOdometerKM  INT
);


CREATE TABLE SA_VehicleStatusHistory (
    StatusHistID     BIGINT,     
    VehicleID        INT,
    VehicleStatusID  INT,
    StatusStartDT    DATETIME ,               
    StatusEndDT      DATETIME ,                   
);



CREATE TABLE SA_Journey (
    JourneyID       BIGINT,      
    VehicleID       INT   ,
    RouteID         INT   ,
    DriverEmpID     INT   ,                
    PlannedStartDT  DATETIME ,                
    ActualStartDT   DATETIME ,                    
    PlannedEndDT    DATETIME ,                
    ActualEndDT     DATETIME ,                    
    DistanceKM      DECIMAL(7,2) ,                
    PassengerCount  INT                        
);

CREATE TABLE SA_JourneyStatusEvent (
    JourneyID       BIGINT,
    StatusDT        DATETIME,              
    JourneyStatusID INT
);

CREATE TABLE SA_ArrivalEvent (
    JourneyID         BIGINT ,
    StationID         INT    ,
    ActualArrivalDT   DATETIME    ,       
    ActualDepartureDT DATETIME    ,                    
    BoardedCnt        SMALLINT    ,      
    AlightedCnt       SMALLINT    ,      
    CardBoarded       SMALLINT    ,      
    TicketBoarded     SMALLINT      
);


CREATE TABLE SA_PaymentDevice (
    DeviceID         INT,           
    DeviceCode       VARCHAR(50) ,        
    DeviceTypeID     INT ,
    DeviceStatusID   INT ,
    InstallDate      DATE ,                     
    SerialNo         VARCHAR(50) ,               
    FirmwareVersion  VARCHAR(50) ,                   
    LastServiceDT    DATE      ,                     
    IPAddress        VARCHAR(50)
);


CREATE TABLE SA_DeviceAssignment (
    AssignmentID     BIGINT    ,    
    DeviceID         INT       ,
    AssignedToType   VARCHAR(50) ,                
    VehicleID        INT         ,
    StationID        INT         ,
    AssignmentStart  DATETIME    ,                
    AssignmentEnd    DATETIME                 
);


CREATE TABLE SA_PaymentTxn (
    TxnID            BIGINT ,        
    PaymentMethodID  INT ,
    CardID           BIGINT ,
    TicketID         BIGINT ,
    StationID      INT   , 
    RouteID          INT ,
    DeviceID         INT ,
    TxnDT            DATETIME ,
    FareAmount       MONEY
);



CREATE TABLE SA_Card (
    CardID          BIGINT ,       
    CardTypeID      INT ,
    CardStatusID    INT ,
    IssueDate       DATE,                   
    ExpiryDate      DATE,                       
    CurrentBalance  MONEY,                       
    LastTopUpDT     DATETIME,                       
    IsActive        VARCHAR(10) CHECK (IsActive in ('Yes', 'No'))
);

CREATE TABLE SA_CardTopUpTxn (
    TopUpID         BIGINT ,        
    CardID          BIGINT ,
    TopUpDT         DATETIME ,                     
    Amount          MONEY ,
	StationID		INT,
    SalesChannelID  INT
);


CREATE TABLE SA_Ticket (
    TicketID        BIGINT ,       
    IssueDate       DATE   ,                 
    ExpiryDate      DATE   ,                     
    IsActive        VARCHAR(10) CHECK (IsActive in ('Yes', 'No'))
);


CREATE TABLE SA_TicketSaleTxn (
    SaleID          BIGINT,       
    TicketID        BIGINT,
    SaleDT          DATETIME ,                 
    Amount          MONEY ,                    
    StationID       INT ,
    SalesChannelID  INT
);


CREATE TABLE SA_Part (
    PartID           INT,        
    PartCategoryID   INT,
    PartName         VARCHAR(150) ,               
    UnitCostLatest   MONEY   
);


CREATE TABLE SA_Supplier (
    SupplierID       INT     ,     
    SupplierName     NVARCHAR(150) ,                
    ContactPhone     VARCHAR(20)   ,                    
    ContactEmail     VARCHAR(150)  ,                    
    AddressLine1     NVARCHAR(200) ,                    
    AddressLine2     NVARCHAR(200) ,                    
    City             NVARCHAR(100)  ,                    
    PostalCode       VARCHAR(50)   ,                    
    Country          NVARCHAR(100)  ,                    
    Website          VARCHAR(150)  ,                    
    TaxID            VARCHAR(50)   ,                    
    ContactPerson    NVARCHAR(150) ,                    
    CreatedDate      DATETIME
);


CREATE TABLE SA_MaintenanceWorkOrder (
    WorkOrderID       BIGINT ,           
    VehicleID         INT    ,
    MaintenanceTypeID INT    ,
    MechanicEmpID     INT    ,                        
    OpenDT            DATETIME ,                       
    CloseDT           DATETIME ,                           
    OdometerAtService INT     ,                            
    RootCause         NVARCHAR(250) ,                      
    LaborHours        DECIMAL(6,2) ,         
    TotalCost         MONEY    ,                            
    WarrantyClaim     VARCHAR(10) CHECK (WarrantyClaim in ('Yes', 'No'))              
);


CREATE TABLE SA_WorkOrderPartReplacement (
    WorkOrderID    BIGINT ,
    PartID         INT    ,
    SupplierID     INT    ,
    Quantity       SMALLINT    ,                     
    UnitCost       MONEY 
);

CREATE TABLE SA_FuelingEvent (
    FuelEventID    BIGINT ,        
    VehicleID      INT    ,
    FuelTypeID     INT     ,
    FuelDT         DATETIME2 ,                     
    Liters         DECIMAL(8,2) ,                  
    Cost           MONEY      
);

CREATE TABLE SA_Employee (
    EmpID            INT,
    FirstName        NVARCHAR(100),
    LastName         NVARCHAR(100),
    NationalID       CHAR(15),
    DateOfBirth      DATE,
    HireDate         DATE,
    DepartmentID     INT,
    Email            NVARCHAR(100),
    PhoneNumber      VARCHAR(50),
    Gender           VARCHAR(20) CHECK ( gender in ( 'Male' , 'Female')),
    [Address]          NVARCHAR(250),
    EmergencyName    NVARCHAR(150),
    EmergencyPhone   VARCHAR(50),
    BankAccountNo    VARCHAR(50),
    BaseSalary       MONEY,
    --PhotoUrl         VARCHAR(255),
    CreatedAt        DATETIME,
    UpdatedAt        DATETIME
);

CREATE TABLE SA_EmployeeRoleHistory (
    EmpID          INT        ,
    RoleStartDT    DATETIME   ,
    RoleEndDT      DATETIME   ,
    RoleID         INT        
);

CREATE TABLE SA_Shift (
    ShiftID        BIGINT      ,   
    EmpID          INT         ,
    ShiftTypeID    INT         ,
    ShiftStartDT   DATETIME    ,               
    ShiftEndDT     DATETIME    ,               
    HoursWorked    DECIMAL(6,2) ,                  
    OvertimeHrs    DECIMAL(5,2) 
);

CREATE TABLE SA_PayrollTxn (
    PayrollID      BIGINT       ,
    EmpID          INT          ,
    PeriodMonth    CHAR(7)      ,
    GrossPay       MONEY        ,
    NetPay         MONEY        ,
    TaxAmt         MONEY        ,
    InsuranceAmt   MONEY        
);

