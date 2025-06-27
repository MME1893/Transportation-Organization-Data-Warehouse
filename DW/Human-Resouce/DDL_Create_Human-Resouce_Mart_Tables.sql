Use TransitDW;

go
 CREATE SCHEMA [Human-Resouce];


IF OBJECT_ID('[Human-Resouce].[DimShiftType]', 'U') IS NOT NULL DROP TABLE [Human-Resouce].[DimShiftType];
IF OBJECT_ID('[Human-Resouce].[FactTrnsShift]', 'U') IS NOT NULL DROP TABLE [Human-Resouce].[FactTrnsShift];
IF OBJECT_ID('[Human-Resouce].[FactMonthlyPayroll]', 'U') IS NOT NULL DROP TABLE [Human-Resouce].[FactMonthlyPayroll];








/*===============================================================================
						 Human-Resouce Mart Dimentions
===============================================================================*/




/*********************    DimShiftType Table    *********************/--


CREATE TABLE [Human-Resouce].DimShiftType (
    ShiftTypeID_BK INT			, -- NOT NULL UNIQUE,
    ShiftCode     VARCHAR(50)	,
    Label_EN      VARCHAR(100)	,
    Label_FA      NVARCHAR(100)
);



/*===============================================================================
						 Human-Resouce Mart Facts
===============================================================================*/



/*********************    FactTrnsShift Table    *********************/--

CREATE TABLE [Human-Resouce].FactTrnsShift (            -- transactional
    EmployeeKey   INT		, -- NOT NULL REFERENCES DimEmployee(EmployeeKey),
    DateKey       INT		, -- NOT NULL REFERENCES DimDate(DateKey),  -- shift start date
    ShiftTypeKey  INT		, -- NOT NULL REFERENCES DimShiftType(ShiftTypeKey),
    StartTimeKey  SMALLINT	, -- REFERENCES DimTime(TimeKey),
    EndTimeKey    SMALLINT	, -- REFERENCES DimTime(TimeKey),
    HoursWorked   DECIMAL(6,2)	,
    OvertimeHours DECIMAL(6,2)	,
    ShiftAllowance MONEY
);



/*********************    FactAccTap Table    *********************/--


CREATE TABLE [Human-Resouce].FactMonthlyPayroll (          -- monthly snapshot
    EmployeeKey   INT	, -- NOT NULL REFERENCES DimEmployee(EmployeeKey),
    DateKey		  INT	, -- NOT NULL REFERENCES DimDate(time_Key_Year_Month),  -- e.g., first day of month
    GrossPay      MONEY , -- NOT NULL,
    NetPay        MONEY , -- NOT NULL,
    TaxAmount     MONEY , -- NOT NULL,
    InsuranceAmt  MONEY	  -- NOT NULL
);

