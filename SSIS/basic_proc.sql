CREATE TABLE [Global].[Log] (
    LogID               BIGINT       IDENTITY,    
        -- Surrogate key for easy reference and clustering
    
    LogDate             DATETIME2    NOT NULL
        CONSTRAINT DF_Log_LogDate DEFAULT SYSUTCDATETIME(), 
        -- When the event was logged (default = current UTC‐adjusted timestamp)
    
    ProcedureName       VARCHAR(128) NOT NULL,                
        -- Name (or identifier) of the stored procedure/job
    
    ExecutedBy          VARCHAR(128) NULL,                    
        -- Optional: user or service account that executed it (e.g. Svc_ETL, DOMAIN\User)
    
    TableName           VARCHAR(128) NULL,                    
        -- Which target table was affected (if any)
    
    RowsAffected        INT          NULL,                    
        -- Number of rows inserted/updated/deleted (INT rather than VARCHAR)
    
    SeverityLevel       VARCHAR(20)  NOT NULL 
        CONSTRAINT DF_Log_SeverityLevel DEFAULT 'INFO',  
        -- e.g. INFO, WARN, ERROR; helps classify log entries
        
    Description         VARCHAR(512) NULL,                    
        -- Free‐text details: success message, error message, etc.

    CONSTRAINT CK_Log_SeverityLevel 
        CHECK (SeverityLevel IN ('DEBUG','INFO','WARN','ERROR','FATAL'))
        -- Restrict to known levels
);

CREATE OR ALTER PROCEDURE Run_All_SA_Procedures
AS
BEGIN
    -- Logging start of the entire process
    EXEC [TransitDW].[Global].LogAction
         @TableName     = 'ALL_SA_TABLES',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = 'Starting population of all SA tables',
         @ProcedureName = 'Run_All_SA_Procedures';

    BEGIN TRY
        -- Execute all lookup table procedures first
        EXEC Fill_SA_LkpVehicleType;
        EXEC Fill_SA_LkpVehicleStatus;
        EXEC Fill_SA_LkpRouteStatus;
        EXEC Fill_SA_LkpJourneyStatus;
        EXEC Fill_SA_LkpDeviceType;
        EXEC Fill_SA_LkpDeviceStatus;
        EXEC Fill_SA_LkpCardType;
        EXEC Fill_SA_LkpCardStatus;
        EXEC Fill_SA_LkpPaymentMethod;
        EXEC Fill_SA_LkpSalesChannel;
        EXEC Fill_SA_LkpMaintenanceType;
        EXEC Fill_SA_LkpPartCategory;
        EXEC Fill_SA_LkpRole;
        EXEC Fill_SA_LkpDepartment;
        EXEC Fill_SA_LkpShiftType;
        EXEC Fill_SA_LkpFuelType;

        -- Execute dimension table procedures
        EXEC Fill_SA_Station;
        EXEC Fill_SA_Route;
        EXEC Fill_SA_RouteStation;
        EXEC Fill_SA_Vehicle;
        EXEC Fill_SA_VehicleStatusHistory;
        EXEC Fill_SA_Journey;
        EXEC Fill_SA_JourneyStatusEvent;
        EXEC Fill_SA_ArrivalEvent;
        EXEC Fill_SA_PaymentDevice;
        EXEC Fill_SA_DeviceAssignment;
        EXEC Fill_SA_PaymentTxn;
        EXEC Fill_SA_Card;
        EXEC Fill_SA_CardTopUpTxn;
        EXEC Fill_SA_Ticket;
        EXEC Fill_SA_TicketSaleTxn;
        EXEC Fill_SA_Part;
        EXEC Fill_SA_Supplier;
        EXEC Fill_SA_MaintenanceWorkOrder;
        EXEC Fill_SA_WorkOrderPartReplacement;
        EXEC Fill_SA_FuelingEvent;
        EXEC Fill_SA_Employee;
        EXEC Fill_SA_EmployeeRoleHistory;
        EXEC Fill_SA_Shift;
        EXEC Fill_SA_PayrollTxn;

        -- Logging successful completion
        EXEC [TransitDW].[Global].LogAction
             @TableName     = 'ALL_SA_TABLES',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = 'Successfully populated all SA tables',
             @ProcedureName = 'Run_All_SA_Procedures';
    END TRY
    BEGIN CATCH
        -- Logging error
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        
        EXEC [TransitDW].[Global].LogAction
             @TableName     = 'ALL_SA_TABLES',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = 'Run_All_SA_Procedures';
        
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE [Global].Run_All_Dimension_Procedures
AS
BEGIN
    -- Logging start of the entire process
    EXEC [Global].LogAction
         @TableName     = 'ALL_DIMENSION_TABLES',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = 'Starting population of all dimension tables',
         @ProcedureName = 'Run_All_Dimension_Procedures';

    BEGIN TRY
        -- First fill date and time dimensions
        EXEC [Global].First_Fill_DimDate;
        EXEC [Global].First_Fill_DimTime;
        
        -- Then fill other dimension tables
        EXEC [Global].First_Fill_DimEmployee @option = 1; -- Truncate if exists
        EXEC [Global].First_Fill_DimPaymentMethod;
        EXEC [Global].First_Fill_DimRoute;
        EXEC [Global].First_Fill_DimStation;
        EXEC [Global].First_Fill_DimVehicle;
        EXEC [Global].First_Fill_DimVehicleStatus;

        -- Logging successful completion
        EXEC [Global].LogAction
             @TableName     = 'ALL_DIMENSION_TABLES',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = 'Successfully populated all dimension tables',
             @ProcedureName = 'Run_All_Dimension_Procedures';
    END TRY
    BEGIN CATCH
        -- Logging error
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        
        EXEC [Global].LogAction
             @TableName     = 'ALL_DIMENSION_TABLES',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = 'Run_All_Dimension_Procedures';
        
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE [Global].Run_All_Incremental_Dimension_Procedures
    @EndDateForDimDate SMALLINT = NULL -- پارامتر اختیاری برای پر کردن DimDate تا سال خاص
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Logging start of the entire process
    EXEC [Global].LogAction
         @TableName     = 'ALL_INCREMENTAL_DIMENSIONS',
         @RowsAffected  = 0,
         @SeverityLevel = 'INFO',
         @Description   = 'Starting incremental update of all dimension tables',
         @ProcedureName = 'Run_All_Incremental_Dimension_Procedures';

    BEGIN TRY
        -- First update date dimension if parameter is provided
        IF @EndDateForDimDate IS NOT NULL
        BEGIN
            EXEC [Global].Incrementally_Fill_DimDate @EndDateForDimDate;
        END
        
        -- Then update other dimension tables in logical order
        -- 1. ابتدا جداول lookup/مرجع
        EXEC [Global].Incrementally_Fill_DimPaymentMethod;
        EXEC [Global].Incrementally_Fill_DimVehicleStatus;
        
        -- 2. سپس جداول اصلی بعدها
        EXEC [Global].Incrementally_Fill_DimStation;
        EXEC [Global].Incrementally_Fill_DimRoute;
        EXEC [Global].Incrementally_Fill_DimVehicle;
        
        -- 3. در نهایت بعدهای پیچیده‌تر با SCD
        EXEC [Global].Incrementally_Fill_DimEmployee;

        -- Logging successful completion
        EXEC [Global].LogAction
             @TableName     = 'ALL_INCREMENTAL_DIMENSIONS',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = 'Successfully updated all dimension tables incrementally',
             @ProcedureName = 'Run_All_Incremental_Dimension_Procedures';
    END TRY
    BEGIN CATCH
        -- Logging error
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        
        EXEC [Global].LogAction
             @TableName     = 'ALL_INCREMENTAL_DIMENSIONS',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = 'Run_All_Incremental_Dimension_Procedures';
        
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE [Transport].RunAllFirstFillProcedures
    @option INT = 0  -- Default option (0 = abort if tables have data)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Log start of the process
        EXEC [Global].LogAction
             @TableName     = N'AllFirstFillProcedures',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Starting ALL first-fill procedures',
             @ProcedureName = N'RunAllFirstFillProcedures';
        
        -- Dimension tables first
        EXEC [Transport].First_Fill_DimJourneyStatus;
        EXEC [Transport].First_Fill_DimRouteStatus;
        EXEC [Transport].First_Fill_DimDevice;
        EXEC [Transport].First_Fill_FactlessRouteStation;
        
        -- Fact tables (in dependency order)
        EXEC [Transport].First_Fill_FactTrnsTap @option;
        EXEC [Transport].First_Fill_FactDailyTap;
        EXEC [Transport].First_Fill_FactAccTap;
        
        EXEC [Transport].First_Fill_FactTrnsArrival @option;
        EXEC [Transport].First_Fill_FactAccJourney @option;
        EXEC [Transport].First_Fill_FactDailyVehicleStatus @option;
        
        -- Log completion
        EXEC [Global].LogAction
             @TableName     = N'AllFirstFillProcedures',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Completed ALL first-fill procedures successfully',
             @ProcedureName = N'RunAllFirstFillProcedures';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Log the error
        EXEC [Global].LogAction
             @TableName     = N'AllFirstFillProcedures',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = N'RunAllFirstFillProcedures';
        
        -- Re-throw the error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE [Financial].[FirstLoad_FinancialDataWarehouse]
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        /*-------------------------------------------------------------*/
        /* 1. Start log                                                */
        /*-------------------------------------------------------------*/
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Starting FIRST load of Financial Data Warehouse',
             @ProcedureName = N'FirstLoad_FinancialDataWarehouse';
        
        /*-------------------------------------------------------------*/
        /* 2. Load dimension tables                                    */
        /*-------------------------------------------------------------*/
        EXEC [Financial].First_Fill_DimCardType;
        EXEC [Financial].First_Fill_DimCardStatus;
        EXEC [Financial].First_Fill_DimSalesChannel;
        
        /*-------------------------------------------------------------*/
        /* 3. Load transaction fact tables                             */
        /*-------------------------------------------------------------*/
        EXEC [Financial].First_Fill_FactTrnsCardTopUp;
        EXEC [Financial].First_Fill_FactTrnsTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 4. Load daily aggregate fact tables                        */
        /*-------------------------------------------------------------*/
        EXEC [Financial].First_Fill_FactDailyCardTopUp;
        EXEC [Financial].First_Fill_FactDailyTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 5. Load accumulated fact tables                             */
        /*-------------------------------------------------------------*/
        EXEC [Financial].First_Fill_FactAccCardTopUp;
        EXEC [Financial].First_Fill_FactAccTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 6. Completion log                                           */
        /*-------------------------------------------------------------*/
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Successfully completed FIRST load of Financial Data Warehouse',
             @ProcedureName = N'FirstLoad_FinancialDataWarehouse';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = N'FirstLoad_FinancialDataWarehouse';
             
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO

USE TransitDW;
GO

CREATE OR ALTER PROCEDURE [Financial].[IncrementalLoad_FinancialDataWarehouse]
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        /*-------------------------------------------------------------*/
        /* 1. Start log                                                */
        /*-------------------------------------------------------------*/
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Starting INCREMENTAL load of Financial Data Warehouse',
             @ProcedureName = N'IncrementalLoad_FinancialDataWarehouse';
        
        /*-------------------------------------------------------------*/
        /* 2. Load dimension tables                                    */
        /*-------------------------------------------------------------*/
        EXEC [Financial].Incrementally_Fill_DimCardType;
        EXEC [Financial].Incrementally_Fill_DimCardStatus;
        EXEC [Financial].Incrementally_Fill_DimSalesChannel;
        
        /*-------------------------------------------------------------*/
        /* 3. Load transaction fact tables                             */
        /*-------------------------------------------------------------*/
        EXEC [Financial].Incrementally_Fill_FactTrnsCardTopUp;
        EXEC [Financial].Incrementally_Fill_FactTrnsTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 4. Load daily aggregate fact tables                         */
        /*-------------------------------------------------------------*/
        EXEC [Financial].Incrementally_FactDailyCardTopUp;
        EXEC [Financial].Incrementally_FactDailyTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 5. Load accumulated fact tables                             */
        /*-------------------------------------------------------------*/
        EXEC [Financial].Incrementally_Fill_FactAccCardTopUp;
        EXEC [Financial].Incrementally_Fill_FactAccTicketSale;
        
        /*-------------------------------------------------------------*/
        /* 6. Completion log                                           */
        /*-------------------------------------------------------------*/
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'INFO',
             @Description   = N'Successfully completed INCREMENTAL load of Financial Data Warehouse',
             @ProcedureName = N'IncrementalLoad_FinancialDataWarehouse';
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        EXEC [Global].LogAction
             @TableName     = N'FinancialDataWarehouse',
             @RowsAffected  = 0,
             @SeverityLevel = 'ERROR',
             @Description   = @ErrorMessage,
             @ProcedureName = N'IncrementalLoad_FinancialDataWarehouse';
             
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
