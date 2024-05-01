-- A4_Team07.sql
-- Winter 2023 Assignment 4
-- Revision History:
-- Rutvik Gandhi, Section 3, 2023.04.09: Created
-- Ricky Satyam, Section 3, 2023.04.09: Updated
-- Pubudu Gunasekara, Section 3, 2023.04.09: Updated
-- Aditya Mandani, Section 3, 2023.04.09: Updated
-- Dhruvil , Section 3, 2023.04.09: Updated

PRINT 'W23 PROG8080 Section 3';
PRINT 'Assignment 4';
PRINT '';
PRINT 'Rutvik Gandhi';
PRINT 'Ricky Satyam';
PRINT 'Pubudu Gunasekara';
PRINT 'Aditya Mandani';
PRINT 'Dhruvil';
PRINT '';
PRINT GETDATE();
PRINT '';

USE master;

GO

-- Question 1
PRINT '*** Question 1 ***';
PRINT '';

PRINT '>>> CHECKING IF SWC_TEAM07 EXISTS';

IF EXISTS (SELECT "name" FROM Sysdatabases WHERE "name" = 'SWC_TEAM07')
	BEGIN
		PRINT '>>> SWC_TEAM07 EXISTS';

		PRINT '>>> ROLLING BACK PENDING SWC_TEAM07 TRANSACTIONS';
		ALTER DATABASE SWC_TEAM07
			SET SINGLE_USER
			WITH ROLLBACK IMMEDIATE;

		PRINT '>>> DROPING SWC_TEAM07';
		DROP DATABASE SWC_TEAM07;
	END
ELSE
	BEGIN
		PRINT '>>> SWC_TEAM07 DOES NOT EXIST';
	END
GO

PRINT '>>> CREATING A NEW SWC_TEAM07 DATABASE';

CREATE DATABASE SWC_TEAM07;
GO

USE SWC_TEAM07;
GO

-- Question 2, 3, 4, 5, 6, 7 
PRINT '*** Question 2, 3, 4, 5, 6, 7 ***';
PRINT '';

PRINT '>>> CREATING Supplier TABLE';

DROP TABLE IF EXISTS Supplier;

CREATE TABLE Supplier
(
	id BIGINT IDENTITY NOT NULL,
	name NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_Supplier
		PRIMARY KEY (id)
);
GO

PRINT '>>> CREATING Part TABLE';

DROP TABLE IF EXISTS Part;

CREATE TABLE Part
(
	id BIGINT IDENTITY NOT NULL,
	number NVARCHAR(30) NOT NULL,
	type NVARCHAR(30) NOT NULL,
	description NVARCHAR(60) NOT NULL,
	supplierId BIGINT NOT NULL,
	unitPrice MONEY NOT NULL,

	CONSTRAINT PK_Part
		PRIMARY KEY (id),

	CONSTRAINT FK_Part_SupplierId
		FOREIGN KEY (supplierId)
		REFERENCES Supplier(id),

	CONSTRAINT CK_Part_UnitPrice
		CHECK (unitPrice > 0)
);

GO

PRINT '>>> CREATING Bundle TABLE';

DROP TABLE IF EXISTS Bundle;

CREATE TABLE Bundle 
(
	id BIGINT IDENTITY NOT NULL,
	name NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_Bundle
		PRIMARY KEY (id),

	CONSTRAINT CK_Bundle_Name
		CHECK (LEN(name) >= 3)
);

GO

PRINT '>>> CREATING BundlePartLinkingTable TABLE';

DROP TABLE IF EXISTS BundlePartLinkingTable;

CREATE TABLE BundlePartLinkingTable 
(
	bundleId BIGINT NOT NULL,
	partId BIGINT NOT NULL,

	CONSTRAINT FK_BundlePartLinkingTable_BundleId
		FOREIGN KEY (bundleId)
		REFERENCES Bundle(id),

	CONSTRAINT FK_BundlePartLinkingTable_PartId
		FOREIGN KEY (partId)
		REFERENCES Part(id),
);

GO

PRINT '>>> CREATING Address TABLE';

DROP TABLE IF EXISTS AddressTable;

CREATE TABLE AddressTable
(
	id BIGINT IDENTITY NOT NULL,
	streetNumber BIGINT,
	streetName NVARCHAR(60) NOT NULL,
	city NVARCHAR(60) NOT NULL,
	province NVARCHAR(30) NOT NULL,
	country NVARCHAR(30) NOT NULL
	CONSTRAINT DF_Address_Country
		DEFAULT 'Canada',
	postalCode NVARCHAR(30) NOT NULL,

	CONSTRAINT PK_Address
		PRIMARY KEY (id),

	CONSTRAINT CK_Address_StreetName
		CHECK (LEN(streetName) >= 3),

	
);

GO

PRINT '>>> CREATING Purchaser TABLE';

DROP TABLE IF EXISTS Purchaser;

CREATE TABLE Purchaser
(
	id BIGINT IDENTITY NOT NULL,
	firstName NVARCHAR(60) NOT NULL,
	lastName NVARCHAR(60) NOT NULL,
	email NVARCHAR(60) NOT NULL,
	phone BIGINT NOT NULL,
	addressId BIGINT NOT NULL,

	CONSTRAINT PK_Purchaser
		PRIMARY KEY (id),

	CONSTRAINT FK_Purchaser_AddressId
		FOREIGN KEY (addressId)
		REFERENCES AddressTable(id),

	CONSTRAINT CK_Purchaser_FirstName
		CHECK (LEN(firstName) >= 3)
);

GO

PRINT '>>> CREATING OrderHistory TABLE';

DROP TABLE IF EXISTS OrderHistory;

CREATE TABLE OrderHistory
(
	id BIGINT IDENTITY NOT NULL,
	partId BIGINT NOT NULL,
	purchaserId BIGINT NOT NULL,
	purchaseDate Date NOT NULL,
	quantity BIGINT NOT NULL,

	CONSTRAINT PK_Order
		PRIMARY KEY (id),

	CONSTRAINT FK_Order_PartId
		FOREIGN KEY (partId)
		REFERENCES Part(id),

	CONSTRAINT FK_Order_PurchaserId
		FOREIGN KEY (purchaserId)
		REFERENCES Purchaser(id),

	CONSTRAINT CK_Order_Quantity
		CHECK (quantity > 0)
);

GO

-- Question 6
PRINT '*** Question 6 ***';
PRINT '';

PRINT '>>> List all the table names and their constraint names (PK, FK, CK) created.';

SELECT 
	LEFT( TABLE_NAME, 20 ) AS "Table Name"
	,LEFT( CONSTRAINT_NAME, 50 ) AS "Constraint Name"
FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE;

-- Question 7
PRINT '*** Question 7 ***';
PRINT '';

PRINT '>>> List the default constraint name and its definition.';
SELECT 
	LEFT( name, 20 ) AS "Default Name"
	, definition
FROM sys.default_constraints;

-- Question 8
PRINT '*** Question 8 ***';
PRINT '';

PRINT '>>> Insert all available data into the tables.';

INSERT INTO Supplier
	(name)
VALUES
	('Dell'),
	('HP'),
	('Samsung'),
	('Lenovo'),
	('Max')
;

--SELECT * FROM Supplier

INSERT INTO Part
	(number, type, description, supplierId, unitPrice)
VALUES
	('DL1010', 'Desktop', 'Dell Optiplex 1010', 1, '40'),
	('DL5040', 'Desktop', 'Dell Optiplex 5040', 1, '150'),
	('DLM190', 'Monitor', 'Dell 19-inch Monitor', 1, '35'),
	('HP400', 'Desktop', 'HP Desktop Tower', 2, '60'),
	('HP800', 'Desktop', 'HP EliteDesk 800G1', 2, '200'),
	('HPM270', 'Monitor', 'HP 27-inch Monitor', 2, '120'),
	('SM330', 'Tablet', 'Samsung Galaxy Tab 7” Android Tablet', 3, '110'),
	('LEN101', 'Keyboard', 'Lenovo 101-Key Computer Keyboard', 4, '7'),
	('LEN102', 'Mouse', 'Lenovo Mouse', 4, '5'),
	('DLM240', 'Monitor', 'Dell 24-inch Monitor', 1, '80'),
	('HPM220', 'Monitor', 'HP 22-inch Monitor', 2, '45'),
	('MAX901', 'Camera', 'Max Web Camera', 5, '20'),
	('HP501', 'Keyboard', 'HP 101-Key Computer Keyboard', 2, '9'),
	('HP502', 'Mouse', 'HP Mouse', 2, '6')
;

--SELECT * FROM Part

INSERT INTO Bundle
	(name)
VALUES
	('Dell Eco'),
	('Dell Biz'),
	('HP Eco'),
	('HP Biz')
;

--SELECT * FROM Bundle

INSERT INTO BundlePartLinkingTable
	(bundleId, partId)
VALUES
	(1, 1),
	(2, 2),
	(1, 3),
	(3, 4),
	(4, 5),
	(4, 6),
	(1, 8),
	(2, 8),
	(1, 9),
	(2, 9),
	(2, 10),
	(3, 11),
	(4, 12),
	(3, 13),
	(4, 13),
	(3, 14),
	(4, 14)
;

--SELECT * FROM BundlePartLinkingTable

INSERT INTO AddressTable
	(streetNumber, streetName, city, province, country, postalCode)
VALUES
	(108, 'University Ave', 'Waterloo', 'Ontario', 'Canada', 'N2J 2W2'),
	(109, 'University Ave', 'Waterloo', 'Ontario', 'Canada', 'N2J 2W3'),
	(110, 'University Ave', 'Waterloo', 'Ontario', 'Canada', 'N2J 2W4'),
	(111, 'University Ave', 'Waterloo', 'Ontario', 'Canada', 'N2J 2W5')
;

--SELECT * FROM AddressTable

INSERT INTO Purchaser
	(firstName, lastName, email, phone, addressId)
VALUES
	('Joey', 'Allen', 'jAllen@friends.com', 1231231234, 1),
	('May', 'John', 'mJohn@runner.com', 2342342345, 2),
	('Troy', 'Donahue', 'tDonahue@film.com', 3453453456, 3),
	('Vinh', 'Khan', 'vKhan@singer.com', 4564564567, 4)
;

--SELECT * FROM Purchaser

INSERT INTO OrderHistory
	(partId, purchaserId, purchaseDate, quantity)
VALUES
	(1, 1, '2022-10-31', 25),
	(2, 1, '2022-10-31', 50),
	(3, 1, '2022-10-31', 25),
	(4, 2, '2022-11-10', 15),
	(5, 2, '2022-11-20', 20),
	(6, 2, '2022-11-20', 20),
	(7, 3, '2022-11-30', 10),
	(8, 4, '2022-12-05', 50),
	(9, 4, '2022-12-05', 50),
	(10, 4, '2022-12-05', 80),
	(11, 1, '2022-12-10', 30),
	(9, 4, '2022-12-15', 100),
	(12, 4, '2022-12-15', 40),
	(13, 3, '2022-12-20', 100),
	(14, 3, '2022-12-20', 100)
;

--SELECT * FROM OrderHistory

-- Question 9
PRINT '*** Question 9 ***';
PRINT '';

PRINT '>>> Create a table index for the purchaser’s phone.';

CREATE INDEX IX_Phone ON Purchaser (phone);
GO

PRINT '>>> Create a unique index for the purchaser’s email.';

CREATE UNIQUE INDEX UX_Email ON Purchaser (email);
GO

-- Question 10
PRINT '*** Question 10 ***';
PRINT '';

GO

DROP VIEW IF EXISTS VW_PurchaseDetailPlusExtendedAmount

GO

CREATE VIEW VW_PurchaseDetailPlusExtendedAmount
AS
SELECT p.number AS "Part Number"
	, s.name AS "Supplier"
	, p.type AS "Part Type"
	, p.description AS "Part Description"
	, pchr.firstName AS Purchaser
	, oh.purchaseDate AS "Purchase Date"
	, p.unitPrice AS "Unit Price"
	, oh.quantity AS "Qty"
	, p.unitPrice * oh.quantity AS "Extended Amount"
FROM OrderHistory oh
	INNER JOIN Part p ON oh.partId = p.id
	INNER JOIN Supplier s ON s.id = p.supplierId
	INNER JOIN Purchaser pchr ON pchr.id = oh.purchaserId
GO

PRINT '>>> Display all the purchase details with “Extended Amount”.';

SELECT * 
FROM VW_PurchaseDetailPlusExtendedAmount
ORDER BY Purchaser, "Purchase Date", "Part Number";

-- Question 11
PRINT '*** Question 11 ***';
PRINT '';

GO

DROP VIEW IF EXISTS VW_BundleCost

GO

CREATE VIEW VW_BundleCost
AS
SELECT Bundle
	, "Total Cost"
FROM (
	SELECT b.name AS Bundle, SUM(p.unitPrice) AS "Total Cost"
	FROM BundlePartLinkingTable bp
		INNER JOIN Bundle b ON b.id = bp.bundleId
		INNER JOIN Part p ON p.id = bp.partId
	GROUP BY b.name
) AS DT
GO

PRINT '>>> Display the desktop bundles along with their total costs.';

SELECT * 
FROM VW_BundleCost
ORDER BY Bundle;

PRINT '>>> List all the view names created.';

SELECT TABLE_NAME AS "View Name"
FROM INFORMATION_SCHEMA.VIEWS;