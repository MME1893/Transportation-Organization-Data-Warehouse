/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/

Use Transit
GO


/* 5. HR -------------------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'HR')
    EXEC (N'CREATE SCHEMA [HR]');
GO



-- Step 1: Drop all foreign key constraints referencing HR tables
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] 
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('HR.Employee'),
    OBJECT_ID('HR.EmployeeRoleHistory'),
    OBJECT_ID('HR.Shift'),
    OBJECT_ID('HR.PayrollTxn')
);

EXEC sp_executesql @sql;

-- Step 2: Drop the HR tables if they exist (in dependency-safe order)
IF OBJECT_ID(N'HR.EmployeeRoleHistory', N'U') IS NOT NULL
    DROP TABLE HR.EmployeeRoleHistory;

IF OBJECT_ID(N'HR.PayrollTxn', N'U') IS NOT NULL
    DROP TABLE HR.PayrollTxn;

IF OBJECT_ID(N'HR.Shift', N'U') IS NOT NULL
    DROP TABLE HR.Shift;

IF OBJECT_ID(N'HR.Employee', N'U') IS NOT NULL
    DROP TABLE HR.Employee;


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

