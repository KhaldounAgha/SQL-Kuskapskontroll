USE [AdventureWorks2022]
GO
----------------------------
 -- DONE --
----------------------------
-- 00100 -- Totalt antal produkter

SELECT COUNT(*) AS [Totalt Antal Produkter]
FROM [AdventureWorks2022].[Production].[Product];

-- 00110 -- Totalt F�rs�ljnings Belopp
SELECT CAST(SUM([TotalDue]) AS int) AS [Totalt F�rs�ljnings Belopp]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

-- 00120 -- Totalt F�rs�ljnings Belopp
SELECT CAST(AVG([TotalDue]) AS decimal(10,2)) AS [Genomsnittligt Orderv�rde]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

-- 00130 -- Totalt Spenderat Belopp
SELECT TOP 10 [CustomerID], CAST(SUM([TotalDue]) AS int) AS [Totalt Spenderat Belopp]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY [CustomerID] ORDER BY [Totalt Spenderat Belopp] DESC;

-- 00140 -- F�retagets personal 
SELECT COUNT([JobTitle]), [JobTitle]  
FROM [AdventureWorks2022].[humanresources].[employee]
GROUP BY [JobTitle]
ORDER BY [JobTitle];

-- 00150 -- Antal och Kategorier av Personer i F�retaget
SELECT COUNT([PersonType]) AS [Antal], 
	CASE
		WHEN [persontype] = 'SC' THEN 'Store Contact'
		WHEN [persontype] = 'IN' THEN 'Individual (retail) customer'
		WHEN [persontype] = 'SP' THEN 'Sales person'
		WHEN [persontype] = 'EM' THEN 'Employee (non-sales)'
		WHEN [persontype] = 'VC' THEN 'Vendor contact'
		WHEN [persontype] = 'GC' THEN 'General contact'
	END AS [Kategori]
FROM [AdventureWorks2022].[Person].[Person]
GROUP BY [persontype];


-- 00160 -- Avdelningar och antal anst�llda
SELECT 
	A.[Name] AS [Avdelning], 
	COUNT(*) AS [Antal Anst�llda]
FROM [AdventureWorks2022].[HumanResources].[Department] AS A
JOIN [AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] AS B 
ON A.[DepartmentID] = B.[DepartmentID]
GROUP BY A.[Name];

-- 00170 -- F�rs�ljning per produktkategori
SELECT 
	E.[Name] AS [Produktkategori],
	CAST(SUM(B.[LineTotal]) AS INT) AS [Total delsumma]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderDetail] AS B 
	LEFT JOIN Production.Product AS C ON B.[ProductID] = C.[ProductID]
	JOIN Production.ProductSubcategory AS D ON C.[ProductSubcategoryID] = D.[ProductSubcategoryID]
	JOIN Production.ProductCategory AS E ON D.[ProductCategoryID] = E.[ProductCategoryID]
GROUP BY 
	E.[Name];

----------------------------
 -- DONE --
----------------------------
-- 00200 -- Totalt antal kunder

SELECT 
	COUNT(DISTINCT [CustomerID]) AS [Totalt Antal Kunder]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader];

----------------------------
 -- DONE --
----------------------------
-- 00300 -- Kundf�rdelning per Land

SELECT 
	T.[CountryRegionCode] AS [Land],
	COUNT(DISTINCT S.[CustomerID]) AS [Antal kunder]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] AS S
    LEFT OUTER JOIN [AdventureWorks2022].[Sales].[SalesTerritory] AS T
    ON S.[TerritoryID] = T.[TerritoryID]
GROUP BY 
    T.[CountryRegionCode]
ORDER BY 
	[Land];

----------------------------
 -- DONE --
----------------------------
-- 00400 -- Totalt antal best�llningar 
SELECT 
	COUNT([SalesOrderID]) AS [Totalt Antal Best�llningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader];

----------------------------
 -- DONE --
----------------------------
-- 00500 -- Antal best�llningar per �r

SELECT 
	YEAR([OrderDate]) AS [�r],
	COUNT([SalesOrderID]) AS [Antal Best�llningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR([OrderDate])
ORDER BY 
	YEAR([OrderDate]);

----------------------------
 -- DONE --
----------------------------
-- 00600 -- Antal best�llningar per kvartal

SELECT 
    YEAR([OrderDate]) AS [�r],
    DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
    COUNT([SalesOrderID]) AS [Antal Best�llningar]
FROM
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
ORDER BY 
    [�r], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 00700 -- Antal best�llningar per m�nad

SELECT 
	YEAR([OrderDate]) AS [�r],
	MONTH([OrderDate]) AS [M�nad],
	COUNT(SalesOrderID) AS [Ordrar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
	YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
	[�r], [M�nad] ASC;

----------------------------
 -- DONE --
----------------------------
-- 00800 -- Antal best�llningar per land

SELECT 
	T.[CountryRegionCode] AS [Land],
	COUNT(S.[CustomerID]) AS [Antal Best�llningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] AS S
    LEFT OUTER JOIN [Sales].[SalesTerritory] AS T
    ON S.[TerritoryID] = T.[TerritoryID]
GROUP BY 
    T.[CountryRegionCode]
ORDER BY 
	[Land];

----------------------------
 -- DONE --
----------------------------
-- 00900 -- Antal best�llningar per land och �r  

SELECT 
	YEAR(S.[OrderDate]) AS [�r],
	T.[CountryRegionCode] AS [Land],
	COUNT(S.[CustomerID]) AS [Antal Best�llningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] AS S
    LEFT OUTER JOIN [Sales].[SalesTerritory] AS T
    ON S.[TerritoryID] = T.[TerritoryID]
GROUP BY 
    YEAR(S.[OrderDate]), T.[CountryRegionCode]
ORDER BY 
	[�r], [Land];

----------------------------
 -- DONE --
----------------------------
-- 01000 --F�rdelning av antal best�llningar per kund

WITH [CTE_AntalBest�llningarPerKund] AS 
	(
		SELECT 
			COUNT([SalesOrderID]) AS [AntalBest�llningarPerKund]
		FROM 
			[AdventureWorks2022].[Sales].[SalesOrderHeader]
		GROUP BY 
			[CustomerID]
	)

SELECT 
	[AntalBest�llningarPerKund] AS [Antal best�llningar per kund],
	COUNT([AntalBest�llningarPerKund]) AS [Antal kunder]
FROM 
	[CTE_AntalBest�llningarPerKund]
GROUP BY
	[AntalBest�llningarPerKund]
ORDER BY 
	[AntalBest�llningarPerKund] DESC;

----------------------------
 -- DONE --
----------------------------
-- 02000 -- �rlig f�rs�ljningssammanfattning

WITH [CTE_�rTotal] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [OrderDate], 
        COUNT([SalesOrderID]) AS [TotaltAntalBest�llningar],
        SUM([SubTotal]) AS [DelSumma],
        SUM([TaxAmt]) AS [Skatt],
        SUM([Freight]) AS [Frakt],
        SUM([TotalDue]) AS [TotaltBelopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate])
	)

SELECT 
    [OrderDate] AS [�r], 
    [TotaltAntalBest�llningar] AS [Antal Best�llningar],
    CAST(ROUND([DelSumma], 0) AS int) AS [Del Summa], 
    [Procentandel DelSumma] = CAST(ROUND([DelSumma] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([Skatt], 0) AS int) AS [Skatt Belopp], 
    [Procentandel Skatt] = CAST(ROUND([Skatt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([Frakt], 0) AS int) AS [Frakt],
    [Procentandel Frakt] = CAST(ROUND([Frakt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([TotaltBelopp], 0) AS int) AS [Totalt Belopp]
FROM 
    [CTE_�rTotal] 
ORDER BY 
    [OrderDate] ASC;
----------------------------
 -- DONE --
----------------------------
-- 03000 -- F�rs�ljning per kvartal

WITH [CTE_�rTotal] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [OrderDate], 
        DATEPART(QUARTER, [OrderDate]) AS [Quarter],
        COUNT([SalesOrderID]) AS [TotaltAntalBest�llningar],
        SUM([SubTotal]) AS [DelSumma],
        SUM([TaxAmt]) AS [Skatt],
        SUM([Freight]) AS [Frakt],
        SUM([TotalDue]) AS [TotaltBelopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
	)

SELECT 
    [OrderDate] AS [�r], 
    [Quarter] AS [Kvartal],
    [TotaltAntalBest�llningar] AS [Antal Best�llningar],

    CAST(ROUND([DelSumma], 0) AS int) AS [Del Summa], 
    [Procentandel DelSumma] = CAST(ROUND([DelSumma] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([Skatt], 0) AS int) AS [Skatt Belopp], 
    [Procentandel Skatt] = CAST(ROUND([Skatt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([Frakt], 0) AS int) AS [Frakt],
    [Procentandel Frakt] = CAST(ROUND([Frakt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([TotaltBelopp], 0) AS int) AS [Totalt Belopp]
FROM 
    [CTE_�rTotal] 
ORDER BY 
    [OrderDate], [Quarter] ASC;

----------------------------
 -- DONE --
----------------------------
-- 04000 -- F�rs�ljning per m�nad 

WITH [CTE_OrderTotalMonth] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [�r],
		MONTH([OrderDate]) AS [M�nad],
		COUNT(SalesOrderID) AS [Antal best�llningar],
        SUM([TotalDue]) AS [Totalt belopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate]), MONTH([OrderDate])
	)

SELECT 
    [�r], 
	[M�nad],
	[Antal best�llningar],
    CAST([Totalt belopp] AS int) AS [Totalt belopp]
FROM 
	[CTE_OrderTotalMonth]
ORDER BY
	[�r] ASC, [M�nad] ASC;

----------------------------
 -- DONE --
----------------------------
-- 05000 -- M�natlig MAX och MIN Totalt belopp

WITH [CTE_MinMaxOrder] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [�r],
		MONTH([OrderDate]) AS [M�nad],
		COUNT(SalesOrderID) AS [Antal ordrar],
        SUM([TotalDue]) AS [Totalt belopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate]), MONTH([OrderDate])
	)

SELECT 
	[�r], 
	[M�nad], 
	[Antal ordrar], 
	CAST([Totalt belopp] AS INT) AS [Max/Min Totalt belopp]
FROM 
	[CTE_MinMaxOrder] 
WHERE 
	[Totalt belopp] = (SELECT MAX([Totalt belopp]) FROM [CTE_MinMaxOrder]) 
	OR 
	[Totalt belopp] = (SELECT MIN([Totalt belopp]) FROM [CTE_MinMaxOrder])
ORDER BY
	[Totalt belopp] DESC;

----------------------------
 -- DONE --
----------------------------
-- 06000 --  Medelv�rdert f�r best�llningar och totalt belopp, m�nadsvis

SELECT 
    YEAR([OrderDate]) AS [�r],
	MONTH([OrderDate]) AS [M�nad],
	COUNT(SalesOrderID) AS [Antal best�llningar],
    CAST(SUM([TotalDue]) AS INT) AS [Totalt belopp],
	CAST(AVG([TotalDue]) AS INT) AS [Medelv�rde]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
	YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
	[Medelv�rde];

----------------------------
 -- DONE --
----------------------------
-- 06110 -- Medelv�rdet f�r alla f�rs�ljningsordrar i f�retaget

SELECT CAST(AVG([TotalDue]) AS INT) AS [Totalt Medelv�rde]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

----------------------------
 -- DONE --
----------------------------
-- 07000 -- Kvartalsvis f�rdelning av online best�llningar och best�llningar av s�ljare

WITH [CTE_OnlineOrderSP] AS
	(
	SELECT 
		YEAR([OrderDate]) AS [�r],
		DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
		SUM(CASE WHEN [OnlineOrderFlag] = 1 THEN 1 ELSE 0 END) AS [OnlineBest�llningar],
		SUM(CASE WHEN [OnlineOrderFlag] = 0 THEN 1 ELSE 0 END) AS [Best�llningar Av S�ljare],
		COUNT(*) AS [N�mnare]
	FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
	GROUP BY 
		YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
	)

SELECT 
	[�r],
	[Kvartal],
	[OnlineBest�llningar] AS [Online Best�llningar],
	[Best�llningar Av S�ljare] AS [Best�llningar Av S�ljare],
	CAST(100.0 * [OnlineBest�llningar] / [N�mnare] AS decimal(3, 1)) AS [Andel: Online Best�llning],
	CAST(100.0 * [Best�llningar Av S�ljare] / [N�mnare] AS decimal(3, 1)) AS [Andel: Best�llningar genom s�ljare]
FROM
	[CTE_OnlineOrderSP]
ORDER BY 
	[�r], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 08000 -- F�rs�ljningsstatistik per Kvartal - Medelv�rde och Standardavvikelse

SELECT 
	YEAR([OrderDate]) AS [�r], 
	DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
	CAST(AVG([TotalDue]) AS int) AS [Genomsnitt Totalt belopp)],
	CAST(STDEV([TotalDue]) AS int) AS [Standardavvikelse Totalt belopp]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] 
GROUP BY  
	YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
ORDER BY 
	[�r], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 09000 -- Median (50:e percentilen) av totalt belopp

SELECT  DISTINCT
		PERCENTILE_CONT(0.5) 
		WITHIN GROUP (ORDER BY [TotalDue]) 
		OVER (PARTITION BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate]))
		AS [Median Totalt belopp], 
		YEAR([OrderDate]) AS [�r], 
		DATEPART(QUARTER, [OrderDate]) AS [Kvartal]
FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
ORDER BY 
		[�r], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 01110 -- Antal best�llningar och det totala f�rs�ljningsbeloppet per land f�r varje s�ljare

SELECT 
	A.[SalesPersonID], 
	C.[FirstName], 
	C.[LastName], 
	D.[CountryRegionCode] AS [Land], 
	COUNT(A.[SalesPersonID]) AS [Antal Best�llningar], 
	CAST(SUM(A.TotalDue) AS int) AS [Total F�rs�ljning]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] AS A
	INNER JOIN [AdventureWorks2022].[Sales].[SalesPerson] AS B
	ON A.[SalesPersonID] = B.[BusinessEntityID]
	INNER JOIN [AdventureWorks2022].[Person].[Person] AS C
	ON B.[BusinessEntityID] = C.[BusinessEntityID]
	LEFT JOIN [AdventureWorks2022].[Sales].[SalesTerritory] AS D
	ON B.[TerritoryID] = D.[TerritoryID]
GROUP BY 
	A.[SalesPersonID], C.[FirstName], C.[LastName], D.[CountryRegionCode]
HAVING 
	A.[SalesPersonID] IS NOT NULL
ORDER BY 
	[Total F�rs�ljning];

----------------------------
 -- DONE --
----------------------------
-- 01120 -- Statistisk analys (konfidensintervall), Totalt

WITH [CTE_konfidensintervall] AS 
	(
	SELECT 
		COUNT([TotalDue]) AS [n],
		CAST(AVG([TotalDue]) AS int) AS [Medelv�rde],
		CAST(STDEV([TotalDue]) AS int) AS [Standardavvikelse]
	FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
	) 

SELECT 
	[Medelv�rde], 
	[Standardavvikelse],
	CAST(([Medelv�rde]) - (1.96 * [Standardavvikelse] / SQRT(n)) AS INT) AS [KI_Nedre],
    CAST(([Medelv�rde]) + (1.96 * [Standardavvikelse] / SQRT(n)) AS INT) AS [KI_�vre]
FROM 
	[CTE_konfidensintervall];


----------------------------
 -- DONE --
----------------------------
-- 01121 -- Statistisk analys (Median), Totalt

WITH [CTE_Median] AS 
	(
    SELECT TOP 50 PERCENT CAST([TotalDue] AS INT) AS [Median]
    FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
    ORDER BY [TotalDue] ASC
	)
SELECT TOP 1 [Median]
FROM CTE_Median ORDER BY [Median] DESC;

----------------------------
 -- DONE --
----------------------------
-- 01122 -- Statistisk analys (konfidensintervall), M�nadsvist

SELECT 
    YEAR([OrderDate]) AS [�r], 
	MONTH([OrderDate]) AS [M�nad], 
	COUNT([SalesOrderID]) AS [Antal best�llningar],
    CAST(AVG([TotalDue]) AS INT) AS [Medelv�rde Totalt belopp],
    CAST(STDEV([TotalDue]) AS INT) AS [Standardavvikelse Totalt belopp],
    CAST((AVG([TotalDue]) - 1.96 * STDEV([TotalDue]) / SQRT(COUNT([TotalDue]))) AS INT) AS [KI_Nedre],
    CAST((AVG([TotalDue]) + 1.96 * STDEV([TotalDue]) / SQRT(COUNT([TotalDue]))) AS INT) AS [KI_�vre]
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader] 
GROUP BY  
    YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
    [�r], [M�nad];


----------------------------
 -- DONE --
----------------------------
-- 01133 -- En funktion f�r att ber�kna konfidensintervall f�r skillnaden mellan medelv�rden f�r tv� angivna �r i tabellen: [AdventureWorks2022].[Sales].[SalesOrderHeader].
GO
CREATE FUNCTION dbo.SkillnadMedelv�rde (@�r1 INT, @�r2 INT) 
RETURNS @SkillnadsIntervall TABLE (Skillnad�vre INT, SkillnadNedre INT)
AS
BEGIN
    DECLARE @Skillnad�vre INT;
    DECLARE @SkillnadNedre INT;

    SELECT @Skillnad�vre = 
        ( -- (Medelv�rde1 - Medelv�rde2) +  z. sqrt [(standardavvickelse1)^2/n1 + (standardavvickelse2)^2/n2]
            ( -- Medelv�rde1 - Medelv�rde2
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [TotalDue] END) AS INT)
                -
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [TotalDue] END) AS INT)
            )
            +
            ( -- Z (1.96 f�r konfidensgrad 95 procent
                1.96
                *
                SQRT
                    (
                        ( -- (standardavvickelse1)^2/n1
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [SalesOrderID] END), 0)
                        )
                        +
                        ( -- (standardavvickelse2)^2/n2
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [SalesOrderID] END), 0)
                        )
                    )
            )
        )
    FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
    WHERE YEAR([OrderDate]) IN (@�r1, @�r2);

   
    SELECT @SkillnadNedre = 
        ( -- (Medelv�rde1 - Medelv�rde2) -  z. sqrt [(standardavvickelse1)^2/n1 + (standardavvickelse2)^2/n2]
            ( -- Medelv�rde1 - Medelv�rde2
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [TotalDue] END) AS INT)
                -
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [TotalDue] END) AS INT)
            )
            -
            ( -- Z (1.96 f�r konfidensgrad 95 procent
                1.96
                *
                SQRT
                    (
                        ( -- (standardavvickelse1)^2/n1
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @�r1 THEN [SalesOrderID] END), 0)
                        )
                        +
                        ( -- (standardavvickelse2)^2/n2
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @�r2 THEN [SalesOrderID] END), 0)
                        )
                    )
            )
        )
    FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
    WHERE YEAR([OrderDate]) IN (@�r1, @�r2);

	INSERT INTO @SkillnadsIntervall (Skillnad�vre, SkillnadNedre) VALUES (@Skillnad�vre, @SkillnadNedre)

    RETURN;
END;
GO

-- Kalla p� funktionen
SELECT Skillnad�vre, SkillnadNedre FROM dbo.SkillnadMedelv�rde(2012, 2013);