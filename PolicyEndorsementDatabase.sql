   

--Created schema for policy endorsement. 

CREATE SCHEMA [PolicyEn];


/*
Created Customer Table.
*/

CREATE TABLE [PolicyEn].[Customers](
CustId INT CONSTRAINT pk PRIMARY KEY IDENTITY (1000,1),
CustName VARCHAR(50),
CustAddress VARCHAR(50),
CustPhoneNo VARCHAR(50),
CustGender VARCHAR(50),
DOB DATE,
Smoker VARCHAR(50),
Hobbies VARCHAR(50)
)

DROP TABLE [PolicyEn].[Customers];
SELECT * FROM [PolicyEn].[Customers];
ALTER TABLE [PolicyEn].[Customers] ADD Age INT;

/*
Created Product Table.
*/

CREATE TABLE [PolicyEn].[Products](
ProdId INT CONSTRAINT pk_prod PRIMARY KEY IDENTITY (1,1),
ProdName VARCHAR(50),
ProdDescription VARCHAR(50),
ProdCategory VARCHAR(50)
)

INSERT INTO [PolicyEn].[Products] VALUES('Maruti','Best Average','Car');
INSERT INTO [PolicyEn].[Products] VALUES('Mediclaim','For 20 years','Insurance');
SELECT * FROM  [PolicyEn].[Products];

/*
Createsd Policy Table which references to Customer Table and Product Table.
*/

CREATE TABLE [PolicyEn].[Policy]
(
PolicyNumber INT CONSTRAINT pk_pol PRIMARY KEY IDENTITY(100000,1),
CustId INT,
ProdId INT,
FOREIGN KEY(CustId) REFERENCES [PolicyEn].[Customers](CustId),
FOREIGN KEY(ProdId) REFERENCES [PolicyEn].[Products](ProdId)
)
DROP TABLE [PolicyEn].[Policy] 

INSERT INTO  [PolicyEn].[Policy] VALUES (1003,1),(1005,2);
SELECT * FROM  [PolicyEn].[Policy];

/*
Created Login Table which references to Cutsomer.
*/

CREATE TABLE [PolicyEn].[Login]
(
LoginId INT CONSTRAINT pk_Log PRIMARY KEY IDENTITY(1,1),
Passwd VARCHAR(50),
CustId INT,
FOREIGN KEY(CustId) REFERENCES [PolicyEn].[Customers](CustId)
)

DROP TABLE  [PolicyEn].[Login]
INSERT INTO  [PolicyEn].[Login] VALUES ('daverajesh12',1003),('samswati12',1004);

SELECT * FROM  [PolicyEn].[Login];

/*
Created Endorsement Table 
*/
CREATE TABLE  [PolicyEn].[Endorsement]
(
EndmtId INT CONSTRAINT pk_en PRIMARY KEY IDENTITY(1,1),
EndmtType VARCHAR(50),
ExpDate DATE,
PolicyNumber INT,
FOREIGN KEY(PolicyNumber) REFERENCES [PolicyEn].[Policy](PolicyNumber)
)

INSERT INTO  [PolicyEn].[Endorsement] VALUES ('Insurance','2001/04/15',100003)
DROP TABLE [PolicyEn].[Endorsement];

SELECT * FROM  [PolicyEn].[Endorsement];

/*
Created Document Table.
*/

CREATE TABLE [PolicyEn].[Documents]
(
DocId INT IDENTITY (10,1),
DocName VARCHAR(50),
EndmtId INT,
FOREIGN KEY (EndmtId) REFERENCES [PolicyEn].[Endorsement](EndmtId)
)
INSERT INTO [PolicyEn].[Documents] VALUES('CarPolicy',1);
SELECT * FROM  [PolicyEn].[Documents];

/*
Created procedure to insert value in customer table.
*/
CREATE PROCEDURE  [PolicyEn].addCustomers
@cName VARCHAR(50),
@cAdd VARCHAR(50),
@cPno VARCHAR(50),
@cGen VARCHAR(50),
@cDate DATE,
@cSmoker VARCHAR(50),
@cHob VARCHAR(50),
@cNom VARCHAR(50),
@cRel VARCHAR(50),
@cPpf VARCHAR(50)
AS
   INSERT INTO [PolicyEn].[Customers] VALUES(@cName,@cAdd,@cPno,@cGen,@cDate,@cSmoker,@cHob,@cNom,@cRel,@cPpf);

DROP PROC [PolicyEn].addCustomer;

exec [PolicyEn].addCustomer 'Dave','Mumbai','998675464','M','1996/01/20','NS','cricket';
exec [PolicyEn].addCustomer 'Patil','Mumbai','998675488','F','1997/04/15','S','football';
exec [PolicyEn].addCustomer 'Swati','Chennai','998675423','F','1994/08/10','NS','Laughing';
exec [PolicyEn].addCustomers 'Sam','Mumbai','898675426','F','1996/08/10','NS','Chating','Rocky','Brother','Half year';
exec [PolicyEn].addCustomers 'Siddesh','Mumbai','9980675489','M','1996/04/15','NS','Cricket','Sid','Brother','Monthly';
SELECT * FROM [PolicyEn].[Customers];

/*
Created procedure to update the data.
*/

ALTER PROCEDURE [PolicyEn].updatCustomer
@cname VARCHAR(50),
@cdob DATE,
@cgen VARCHAR(50),
@nom VARCHAR(50),
@rel VARCHAR(50),
@csmoke VARCHAR(50),
@cadd VARCHAR(50),
@cphno VARCHAR(50),
@premium VARCHAR(50),
@polno INT
AS

     -- SELECT Age = DATEDIFF(day,@cdob,GETDATE()),
     --[YEARS]  = DATEDIFF(day,@cdob,GETDATE()) / 365,
     --[MONTHS] = (DATEDIFF(day,@cdob,GETDATE()) % 365) / 30,
     -- [DAYS]   = (DATEDIFF(day,@cdob,GETDATE()) % 365) % 30
     -- FROM [PolicyEn].[Customers]
	  UPDATE [PolicyEn].[Customers] SET Age = DATEDIFF(year,@cdob,GETDATE())  FROM [PolicyEn].[Customers] C1 INNER JOIN  [PolicyEn].[Policy] P1 ON (C1.CustId = P1.CustId) WHERE P1.PolicyNumber IN (@polno);
      UPDATE [PolicyEn].[Customers] SET CustName=@cname,Smoker=@csmoke,DOB=@cdob,CustAddress=@cadd,CustPhoneNo=@cphno,CustGender=@cgen,Relation=@rel,Nominee=@nom,Premium_payment_freq=@premium  FROM [PolicyEn].[Customers] C1 INNER JOIN  [PolicyEn].[Policy] P1 ON (C1.CustId = P1.CustId)
	  WHERE P1.PolicyNumber IN (@polno);
	

exec [PolicyEn].updatCustomer 'Samir','1990/08/10','M','Rajesh','Father','NS','Chennai','654789389','Monthly',100004;

/*
Created procedure to delete the data.
*/
--Column Added.
ALTER TABLE [PolicyEn].[Customers] ADD Nominee VARCHAR(50);
ALTER TABLE [PolicyEn].[Customers] ADD Relation VARCHAR(50);
ALTER TABLE [PolicyEn].[Customers] ADD Premium_payment_freq VARCHAR(50);
ALTER TABLE [PolicyEn].[Products] ADD ProductLine VARCHAR(50);

--Procedure to select Policyno,ProductName and Product Description.
ALTER PROCEDURE [PolicyEn].selectDetails
@cid INT
AS
          SELECT p.PolicyNumber,p1.ProdName,p1.ProductLine,c.CustName,c.CustAddress,c.CustPhoneNo,c.CustGender,c.DOB,c.Smoker,c.Hobbies,c.Nominee,c.Relation,c.Premium_payment_freq,c.Age
		  FROM [PolicyEn].[Policy] p INNER JOIN [PolicyEn].[Products] p1 ON (p.ProdId=p1.ProdId)
		  INNER JOIN
		  [PolicyEn].[Customers] c ON (c.CustId=p.CustId) 
		  WHERE c.CustId=@cid

EXEC [PolicyEn].selectDetails 1005;

SELECT * FROM [PolicyEn].[Products];

INSERT INTO [PolicyEn].[Products] VALUES('Home','Villa','House','NonLife');
SELECT * FROM [PolicyEn].[Customers];

