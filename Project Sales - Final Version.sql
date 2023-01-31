--Part 1 of the project: creation of the SALES database

Use master
Go
if exists (select * from sysdatabases where name='Sales')
			drop database Sales
GO

create database Sales
GO
use Sales
Go

--Creation of the 10 tables of the SALES database

create table SalesTerritory
(TerritoryID int not null CONSTRAINT SalesTerritory_TerritoryID_PK PRIMARY KEY,
Name nvarchar(50) not null,
CountryRegionCode nvarchar(3) not null,
[Group] nvarchar(50) not null,
SalesYTD money not null,
SalesLastYear money not null,
CostYTD money not null,
CostLastYear money,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table Customer
(CustomerID int not null CONSTRAINT Customer_CustomerID_PK PRIMARY KEY,
PersonID int,
StoreID int, 
TerritoryID int CONSTRAINT Customer_TerritoryID_FK FOREIGN KEY REFERENCES SalesTerritory(TerritoryID),
AccountNumber nvarchar(50) not null,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table SalesPerson
(BusinessEntityID int not null CONSTRAINT SalesPerso_BusinessIdentityID_PK PRIMARY KEY,
TerritoryID int CONSTRAINT SalesPerson_TerritoryID_FK FOREIGN KEY REFERENCES SalesTerritory(TerritoryID),
SalesQuota money,
Bonus money not null, 
CommissionPct smallmoney not null,
SalesYTD money not null,
SalesLastYear money not null,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table CreditCard
(CreditCardID int not null CONSTRAINT CreditCard_CreditCardID_PK PRIMARY KEY,
CardType nvarchar(50) not null,
CardNumber nvarchar(25) not null, 
ExpMonth tinyint not null,
ExpYear smallint not null,
ModifiedDate datetime not null)
Go

create table CurrencyRate
(CurrencyRateId int not null CONSTRAINT CurrencyRate_CurrencyRateID_PK PRIMARY KEY,
CurrencyRateDate datetime not null,
FromCurrencyCode nchar(3) not null, 
ToCurrencyCode nchar(3) not null,
AverageRate money not null,
EndOfDayRate money not null,
ModifiedDate datetime not null)
Go

create table ShipMethod
(ShipMethodID int not null CONSTRAINT ShipMethod_ShipMethodID_PK PRIMARY KEY,
Name nvarchar(50) not null,
ShipBase money not null,
ShipRate money not null,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table SpecialOfferProduct
(SpecialOfferID int not null,
ProductID int not null,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null,
CONSTRAINT SpecialOfferProduct_PK PRIMARY KEY(SpecialOfferID,ProductID))
Go

create table Address
(AddressID int not null CONSTRAINT Address_AddressID_PK PRIMARY KEY,
AddressLine1 nvarchar(60) not null,
AddressLine2 nvarchar(60),
City nvarchar(30) not null,
StateProvinceID int not null,
PostalCode nvarchar(15) not null, 
SpatialLocation geography,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table SalesOrderHeader
(SalesOrderID int not null CONSTRAINT SalesOrderHeader_SalesOrderID_PK PRIMARY KEY,
RevisionNumber tinyint not null,
OrderDate datetime not null,
DueDate datetime not null,
ShipDate datetime,
Status tinyint not null,
OnlineOrderFlag bit not null,
SalesOrderNumber nvarchar(50) not null,
PurchaseOrderNumber nvarchar(50),
AccountNumber nvarchar(50),
CustomerID int not null CONSTRAINT SalesOrderHeader_CustomerID_FK FOREIGN KEY REFERENCES Customer(CustomerID),
SalesPersonID int CONSTRAINT SalesOrderHeader_SalesPerson_FK FOREIGN KEY REFERENCES SalesPerson(BusinessEntityID), 
TerritoryID int CONSTRAINT SalesOrderHeader_TerritoryID_FK FOREIGN KEY REFERENCES SalesTerritory(TerritoryID),
BillToAddressID int not null CONSTRAINT SalesOrderHeader_BillToAdressID_FK FOREIGN KEY REFERENCES Address(AddressID),
ShipToAddressID int not null CONSTRAINT SalesOrderHeader_ShipToAddressID_FK FOREIGN KEY REFERENCES Address(AddressID),
ShipMethodID int not null CONSTRAINT SalesOrderHeader_ShipMethodID_FK FOREIGN KEY REFERENCES ShipMethod(ShipMethodID),
CreditCardID int CONSTRAINT SalesOrderHeader_CreditCardID_FK FOREIGN KEY REFERENCES CreditCard(CreditCardID),
CreditCardApprovalCode varchar(15),
CurrencyRateID int CONSTRAINT SalesOrderHeader_CurrencyRateID_FK FOREIGN KEY REFERENCES CurrencyRate(CurrencyRateID),
SubTotal money not null,
TaxAmt money not null,
Freight money not null,
TotalDue money not null,
Comment nvarchar(130),
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

create table SalesOrderDetail
(SalesOrderId int not null CONSTRAINT SalesOrderDetail_SalesOrderID_FK FOREIGN KEY REFERENCES SalesOrderHeader(SalesOrderID),
SalesOrderDetailID int not null,
CONSTRAINT SalesOrderDetail_PK PRIMARY KEY(SalesOrderID, SalesOrderDetailID),
CarrierTrackingNumber nvarchar(25), 
OrderQty smallint not null,
ProductID int not null,
SpecialOfferID int not null,
CONSTRAINT SalesOrderDetail_FK FOREIGN KEY (SpecialOfferID,ProductID) REFERENCES SpecialOfferProduct(SpecialOfferID,ProductID),
UnitPrice money not null,
UnitPriceDiscount money not null,
LineTotal money not null,
Rowguid uniqueidentifier not null,
ModifiedDate datetime not null)
Go

--part 2 of the project, insert into 

Insert into SalesTerritory
Select * 
From AdventureWorks2019.Sales.SalesTerritory
Go

Insert into Customer
Select *
From AdventureWorks2019.Sales.Customer
Go

Insert into SalesPerson
Select *
From AdventureWorks2019.Sales.SalesPerson
Go

Insert into CreditCard
Select *
From AdventureWorks2019.Sales.CreditCard
Go

Insert into CurrencyRate
Select *
From AdventureWorks2019.Sales.CurrencyRate
Go

Insert into ShipMethod
Select *
From AdventureWorks2019.Purchasing.ShipMethod
Go

Insert into SpecialOfferProduct
Select *
From AdventureWorks2019.Sales.SpecialOfferProduct
Go

Insert into Address
Select *
From AdventureWorks2019.Person.Address
Go

Insert into SalesOrderHeader
Select *
From AdventureWorks2019.Sales.SalesOrderHeader
Go

Insert into SalesOrderDetail
Select *
From AdventureWorks2019.Sales.SalesOrderDetail
Go 