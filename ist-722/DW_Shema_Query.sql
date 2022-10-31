/*
IST_722 Group 4 Fudgecorp ROLAP for FactSales Business Process
Group members: Andrew Ku, Suihin Wong , Joseph Maugeri
*/
/* Drop table dbo.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactSales 
;

/* Create table dbo.FactSales */
CREATE TABLE dbo.FactSales (
   [product_key]  int default -1  NOT NULL
,  [customer_key]  int default -1  NOT NULL
,  [order_id]  int default -1 not  NULL
,  [DateKey]  int  NOT NULL
,  [plan_price]  money   NULL
,  [order_qty]  int   NULL
,  [sale_retail_price] money    NULL
,  [product_retail_price]  money   NULL
,  [product_wholesale_price]  money   NULL
,  [profit]  money   NULL
,  [Source]  nvarchar(10)   NULL
, CONSTRAINT [PK_dbo.FactSales] PRIMARY KEY NONCLUSTERED 
( [order_id], [product_key] )
) ON [PRIMARY]
;
/*
CREATE TABLE northwind.FactSales (
   [ProductKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [ExtendedPriceAmount]  decimal(25,4)   NOT NULL
,  [DiscountAmount]  decimal(25,4)  DEFAULT 0 NOT NULL
,  [SoldAmount]  decimal(25,4)   NOT NULL
,  [OrderToShippedLagInDays]  smallint   NULL
, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;
*/
/* Drop table dbo.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimDate 
;

/* Create table dbo.DimDate */
CREATE TABLE dbo.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsAWeekday]  varchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_dbo.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO dbo.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk day', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;



/* Drop table dbo.DimCustomer  */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCustomer ') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCustomer  
;

/* Create table dbo.DimCustomer  */
CREATE TABLE dbo.DimCustomer  (
   [customer_key]  int IDENTITY  NOT NULL
,  [customer_id]  int DEFAULT -1 not NULL
,  [account_id]  int DEFAULT -1 not NULL
,  [customer_firstname]  varchar(50)   NOT NULL
,  [customer_lastname]  varchar(50)   NOT NULL
,  [customer_email]  varchar(200)   NOT NULL
,  [customer_address]  varchar(1000)   NOT NULL
,  [customer_zip]  varchar(20)  NOT NULL
,  [Source]  varchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimCustomer ] PRIMARY KEY CLUSTERED 
( [customer_key] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimCustomer  ON
;
INSERT INTO dbo.DimCustomer  (customer_key, customer_id, account_id, customer_firstname, customer_lastname, customer_email, customer_address, customer_zip, Source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, 'None', 'None', 'None', 'None', 'None', 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimCustomer  OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[dbo].[DimCustomer]'))
DROP VIEW [dbo].[DimCustomerView]
GO

/* Drop table dbo.DimItems */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimItems') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimItems 
;

/* Create table dbo.DimItems */
CREATE TABLE dbo.DimItems (
   [product_key]  int identity NOT NULL
,  [product_id]  int  DEFAULT -1 NOT NULL
,  [product_department]  varchar(20)   NULL
,  [item_name]  varchar(50)   NOT NULL
,  [plan_id]  int DEFAULT -1  NOT NULL  
,  [Source]  nvarchar(10)  DEFAULT -1 NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimItems] PRIMARY KEY CLUSTERED 
( [product_key] )
) ON [PRIMARY]
;
/*
CREATE TABLE northwind.FactSales (
   [ProductKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [ExtendedPriceAmount]  decimal(25,4)   NOT NULL
,  [DiscountAmount]  decimal(25,4)  DEFAULT 0 NOT NULL
,  [SoldAmount]  decimal(25,4)   NOT NULL
,  [OrderToShippedLagInDays]  smallint   NULL
, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;
*/

SET IDENTITY_INSERT dbo.DimItems ON
;
INSERT INTO dbo.DimItems (product_key, product_id, product_department, item_name, plan_id, Source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', -1, 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimItems OFF
;

ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_product_key FOREIGN KEY
   (
   product_key
   ) REFERENCES DimItems
   ( product_key )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_DateKey FOREIGN KEY
   (
   DateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_customer_Key FOREIGN KEY
   (
   customer_Key
   ) REFERENCES DimCustomer
   ( customer_key )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

;