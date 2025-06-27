/*===============================================================================
  0) CREATE SCHEMAS
  -----------------------------------------------------------------------------

===============================================================================*/



/* 3. Financial -----------------------------------------------*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Financial')
    EXEC (N'CREATE SCHEMA [Financial]');
GO



 -- Step 1: Drop all foreign key constraints referencing Financial tables
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] 
DROP CONSTRAINT [' + name + '];'
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('Financial.TicketSaleTxn'),
    OBJECT_ID('Financial.Ticket'),
    OBJECT_ID('Financial.CardTopUpTxn'),
    OBJECT_ID('Financial.Card')
);

EXEC sp_executesql @sql;

-- Step 2: Drop the Financial tables if they exist (drop children first)
IF OBJECT_ID(N'Financial.TicketSaleTxn', N'U') IS NOT NULL
    DROP TABLE Financial.TicketSaleTxn;

IF OBJECT_ID(N'Financial.Ticket', N'U') IS NOT NULL
    DROP TABLE Financial.Ticket;

IF OBJECT_ID(N'Financial.CardTopUpTxn', N'U') IS NOT NULL
    DROP TABLE Financial.CardTopUpTxn;

IF OBJECT_ID(N'Financial.Card', N'U') IS NOT NULL
    DROP TABLE Financial.Card;



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
CREATE TABLE [Financial].[Card] (
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
CREATE TABLE [Financial].TicketSaleTxn (
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
CREATE INDEX IX_TicketSale_Time ON [Financial].TicketSaleTxn (SaleDT);




