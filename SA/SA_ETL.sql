/*********************    Procedure to fill SA_LkpVehicleType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpVehicleType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpVehicleType', SUSER_SNAME(), N'SA_LkpVehicleType', NULL, 'INFO', N'Starting population of SA_LkpVehicleType table.');

	Truncate table SA_LkpVehicleType;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format TypeCode properly)
        INSERT INTO SA_LkpVehicleType (VehicleTypeID, TypeCode, Label_EN, Label_FA)
        SELECT 
            VehicleTypeID, 
            LTRIM(RTRIM(TypeCode)) AS TypeCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpVehicleType
        WHERE TypeCode IS NOT NULL AND TypeCode != '';  -- Cleansing: Only non-null and non-empty TypeCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpVehicleType', SUSER_SNAME(), N'SA_LkpVehicleType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpVehicleType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpVehicleType', SUSER_SNAME(), N'SA_LkpVehicleType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpVehicleStatus    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpVehicleStatus
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpVehicleStatus', SUSER_SNAME(), N'SA_LkpVehicleStatus', NULL, 'INFO', N'Starting population of SA_LkpVehicleStatus table.');

	Truncate table SA_LkpVehicleStatus;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format StatusCode properly)
        INSERT INTO SA_LkpVehicleStatus (VehicleStatusID, StatusCode, Label_EN, Label_FA)
        SELECT 
            VehicleStatusID, 
            LTRIM(RTRIM(StatusCode)) AS StatusCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpVehicleStatus
        WHERE StatusCode IS NOT NULL AND StatusCode != '';  -- Cleansing: Only non-null and non-empty StatusCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpVehicleStatus', SUSER_SNAME(), N'SA_LkpVehicleStatus', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpVehicleStatus table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpVehicleStatus', SUSER_SNAME(), N'SA_LkpVehicleStatus', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpRouteStatus    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpRouteStatus
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpRouteStatus', SUSER_SNAME(), N'SA_LkpRouteStatus', NULL, 'INFO', N'Starting population of SA_LkpRouteStatus table.');


	Truncate table SA_LkpRouteStatus;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format StatusCode properly)
        INSERT INTO SA_LkpRouteStatus (RouteStatusID, StatusCode, Label_EN, Label_FA)
        SELECT 
            RouteStatusID, 
            LTRIM(RTRIM(StatusCode)) AS StatusCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpRouteStatus
        WHERE StatusCode IS NOT NULL AND StatusCode != '';  -- Cleansing: Only non-null and non-empty StatusCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpRouteStatus', SUSER_SNAME(), N'SA_LkpRouteStatus', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpRouteStatus table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpRouteStatus', SUSER_SNAME(), N'SA_LkpRouteStatus', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpJourneyStatus    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpJourneyStatus
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpJourneyStatus', SUSER_SNAME(), N'SA_LkpJourneyStatus', NULL, 'INFO', N'Starting population of SA_LkpJourneyStatus table.');


	Truncate table SA_LkpJourneyStatus;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format StatusCode properly)
        INSERT INTO SA_LkpJourneyStatus (JourneyStatusID, StatusCode, Label_EN, Label_FA)
        SELECT 
            JourneyStatusID, 
            LTRIM(RTRIM(StatusCode)) AS StatusCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpJourneyStatus
        WHERE StatusCode IS NOT NULL AND StatusCode != '';  -- Cleansing: Only non-null and non-empty StatusCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpJourneyStatus', SUSER_SNAME(), N'SA_LkpJourneyStatus', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpJourneyStatus table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpJourneyStatus', SUSER_SNAME(), N'SA_LkpJourneyStatus', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpDeviceType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpDeviceType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpDeviceType', SUSER_SNAME(), N'SA_LkpDeviceType', NULL, 'INFO', N'Starting population of SA_LkpDeviceType table.');


	Truncate table SA_LkpDeviceType;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format TypeCode properly)
        INSERT INTO SA_LkpDeviceType (DeviceTypeID, TypeCode, Label_EN, Label_FA)
        SELECT 
            DeviceTypeID, 
            LTRIM(RTRIM(TypeCode)) AS TypeCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpDeviceType
        WHERE TypeCode IS NOT NULL AND TypeCode != '';  -- Cleansing: Only non-null and non-empty TypeCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDeviceType', SUSER_SNAME(), N'SA_LkpDeviceType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpDeviceType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDeviceType', SUSER_SNAME(), N'SA_LkpDeviceType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpDeviceStatus    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpDeviceStatus
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpDeviceStatus', SUSER_SNAME(), N'SA_LkpDeviceStatus', NULL, 'INFO', N'Starting population of SA_LkpDeviceStatus table.');

	Truncate table SA_LkpDeviceStatus;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format StatusCode properly)
        INSERT INTO SA_LkpDeviceStatus (DeviceStatusID, StatusCode, Label_EN, Label_FA)
        SELECT 
            DeviceStatusID, 
            LTRIM(RTRIM(StatusCode)) AS StatusCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpDeviceStatus
        WHERE StatusCode IS NOT NULL AND StatusCode != '';  -- Cleansing: Only non-null and non-empty StatusCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDeviceStatus', SUSER_SNAME(), N'SA_LkpDeviceStatus', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpDeviceStatus table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDeviceStatus', SUSER_SNAME(), N'SA_LkpDeviceStatus', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;

GO;

/*********************    Procedure to fill SA_LkpCardType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpCardType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpCardType', SUSER_SNAME(), N'SA_LkpCardType', NULL, 'INFO', N'Starting population of SA_LkpCardType table.');


	Truncate table SA_LkpCardType;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format TypeCode properly)
        INSERT INTO SA_LkpCardType (CardTypeID, TypeCode, Label_EN, Label_FA)
        SELECT 
            CardTypeID, 
            LTRIM(RTRIM(TypeCode)) AS TypeCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpCardType
        WHERE TypeCode IS NOT NULL AND TypeCode != '';  -- Cleansing: Only non-null and non-empty TypeCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpCardType', SUSER_SNAME(), N'SA_LkpCardType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpCardType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpCardType', SUSER_SNAME(), N'SA_LkpCardType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpCardStatus    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpCardStatus
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpCardStatus', SUSER_SNAME(), N'SA_LkpCardStatus', NULL, 'INFO', N'Starting population of SA_LkpCardStatus table.');

	Truncate table SA_LkpCardStatus;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format StatusCode properly)
        INSERT INTO SA_LkpCardStatus (CardStatusID, StatusCode, Label_EN, Label_FA)
        SELECT 
            CardStatusID, 
            LTRIM(RTRIM(StatusCode)) AS StatusCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpCardStatus
        WHERE StatusCode IS NOT NULL AND StatusCode != '';  -- Cleansing: Only non-null and non-empty StatusCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpCardStatus', SUSER_SNAME(), N'SA_LkpCardStatus', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpCardStatus table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpCardStatus', SUSER_SNAME(), N'SA_LkpCardStatus', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;


/*********************    Procedure to fill SA_LkpPaymentMethod    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpPaymentMethod
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpPaymentMethod', SUSER_SNAME(), N'SA_LkpPaymentMethod', NULL, 'INFO', N'Starting population of SA_LkpPaymentMethod table.');


	Truncate table SA_LkpPaymentMethod;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format MethodCode properly)
        INSERT INTO SA_LkpPaymentMethod (PaymentMethodID, MethodCode, Label_EN, Label_FA)
        SELECT 
            PaymentMethodID, 
            LTRIM(RTRIM(MethodCode)) AS MethodCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpPaymentMethod
        WHERE MethodCode IS NOT NULL AND MethodCode != '';  -- Cleansing: Only non-null and non-empty MethodCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpPaymentMethod', SUSER_SNAME(), N'SA_LkpPaymentMethod', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpPaymentMethod table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpPaymentMethod', SUSER_SNAME(), N'SA_LkpPaymentMethod', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpSalesChannel    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpSalesChannel
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpSalesChannel', SUSER_SNAME(), N'SA_LkpSalesChannel', NULL, 'INFO', N'Starting population of SA_LkpSalesChannel table.');


	Truncate table SA_LkpSalesChannel;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format ChannelCode properly)
        INSERT INTO SA_LkpSalesChannel (SalesChannelID, ChannelCode, Label_EN, Label_FA)
        SELECT 
            SalesChannelID, 
            LTRIM(RTRIM(ChannelCode)) AS ChannelCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpSalesChannel
        WHERE ChannelCode IS NOT NULL AND ChannelCode != '';  -- Cleansing: Only non-null and non-empty ChannelCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpSalesChannel', SUSER_SNAME(), N'SA_LkpSalesChannel', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpSalesChannel table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpSalesChannel', SUSER_SNAME(), N'SA_LkpSalesChannel', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpMaintenanceType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpMaintenanceType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpMaintenanceType', SUSER_SNAME(), N'SA_LkpMaintenanceType', NULL, 'INFO', N'Starting population of SA_LkpMaintenanceType table.');

	Truncate table SA_LkpMaintenanceType;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format TypeCode properly)
        INSERT INTO SA_LkpMaintenanceType (MaintenanceTypeID, TypeCode, Label_EN, Label_FA)
        SELECT 
            MaintenanceTypeID, 
            LTRIM(RTRIM(TypeCode)) AS TypeCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpMaintenanceType
        WHERE TypeCode IS NOT NULL AND TypeCode != '';  -- Cleansing: Only non-null and non-empty TypeCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpMaintenanceType', SUSER_SNAME(), N'SA_LkpMaintenanceType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpMaintenanceType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpMaintenanceType', SUSER_SNAME(), N'SA_LkpMaintenanceType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpPartCategory    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpPartCategory
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpPartCategory', SUSER_SNAME(), N'SA_LkpPartCategory', NULL, 'INFO', N'Starting population of SA_LkpPartCategory table.');

	Truncate table SA_LkpPartCategory;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format CategoryCode properly)
        INSERT INTO SA_LkpPartCategory (PartCategoryID, ParentCategoryID, CategoryCode, Label_EN, Label_FA)
        SELECT 
            PartCategoryID, 
            ParentCategoryID, 
            LTRIM(RTRIM(CategoryCode)) AS CategoryCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpPartCategory
        WHERE CategoryCode IS NOT NULL AND CategoryCode != '';  -- Cleansing: Only non-null and non-empty CategoryCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpPartCategory', SUSER_SNAME(), N'SA_LkpPartCategory', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpPartCategory table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpPartCategory', SUSER_SNAME(), N'SA_LkpPartCategory', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;


/*********************    Procedure to fill SA_LkpRole    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpRole
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpRole', SUSER_SNAME(), N'SA_LkpRole', NULL, 'INFO', N'Starting population of SA_LkpRole table.');


	Truncate table SA_LkpRole;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format RoleCode properly)
        INSERT INTO SA_LkpRole (RoleID, RoleCode, Label_EN, Label_FA)
        SELECT 
            RoleID, 
            LTRIM(RTRIM(RoleCode)) AS RoleCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpRole
        WHERE RoleCode IS NOT NULL AND RoleCode != '';  -- Cleansing: Only non-null and non-empty RoleCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpRole', SUSER_SNAME(), N'SA_LkpRole', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpRole table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpRole', SUSER_SNAME(), N'SA_LkpRole', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpDepartment    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpDepartment
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpDepartment', SUSER_SNAME(), N'SA_LkpDepartment', NULL, 'INFO', N'Starting population of SA_LkpDepartment table.');


	Truncate table SA_LkpDepartment;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format DeptCode properly)
        INSERT INTO SA_LkpDepartment (DepartmentID, DeptCode, Label_EN, Label_FA)
        SELECT 
            DepartmentID, 
            LTRIM(RTRIM(DeptCode)) AS DeptCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpDepartment
        WHERE DeptCode IS NOT NULL AND DeptCode != '';  -- Cleansing: Only non-null and non-empty DeptCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDepartment', SUSER_SNAME(), N'SA_LkpDepartment', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpDepartment table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpDepartment', SUSER_SNAME(), N'SA_LkpDepartment', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpShiftType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpShiftType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpShiftType', SUSER_SNAME(), N'SA_LkpShiftType', NULL, 'INFO', N'Starting population of SA_LkpShiftType table.');


	Truncate table SA_LkpShiftType;



    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format ShiftCode properly)
        INSERT INTO SA_LkpShiftType (ShiftTypeID, ShiftCode, Label_EN, Label_FA)
        SELECT 
            ShiftTypeID, 
            LTRIM(RTRIM(ShiftCode)) AS ShiftCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpShiftType
        WHERE ShiftCode IS NOT NULL AND ShiftCode != '';  -- Cleansing: Only non-null and non-empty ShiftCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpShiftType', SUSER_SNAME(), N'SA_LkpShiftType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpShiftType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpShiftType', SUSER_SNAME(), N'SA_LkpShiftType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;

/*********************    Procedure to fill SA_LkpFuelType    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_LkpFuelType
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_LkpFuelType', SUSER_SNAME(), N'SA_LkpFuelType', NULL, 'INFO', N'Starting population of SA_LkpFuelType table.');

	Truncate table SA_LkpFuelType;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format FuelCode properly)
        INSERT INTO SA_LkpFuelType (FuelTypeID, FuelCode, Label_EN, Label_FA)
        SELECT 
            FuelTypeID, 
            LTRIM(RTRIM(FuelCode)) AS FuelCode,  -- Cleansing: Remove leading and trailing spaces
            Label_EN, 
            Label_FA
        FROM [Lookup].LkpFuelType
        WHERE FuelCode IS NOT NULL AND FuelCode != '';  -- Cleansing: Only non-null and non-empty FuelCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpFuelType', SUSER_SNAME(), N'SA_LkpFuelType', @@ROWCOUNT, 'INFO', N'Finished population of SA_LkpFuelType table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_LkpFuelType', SUSER_SNAME(), N'SA_LkpFuelType', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_Station    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Station
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Station', SUSER_SNAME(), N'SA_Station', NULL, 'INFO', N'Starting population of SA_Station table.');

	Truncate table SA_Station;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format IsAccessible properly)
        INSERT INTO SA_Station (StationID, StationName, Latitude, Longitude, StreetAddress, City, ZoneCode, OpeningDate, IsAccessible)
        SELECT 
            StationID, 
            StationName, 
            Latitude, 
            Longitude, 
            StreetAddress, 
            City, 
            ZoneCode, 
            OpeningDate, 
            CASE 
                WHEN IsAccessible = 'Yes' THEN 'Yes'
                WHEN IsAccessible = 'No' THEN 'No'
                ELSE 'No'
            END AS IsAccessible -- Cleansing: Ensure IsAccessible is only 'Yes' or 'No'
        FROM [Transport].Station
        WHERE StationName IS NOT NULL AND StationName != '';  -- Cleansing: Only non-null and non-empty StationName values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Station', SUSER_SNAME(), N'SA_Station', @@ROWCOUNT, 'INFO', N'Finished population of SA_Station table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Station', SUSER_SNAME(), N'SA_Station', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_Route    *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Route
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Route', SUSER_SNAME(), N'SA_Route', NULL, 'INFO', N'Starting population of SA_Route table.');

	Truncate table SA_Route;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle empty fields and format RouteCode properly)
        INSERT INTO SA_Route (RouteID, RouteCode, RouteName, PeakFrequency, OffPeakFreq, RouteStatusID)
        SELECT 
            RouteID, 
            LTRIM(RTRIM(RouteCode)) AS RouteCode,  -- Cleansing: Remove leading and trailing spaces
            RouteName, 
            PeakFrequency, 
            OffPeakFreq, 
            RouteStatusID
        FROM [Transport].Route
        WHERE RouteCode IS NOT NULL AND RouteCode != '';  -- Cleansing: Only non-null and non-empty RouteCode values

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Route', SUSER_SNAME(), N'SA_Route', @@ROWCOUNT, 'INFO', N'Finished population of SA_Route table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Route', SUSER_SNAME(), N'SA_Route', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_RouteStation *********************/

CREATE OR ALTER PROCEDURE Fill_SA_RouteStation
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_RouteStation', SUSER_SNAME(), N'SA_RouteStation', NULL, 'INFO', N'Starting population of SA_RouteStation table.');

	Truncate table SA_RouteStation;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields or incorrect values)
        INSERT INTO SA_RouteStation (RouteID, SeqNo, StationID)
        SELECT 
            RouteID, 
            SeqNo, 
            StationID
        FROM [Transport].RouteStation
        WHERE RouteID IS NOT NULL AND StationID IS NOT NULL;  -- Cleansing: Ensure RouteID and StationID are not null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_RouteStation', SUSER_SNAME(), N'SA_RouteStation', @@ROWCOUNT, 'INFO', N'Finished population of SA_RouteStation table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_RouteStation', SUSER_SNAME(), N'SA_RouteStation', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_Vehicle *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Vehicle
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Vehicle', SUSER_SNAME(), N'SA_Vehicle', NULL, 'INFO', N'Starting population of SA_Vehicle table.');

	Truncate table SA_Vehicle;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing or invalid data)
        INSERT INTO SA_Vehicle (VehicleID, VehicleTypeID, PlateNo, Capacity, YearCreated, Manufacturer, Model, PurchaseDate, EngineNumber, GPSUnitSerial, LastOdometerKM)
        SELECT 
            VehicleID, 
            VehicleTypeID, 
            PlateNo, 
            Capacity, 
            YearCreated, 
            Manufacturer, 
            Model, 
            PurchaseDate, 
            EngineNumber, 
            GPSUnitSerial, 
            LastOdometerKM
        FROM [Transport].Vehicle
        WHERE PlateNo IS NOT NULL AND Capacity > 0;  -- Cleansing: Ensure PlateNo is not null and Capacity is positive

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Vehicle', SUSER_SNAME(), N'SA_Vehicle', @@ROWCOUNT, 'INFO', N'Finished population of SA_Vehicle table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Vehicle', SUSER_SNAME(), N'SA_Vehicle', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_VehicleStatusHistory *********************/

CREATE OR ALTER PROCEDURE Fill_SA_VehicleStatusHistory
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_VehicleStatusHistory', SUSER_SNAME(), N'SA_VehicleStatusHistory', NULL, 'INFO', N'Starting population of SA_VehicleStatusHistory table.');

	Truncate table SA_VehicleStatusHistory;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing or invalid data)
        INSERT INTO SA_VehicleStatusHistory (StatusHistID, VehicleID, VehicleStatusID, StatusStartDT, StatusEndDT)
        SELECT 
            StatusHistID, 
            VehicleID, 
            VehicleStatusID, 
            StatusStartDT, 
            StatusEndDT
        FROM [Transport].VehicleStatusHistory
        WHERE VehicleID IS NOT NULL AND VehicleStatusID IS NOT NULL AND StatusStartDT IS NOT NULL;  -- Cleansing: Ensure necessary fields are not null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_VehicleStatusHistory', SUSER_SNAME(), N'SA_VehicleStatusHistory', @@ROWCOUNT, 'INFO', N'Finished population of SA_VehicleStatusHistory table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_VehicleStatusHistory', SUSER_SNAME(), N'SA_VehicleStatusHistory', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_Journey *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Journey
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Journey', SUSER_SNAME(), N'SA_Journey', NULL, 'INFO', N'Starting population of SA_Journey table.');

	Truncate table SA_Journey;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Journey (JourneyID, VehicleID, RouteID, DriverEmpID, PlannedStartDT, ActualStartDT, PlannedEndDT, ActualEndDT, DistanceKM, PassengerCount)
        SELECT 
            JourneyID, 
            VehicleID, 
            RouteID, 
            DriverEmpID, 
            PlannedStartDT, 
            ActualStartDT, 
            PlannedEndDT, 
            ActualEndDT, 
            DistanceKM, 
            PassengerCount
        FROM [Transport].Journey
        WHERE JourneyID IS NOT NULL 
          AND VehicleID IS NOT NULL 
          AND RouteID IS NOT NULL;  -- Cleansing: Ensure JourneyID, VehicleID, and RouteID are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Journey', SUSER_SNAME(), N'SA_Journey', @@ROWCOUNT, 'INFO', N'Finished population of SA_Journey table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Journey', SUSER_SNAME(), N'SA_Journey', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_JourneyStatusEvent *********************/

CREATE OR ALTER PROCEDURE Fill_SA_JourneyStatusEvent -- with while we should do it 
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_JourneyStatusEvent', SUSER_SNAME(), N'SA_JourneyStatusEvent', NULL, 'INFO', N'Starting population of SA_JourneyStatusEvent table.');


	Truncate table SA_JourneyStatusEvent;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_JourneyStatusEvent (JourneyID, StatusDT, JourneyStatusID)
        SELECT 
            JourneyID, 
            StatusDT, 
            JourneyStatusID
        FROM [Transport].JourneyStatusEvent
        WHERE JourneyID IS NOT NULL 
          AND StatusDT IS NOT NULL 
          AND JourneyStatusID IS NOT NULL;  -- Cleansing: Ensure necessary fields are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_JourneyStatusEvent', SUSER_SNAME(), N'SA_JourneyStatusEvent', @@ROWCOUNT, 'INFO', N'Finished population of SA_JourneyStatusEvent table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_JourneyStatusEvent', SUSER_SNAME(), N'SA_JourneyStatusEvent', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_ArrivalEvent *********************/

CREATE OR ALTER PROCEDURE Fill_SA_ArrivalEvent
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_ArrivalEvent', SUSER_SNAME(), N'SA_ArrivalEvent', NULL, 'INFO', N'Starting population of SA_ArrivalEvent table.');

	DECLARE @max_sa_date date, @max_source_date date, @min_source_date date,
			@curr_date date, @end_date date;

	SELECT @max_source_date = CAST(MAX(ActualArrivalDT) AS DATE) FROM [Transit].[Transport].ArrivalEvent;
	SELECT @min_source_date = CAST(MIN(ActualArrivalDT) AS DATE) FROM [Transit].[Transport].ArrivalEvent;
	SELECT @max_sa_date     = CAST(MAX(ActualArrivalDT) AS DATE) FROM [SA_ArrivalEvent];
	SELECT @curr_date      = ISNULL(@max_sa_date, @min_source_date);
	SELECT @end_date	    = @max_source_date;

	WHILE @curr_date <= @end_date
	BEGIN
	    BEGIN TRY
			--SET @tmp_datetime = CAST(@curr_date AS DATETIME);
			-- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
			INSERT INTO SA_ArrivalEvent (JourneyID, StationID, ActualArrivalDT, ActualDepartureDT, BoardedCnt, AlightedCnt, CardBoarded, TicketBoarded)
			SELECT 
				JourneyID, 
				StationID, 
				ActualArrivalDT, 
				ActualDepartureDT, 
				BoardedCnt, 
				AlightedCnt, 
				CardBoarded, 
				TicketBoarded
			FROM [Transport].ArrivalEvent
			WHERE 
					CAST(ActualArrivalDT AS DATE) = @curr_date 
				AND
					JourneyID IS NOT NULL 
				AND 
					StationID IS NOT NULL;  -- Cleansing: Ensure JourneyID and StationID are non-null

			-- Logging Procedure End
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_ArrivalEvent', SUSER_SNAME(), N'SA_ArrivalEvent', @@ROWCOUNT, 'INFO', N'Finished population of SA_ArrivalEvent table.');
		END TRY
	    BEGIN CATCH
			-- Logging Error
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_ArrivalEvent', SUSER_SNAME(), N'SA_ArrivalEvent', NULL, 'ERROR', ERROR_MESSAGE());
			THROW;
		END CATCH

		SET @curr_date = DATEADD(DAY, 1, @curr_date);
	END

END;
go;
/*********************    Procedure to fill SA_PaymentDevice *********************/

CREATE OR ALTER PROCEDURE Fill_SA_PaymentDevice
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_PaymentDevice', SUSER_SNAME(), N'SA_PaymentDevice', NULL, 'INFO', N'Starting population of SA_PaymentDevice table.');

	Truncate table SA_PaymentDevice;



    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_PaymentDevice (DeviceID, DeviceCode, DeviceTypeID, DeviceStatusID, InstallDate, SerialNo, FirmwareVersion, LastServiceDT, IPAddress)
        SELECT 
            DeviceID, 
            DeviceCode, 
            DeviceTypeID, 
            DeviceStatusID, 
            InstallDate, 
            SerialNo, 
            FirmwareVersion, 
            LastServiceDT, 
            IPAddress
        FROM [Transport].PaymentDevice
        WHERE DeviceCode IS NOT NULL 
          AND SerialNo IS NOT NULL;  -- Cleansing: Ensure DeviceCode and SerialNo are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_PaymentDevice', SUSER_SNAME(), N'SA_PaymentDevice', @@ROWCOUNT, 'INFO', N'Finished population of SA_PaymentDevice table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_PaymentDevice', SUSER_SNAME(), N'SA_PaymentDevice', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_DeviceAssignment *********************/

CREATE OR ALTER PROCEDURE Fill_SA_DeviceAssignment
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_DeviceAssignment', SUSER_SNAME(), N'SA_DeviceAssignment', NULL, 'INFO', N'Starting population of SA_DeviceAssignment table.');

	Truncate table SA_DeviceAssignment;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_DeviceAssignment (AssignmentID, DeviceID, AssignedToType, VehicleID, StationID, AssignmentStart, AssignmentEnd)
        SELECT 
            AssignmentID, 
            DeviceID, 
            AssignedToType, 
            VehicleID, 
            StationID, 
            AssignmentStart, 
            AssignmentEnd
        FROM [Transport].DeviceAssignment
        WHERE DeviceID IS NOT NULL;  -- Cleansing: Ensure DeviceID is non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_DeviceAssignment', SUSER_SNAME(), N'SA_DeviceAssignment', @@ROWCOUNT, 'INFO', N'Finished population of SA_DeviceAssignment table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_DeviceAssignment', SUSER_SNAME(), N'SA_DeviceAssignment', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_PaymentTxn *********************/

CREATE OR ALTER PROCEDURE Fill_SA_PaymentTxn
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_PaymentTxn', SUSER_SNAME(), N'SA_PaymentTxn', NULL, 'INFO', N'Starting population of SA_PaymentTxn table.');

	DECLARE @max_sa_date date, @max_source_date date, @min_source_date date,
			@curr_date date, @end_date date;

	SELECT @max_source_date = CAST(MAX(TxnDT) AS DATE) FROM [Transit].[Transport].PaymentTxn;
	SELECT @min_source_date = CAST(MIN(TxnDT) AS DATE) FROM [Transit].[Transport].PaymentTxn;
	SELECT @max_sa_date     = CAST(MAX(TxnDT) AS DATE) FROM [SA_PaymentTxn];
	SELECT @curr_date      = ISNULL(@max_sa_date, @min_source_date);
	SELECT @end_date	    = @max_source_date;

	WHILE @curr_date <= @end_date
	BEGIN 
		BEGIN TRY
			-- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
			INSERT INTO SA_PaymentTxn (TxnID, PaymentMethodID, CardID, TicketID, StationID, RouteID, DeviceID, TxnDT, FareAmount)
			SELECT 
				TxnID, 
				PaymentMethodID, 
				CardID, 
				TicketID, 
				StationID, 
				RouteID, 
				DeviceID, 
				TxnDT, 
				FareAmount
			FROM [Transport].PaymentTxn
			WHERE 
					CAST(TxnDT AS DATE) = @curr_date 
			  AND
					FareAmount > 0;  -- Cleansing: Ensure TxnDT is not null and FareAmount is positive

			-- Logging Procedure End
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_PaymentTxn', SUSER_SNAME(), N'SA_PaymentTxn', @@ROWCOUNT, 'INFO', N'Finished population of SA_PaymentTxn table.');
		END TRY
		BEGIN CATCH
			-- Logging Error
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_PaymentTxn', SUSER_SNAME(), N'SA_PaymentTxn', NULL, 'ERROR', ERROR_MESSAGE());
			THROW;
		END CATCH
		SET @curr_date = DATEADD(DAY, 1, @curr_date);
	END 

END;
go;
/*********************    Procedure to fill SA_Card *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Card
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Card', SUSER_SNAME(), N'SA_Card', NULL, 'INFO', N'Starting population of SA_Card table.');

	Truncate table SA_Card;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Card (CardID, CardTypeID, CardStatusID, IssueDate, ExpiryDate, CurrentBalance, LastTopUpDT, IsActive)
        SELECT 
            CardID, 
            CardTypeID, 
            CardStatusID, 
            IssueDate, 
            ExpiryDate, 
            CurrentBalance, 
            LastTopUpDT, 
            CASE 
                WHEN IsActive = 1 THEN 'Yes'
                WHEN IsActive = 0 THEN 'No'
                ELSE 'No'
            END AS IsActive  -- Cleansing: Ensure IsActive is only 'Yes' or 'No'
        FROM [Financial].Card
        WHERE CardID IS NOT NULL 
          AND IssueDate IS NOT NULL;  -- Cleansing: Ensure CardID and IssueDate are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Card', SUSER_SNAME(), N'SA_Card', @@ROWCOUNT, 'INFO', N'Finished population of SA_Card table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Card', SUSER_SNAME(), N'SA_Card', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_CardTopUpTxn *********************/

CREATE OR ALTER PROCEDURE Fill_SA_CardTopUpTxn
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_CardTopUpTxn', SUSER_SNAME(), N'SA_CardTopUpTxn', NULL, 'INFO', N'Starting population of SA_CardTopUpTxn table.');

	DECLARE @max_sa_date date, @max_source_date date, @min_source_date date,
		@curr_date date, @end_date date;

	SELECT @max_source_date = CAST(MAX(TopUpDT) AS DATE) FROM [Transit].[Financial].CardTopUpTxn;
	SELECT @min_source_date = CAST(MIN(TopUpDT) AS DATE) FROM [Transit].[Financial].CardTopUpTxn;
	SELECT @max_sa_date     = CAST(MAX(TopUpDT) AS DATE) FROM [SA_CardTopUpTxn];
	SELECT @curr_date      = ISNULL(@max_sa_date, @min_source_date);
	SELECT @end_date	    = @max_source_date;

	WHILE @curr_date <= @end_date
	BEGIN 
		BEGIN TRY
			-- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
			INSERT INTO SA_CardTopUpTxn (TopUpID, CardID, TopUpDT, Amount, StationID, SalesChannelID)
			SELECT 
				TopUpID, 
				CardID, 
				TopUpDT, 
				Amount, 
				StationID,
				SalesChannelID
			FROM [Financial].CardTopUpTxn
			WHERE 
					CardID IS NOT NULL 
			  AND 
					CAST(TopUpDT AS DATE) = @curr_date
			  AND 
					Amount > 0;  -- Cleansing: Ensure CardID, TopUpDT, and Amount are valid

			-- Logging Procedure End
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_CardTopUpTxn', SUSER_SNAME(), N'SA_CardTopUpTxn', @@ROWCOUNT, 'INFO', N'Finished population of SA_CardTopUpTxn table.');
		END TRY
		BEGIN CATCH
			-- Logging Error
			INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
			VALUES (N'Fill_SA_CardTopUpTxn', SUSER_SNAME(), N'SA_CardTopUpTxn', NULL, 'ERROR', ERROR_MESSAGE());
			THROW;
		END CATCH
	SET @curr_date = DATEADD(DAY, 1, @curr_date);
	END

END;
go;
/*********************    Procedure to fill SA_Ticket *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Ticket
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Ticket', SUSER_SNAME(), N'SA_Ticket', NULL, 'INFO', N'Starting population of SA_Ticket table.');

	Truncate table SA_Ticket;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and convert IsActive from BIT to 'Yes'/'No')
        INSERT INTO SA_Ticket (TicketID, IssueDate, ExpiryDate, IsActive)
        SELECT 
            TicketID, 
            IssueDate, 
            ExpiryDate, 
            CASE 
                WHEN IsActive = 1 THEN 'Yes'  -- Converting BIT to 'Yes'
                WHEN IsActive = 0 THEN 'No'   -- Converting BIT to 'No'
                ELSE 'No'                     -- Default to 'No' if value is NULL
            END AS IsActive
        FROM [Financial].Ticket
        WHERE TicketID IS NOT NULL;  -- Cleansing: Ensure TicketID is non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Ticket', SUSER_SNAME(), N'SA_Ticket', @@ROWCOUNT, 'INFO', N'Finished population of SA_Ticket table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Ticket', SUSER_SNAME(), N'SA_Ticket', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_TicketSaleTxn *********************/

CREATE OR ALTER PROCEDURE Fill_SA_TicketSaleTxn
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_TicketSaleTxn', SUSER_SNAME(), N'SA_TicketSaleTxn', NULL, 'INFO', N'Starting population of SA_TicketSaleTxn table.');

	Truncate table SA_TicketSaleTxn;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_TicketSaleTxn (SaleID, TicketID, SaleDT, Amount, StationID, SalesChannelID)
        SELECT 
            SaleID, 
            TicketID, 
            SaleDT, 
            Amount, 
            StationID, 
            SalesChannelID
        FROM [Financial].TicketSaleTxn
        WHERE TicketID IS NOT NULL 
          AND SaleDT IS NOT NULL;  -- Cleansing: Ensure TicketID and SaleDT are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_TicketSaleTxn', SUSER_SNAME(), N'SA_TicketSaleTxn', @@ROWCOUNT, 'INFO', N'Finished population of SA_TicketSaleTxn table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_TicketSaleTxn', SUSER_SNAME(), N'SA_TicketSaleTxn', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_Part *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Part
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Part', SUSER_SNAME(), N'SA_Part', NULL, 'INFO', N'Starting population of SA_Part table.');

	Truncate table SA_Part;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Part (PartID, PartCategoryID, PartName, UnitCostLatest)
        SELECT 
            PartID, 
            PartCategoryID, 
            PartName, 
            UnitCostLatest
        FROM [Maintenance].Part
        WHERE PartID IS NOT NULL 
          AND PartName IS NOT NULL;  -- Cleansing: Ensure PartID and PartName are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Part', SUSER_SNAME(), N'SA_Part', @@ROWCOUNT, 'INFO', N'Finished population of SA_Part table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Part', SUSER_SNAME(), N'SA_Part', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_Supplier *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Supplier
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Supplier', SUSER_SNAME(), N'SA_Supplier', NULL, 'INFO', N'Starting population of SA_Supplier table.');

	Truncate table SA_Supplier;


    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Supplier (SupplierID, SupplierName, ContactPhone, ContactEmail, AddressLine1, AddressLine2, City, PostalCode, Country, Website, TaxID, ContactPerson, CreatedDate)
        SELECT 
            SupplierID, 
            SupplierName, 
            ContactPhone, 
            ContactEmail, 
            AddressLine1, 
            AddressLine2, 
            City, 
            PostalCode, 
            Country, 
            Website, 
            TaxID, 
            ContactPerson, 
            CreatedDate
        FROM [Maintenance].Supplier
        WHERE SupplierID IS NOT NULL 
          AND SupplierName IS NOT NULL;  -- Cleansing: Ensure SupplierID and SupplierName are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Supplier', SUSER_SNAME(), N'SA_Supplier', @@ROWCOUNT, 'INFO', N'Finished population of SA_Supplier table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Supplier', SUSER_SNAME(), N'SA_Supplier', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;
/*********************    Procedure to fill SA_MaintenanceWorkOrder *********************/

CREATE OR ALTER PROCEDURE Fill_SA_MaintenanceWorkOrder
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_MaintenanceWorkOrder', SUSER_SNAME(), N'SA_MaintenanceWorkOrder', NULL, 'INFO', N'Starting population of SA_MaintenanceWorkOrder table.');

	Truncate table SA_MaintenanceWorkOrder;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_MaintenanceWorkOrder (WorkOrderID, VehicleID, MaintenanceTypeID, MechanicEmpID, OpenDT, CloseDT, OdometerAtService, RootCause, LaborHours, TotalCost, WarrantyClaim)
        SELECT 
            WorkOrderID, 
            VehicleID, 
            MaintenanceTypeID, 
            MechanicEmpID, 
            OpenDT, 
            CloseDT, 
            OdometerAtService, 
            RootCause, 
            LaborHours, 
            TotalCost, 
            CASE 
                WHEN WarrantyClaim = '1' THEN 'Yes'
                WHEN WarrantyClaim = '0' THEN 'No'
                ELSE 'No'
            END AS WarrantyClaim
        FROM [Maintenance].MaintenanceWorkOrder
        WHERE WorkOrderID IS NOT NULL 
          AND VehicleID IS NOT NULL;  -- Cleansing: Ensure WorkOrderID and VehicleID are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_MaintenanceWorkOrder', SUSER_SNAME(), N'SA_MaintenanceWorkOrder', @@ROWCOUNT, 'INFO', N'Finished population of SA_MaintenanceWorkOrder table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_MaintenanceWorkOrder', SUSER_SNAME(), N'SA_MaintenanceWorkOrder', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_WorkOrderPartReplacement *********************/

CREATE OR ALTER PROCEDURE Fill_SA_WorkOrderPartReplacement
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_WorkOrderPartReplacement', SUSER_SNAME(), N'SA_WorkOrderPartReplacement', NULL, 'INFO', N'Starting population of SA_WorkOrderPartReplacement table.');

	Truncate table SA_WorkOrderPartReplacement;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_WorkOrderPartReplacement (WorkOrderID, PartID, SupplierID, Quantity, UnitCost)
        SELECT 
            WorkOrderID, 
            PartID, 
            SupplierID, 
            Quantity, 
            UnitCost
        FROM [Maintenance].WorkOrderPartReplacement
        WHERE WorkOrderID IS NOT NULL 
          AND PartID IS NOT NULL;  -- Cleansing: Ensure WorkOrderID and PartID are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_WorkOrderPartReplacement', SUSER_SNAME(), N'SA_WorkOrderPartReplacement', @@ROWCOUNT, 'INFO', N'Finished population of SA_WorkOrderPartReplacement table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_WorkOrderPartReplacement', SUSER_SNAME(), N'SA_WorkOrderPartReplacement', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_FuelingEvent *********************/

CREATE OR ALTER PROCEDURE Fill_SA_FuelingEvent
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_FuelingEvent', SUSER_SNAME(), N'SA_FuelingEvent', NULL, 'INFO', N'Starting population of SA_FuelingEvent table.');

	Truncate table SA_FuelingEvent;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_FuelingEvent (FuelEventID, VehicleID, FuelTypeID, FuelDT, Liters, Cost)
        SELECT 
            FuelEventID, 
            VehicleID, 
            FuelTypeID, 
            FuelDT, 
            Liters, 
            Cost
        FROM [Maintenance].FuelingEvent
        WHERE VehicleID IS NOT NULL 
          AND FuelDT IS NOT NULL;  -- Cleansing: Ensure VehicleID and FuelDT are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_FuelingEvent', SUSER_SNAME(), N'SA_FuelingEvent', @@ROWCOUNT, 'INFO', N'Finished population of SA_FuelingEvent table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_FuelingEvent', SUSER_SNAME(), N'SA_FuelingEvent', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO;
/*********************    Procedure to fill SA_Employee *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Employee
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Employee', SUSER_SNAME(), N'SA_Employee', NULL, 'INFO', N'Starting population of SA_Employee table.');

	Truncate table SA_Employee;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Employee (EmpID, FirstName, LastName, NationalID, DateOfBirth, HireDate, DepartmentID, Email, PhoneNumber, Gender, Address, EmergencyName, EmergencyPhone, BankAccountNo, BaseSalary, CreatedAt, UpdatedAt)
        SELECT 
            EmpID, 
            FirstName, 
            LastName, 
            NationalID, 
            DateOfBirth, 
            HireDate, 
            DepartmentID, 
            Email, 
            PhoneNumber, 
            Gender, 
            Address, 
            EmergencyName, 
            EmergencyPhone, 
            BankAccountNo, 
            BaseSalary, 
            CreatedAt, 
            UpdatedAt
        FROM [HR].Employee
        WHERE EmpID IS NOT NULL 
          AND FirstName IS NOT NULL 
          AND LastName IS NOT NULL;  -- Cleansing: Ensure EmpID, FirstName, and LastName are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Employee', SUSER_SNAME(), N'SA_Employee', @@ROWCOUNT, 'INFO', N'Finished population of SA_Employee table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Employee', SUSER_SNAME(), N'SA_Employee', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_EmployeeRoleHistory *********************/

CREATE OR ALTER PROCEDURE Fill_SA_EmployeeRoleHistory
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_EmployeeRoleHistory', SUSER_SNAME(), N'SA_EmployeeRoleHistory', NULL, 'INFO', N'Starting population of SA_EmployeeRoleHistory table.');

	Truncate table SA_EmployeeRoleHistory;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_EmployeeRoleHistory (EmpID, RoleStartDT, RoleEndDT, RoleID)
        SELECT 
            EmpID, 
            RoleStartDT, 
            RoleEndDT, 
            RoleID
        FROM [HR].EmployeeRoleHistory
        WHERE EmpID IS NOT NULL 
          AND RoleStartDT IS NOT NULL;  -- Cleansing: Ensure EmpID and RoleStartDT are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_EmployeeRoleHistory', SUSER_SNAME(), N'SA_EmployeeRoleHistory', @@ROWCOUNT, 'INFO', N'Finished population of SA_EmployeeRoleHistory table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_EmployeeRoleHistory', SUSER_SNAME(), N'SA_EmployeeRoleHistory', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_Shift *********************/

CREATE OR ALTER PROCEDURE Fill_SA_Shift
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_Shift', SUSER_SNAME(), N'SA_Shift', NULL, 'INFO', N'Starting population of SA_Shift table.');

	Truncate table SA_Shift;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_Shift (ShiftID, EmpID, ShiftTypeID, ShiftStartDT, ShiftEndDT, HoursWorked, OvertimeHrs)
        SELECT 
            ShiftID, 
            EmpID, 
            ShiftTypeID, 
            ShiftStartDT, 
            ShiftEndDT, 
            HoursWorked, 
            OvertimeHrs
        FROM [HR].Shift
        WHERE EmpID IS NOT NULL 
          AND ShiftStartDT IS NOT NULL;  -- Cleansing: Ensure EmpID and ShiftStartDT are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Shift', SUSER_SNAME(), N'SA_Shift', @@ROWCOUNT, 'INFO', N'Finished population of SA_Shift table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_Shift', SUSER_SNAME(), N'SA_Shift', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;

/*********************    Procedure to fill SA_PayrollTxn *********************/

CREATE OR ALTER PROCEDURE Fill_SA_PayrollTxn
AS
BEGIN
    -- Logging Procedure Start
    INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
    VALUES (N'Fill_SA_PayrollTxn', SUSER_SNAME(), N'SA_PayrollTxn', NULL, 'INFO', N'Starting population of SA_PayrollTxn table.');

	Truncate table SA_PayrollTxn;

    BEGIN TRY
        -- Data Transformation/Cleansing (Example: Handle missing fields and ensure non-null values)
        INSERT INTO SA_PayrollTxn (PayrollID, EmpID, PeriodMonth, GrossPay, NetPay, TaxAmt, InsuranceAmt)
        SELECT 
            PayrollID, 
            EmpID, 
            PeriodMonth, 
            GrossPay, 
            NetPay, 
            TaxAmt, 
            InsuranceAmt
        FROM [HR].PayrollTxn
        WHERE EmpID IS NOT NULL 
          AND PeriodMonth IS NOT NULL;  -- Cleansing: Ensure EmpID and PeriodMonth are non-null

        -- Logging Procedure End
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_PayrollTxn', SUSER_SNAME(), N'SA_PayrollTxn', @@ROWCOUNT, 'INFO', N'Finished population of SA_PayrollTxn table.');
    END TRY
    BEGIN CATCH
        -- Logging Error
        INSERT INTO [TransitDW].[Global].[Log] (ProcedureName, ExecutedBy, TableName, RowsAffected, SeverityLevel, Description)
        VALUES (N'Fill_SA_PayrollTxn', SUSER_SNAME(), N'SA_PayrollTxn', NULL, 'ERROR', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
go;