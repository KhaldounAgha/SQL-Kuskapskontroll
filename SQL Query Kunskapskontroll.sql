USE [AdventureWorks2022]
GO
----------------------------
 -- DONE --
----------------------------
-- 00100 -- Totalt antal produkter

SELECT COUNT(*) AS [Totalt Antal Produkter]
FROM [AdventureWorks2022].[Production].[Product];

-- 00110 -- Totalt Försäljnings Belopp
SELECT CAST(SUM([TotalDue]) AS int) AS [Totalt Försäljnings Belopp]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

-- 00120 -- Totalt Försäljnings Belopp
SELECT CAST(AVG([TotalDue]) AS decimal(10,2)) AS [Genomsnittligt Ordervärde]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

-- 00130 -- Totalt Spenderat Belopp
SELECT TOP 10 [CustomerID], CAST(SUM([TotalDue]) AS int) AS [Totalt Spenderat Belopp]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY [CustomerID] ORDER BY [Totalt Spenderat Belopp] DESC;

-- 00140 -- Företagets personal 
SELECT COUNT([JobTitle]), [JobTitle]  
FROM [AdventureWorks2022].[humanresources].[employee]
GROUP BY [JobTitle]
ORDER BY [JobTitle];

-- 00150 -- Antal och Kategorier av Personer i Företaget
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


-- 00160 -- Avdelningar och antal anställda
SELECT 
	A.[Name] AS [Avdelning], 
	COUNT(*) AS [Antal Anställda]
FROM [AdventureWorks2022].[HumanResources].[Department] AS A
JOIN [AdventureWorks2022].[HumanResources].[EmployeeDepartmentHistory] AS B 
ON A.[DepartmentID] = B.[DepartmentID]
GROUP BY A.[Name];

-- 00170 -- Försäljning per produktkategori
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
-- 00300 -- Kundfördelning per Land

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
-- 00400 -- Totalt antal beställningar 
SELECT 
	COUNT([SalesOrderID]) AS [Totalt Antal Beställningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader];

----------------------------
 -- DONE --
----------------------------
-- 00500 -- Antal beställningar per år

SELECT 
	YEAR([OrderDate]) AS [År],
	COUNT([SalesOrderID]) AS [Antal Beställningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR([OrderDate])
ORDER BY 
	YEAR([OrderDate]);

----------------------------
 -- DONE --
----------------------------
-- 00600 -- Antal beställningar per kvartal

SELECT 
    YEAR([OrderDate]) AS [År],
    DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
    COUNT([SalesOrderID]) AS [Antal Beställningar]
FROM
    [AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
    YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
ORDER BY 
    [År], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 00700 -- Antal beställningar per månad

SELECT 
	YEAR([OrderDate]) AS [År],
	MONTH([OrderDate]) AS [Månad],
	COUNT(SalesOrderID) AS [Ordrar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
	YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
	[År], [Månad] ASC;

----------------------------
 -- DONE --
----------------------------
-- 00800 -- Antal beställningar per land

SELECT 
	T.[CountryRegionCode] AS [Land],
	COUNT(S.[CustomerID]) AS [Antal Beställningar]
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
-- 00900 -- Antal beställningar per land och år  

SELECT 
	YEAR(S.[OrderDate]) AS [År],
	T.[CountryRegionCode] AS [Land],
	COUNT(S.[CustomerID]) AS [Antal Beställningar]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] AS S
    LEFT OUTER JOIN [Sales].[SalesTerritory] AS T
    ON S.[TerritoryID] = T.[TerritoryID]
GROUP BY 
    YEAR(S.[OrderDate]), T.[CountryRegionCode]
ORDER BY 
	[År], [Land];

----------------------------
 -- DONE --
----------------------------
-- 01000 --Fördelning av antal beställningar per kund

WITH [CTE_AntalBeställningarPerKund] AS 
	(
		SELECT 
			COUNT([SalesOrderID]) AS [AntalBeställningarPerKund]
		FROM 
			[AdventureWorks2022].[Sales].[SalesOrderHeader]
		GROUP BY 
			[CustomerID]
	)

SELECT 
	[AntalBeställningarPerKund] AS [Antal beställningar per kund],
	COUNT([AntalBeställningarPerKund]) AS [Antal kunder]
FROM 
	[CTE_AntalBeställningarPerKund]
GROUP BY
	[AntalBeställningarPerKund]
ORDER BY 
	[AntalBeställningarPerKund] DESC;

----------------------------
 -- DONE --
----------------------------
-- 02000 -- Årlig försäljningssammanfattning

WITH [CTE_ÅrTotal] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [OrderDate], 
        COUNT([SalesOrderID]) AS [TotaltAntalBeställningar],
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
    [OrderDate] AS [År], 
    [TotaltAntalBeställningar] AS [Antal Beställningar],
    CAST(ROUND([DelSumma], 0) AS int) AS [Del Summa], 
    [Procentandel DelSumma] = CAST(ROUND([DelSumma] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([Skatt], 0) AS int) AS [Skatt Belopp], 
    [Procentandel Skatt] = CAST(ROUND([Skatt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([Frakt], 0) AS int) AS [Frakt],
    [Procentandel Frakt] = CAST(ROUND([Frakt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate]), 2) AS decimal(5, 2)),
    CAST(ROUND([TotaltBelopp], 0) AS int) AS [Totalt Belopp]
FROM 
    [CTE_ÅrTotal] 
ORDER BY 
    [OrderDate] ASC;
----------------------------
 -- DONE --
----------------------------
-- 03000 -- Försäljning per kvartal

WITH [CTE_ÅrTotal] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [OrderDate], 
        DATEPART(QUARTER, [OrderDate]) AS [Quarter],
        COUNT([SalesOrderID]) AS [TotaltAntalBeställningar],
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
    [OrderDate] AS [År], 
    [Quarter] AS [Kvartal],
    [TotaltAntalBeställningar] AS [Antal Beställningar],

    CAST(ROUND([DelSumma], 0) AS int) AS [Del Summa], 
    [Procentandel DelSumma] = CAST(ROUND([DelSumma] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([Skatt], 0) AS int) AS [Skatt Belopp], 
    [Procentandel Skatt] = CAST(ROUND([Skatt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([Frakt], 0) AS int) AS [Frakt],
    [Procentandel Frakt] = CAST(ROUND([Frakt] * 100.0 / SUM([TotaltBelopp]) OVER (PARTITION BY [OrderDate], [Quarter]), 2) AS decimal(5, 2)),

    CAST(ROUND([TotaltBelopp], 0) AS int) AS [Totalt Belopp]
FROM 
    [CTE_ÅrTotal] 
ORDER BY 
    [OrderDate], [Quarter] ASC;

----------------------------
 -- DONE --
----------------------------
-- 04000 -- Försäljning per månad 

WITH [CTE_OrderTotalMonth] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [År],
		MONTH([OrderDate]) AS [Månad],
		COUNT(SalesOrderID) AS [Antal beställningar],
        SUM([TotalDue]) AS [Totalt belopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate]), MONTH([OrderDate])
	)

SELECT 
    [År], 
	[Månad],
	[Antal beställningar],
    CAST([Totalt belopp] AS int) AS [Totalt belopp]
FROM 
	[CTE_OrderTotalMonth]
ORDER BY
	[År] ASC, [Månad] ASC;

----------------------------
 -- DONE --
----------------------------
-- 05000 -- Månatlig MAX och MIN Totalt belopp

WITH [CTE_MinMaxOrder] AS 
	(
    SELECT 
        YEAR([OrderDate]) AS [År],
		MONTH([OrderDate]) AS [Månad],
		COUNT(SalesOrderID) AS [Antal ordrar],
        SUM([TotalDue]) AS [Totalt belopp]
    FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
    GROUP BY 
		YEAR([OrderDate]), MONTH([OrderDate])
	)

SELECT 
	[År], 
	[Månad], 
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
-- 06000 --  Medelvärdert för beställningar och totalt belopp, månadsvis

SELECT 
    YEAR([OrderDate]) AS [År],
	MONTH([OrderDate]) AS [Månad],
	COUNT(SalesOrderID) AS [Antal beställningar],
    CAST(SUM([TotalDue]) AS INT) AS [Totalt belopp],
	CAST(AVG([TotalDue]) AS INT) AS [Medelvärde]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader]
GROUP BY 
	YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
	[Medelvärde];

----------------------------
 -- DONE --
----------------------------
-- 06110 -- Medelvärdet för alla försäljningsordrar i företaget

SELECT CAST(AVG([TotalDue]) AS INT) AS [Totalt Medelvärde]
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader];

----------------------------
 -- DONE --
----------------------------
-- 07000 -- Kvartalsvis fördelning av online beställningar och beställningar av säljare

WITH [CTE_OnlineOrderSP] AS
	(
	SELECT 
		YEAR([OrderDate]) AS [År],
		DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
		SUM(CASE WHEN [OnlineOrderFlag] = 1 THEN 1 ELSE 0 END) AS [OnlineBeställningar],
		SUM(CASE WHEN [OnlineOrderFlag] = 0 THEN 1 ELSE 0 END) AS [Beställningar Av Säljare],
		COUNT(*) AS [Nämnare]
	FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
	GROUP BY 
		YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
	)

SELECT 
	[År],
	[Kvartal],
	[OnlineBeställningar] AS [Online Beställningar],
	[Beställningar Av Säljare] AS [Beställningar Av Säljare],
	CAST(100.0 * [OnlineBeställningar] / [Nämnare] AS decimal(3, 1)) AS [Andel: Online Beställning],
	CAST(100.0 * [Beställningar Av Säljare] / [Nämnare] AS decimal(3, 1)) AS [Andel: Beställningar genom säljare]
FROM
	[CTE_OnlineOrderSP]
ORDER BY 
	[År], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 08000 -- Försäljningsstatistik per Kvartal - Medelvärde och Standardavvikelse

SELECT 
	YEAR([OrderDate]) AS [År], 
	DATEPART(QUARTER, [OrderDate]) AS [Kvartal],
	CAST(AVG([TotalDue]) AS int) AS [Genomsnitt Totalt belopp)],
	CAST(STDEV([TotalDue]) AS int) AS [Standardavvikelse Totalt belopp]
FROM 
	[AdventureWorks2022].[Sales].[SalesOrderHeader] 
GROUP BY  
	YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
ORDER BY 
	[År], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 09000 -- Median (50:e percentilen) av totalt belopp

SELECT  DISTINCT
		PERCENTILE_CONT(0.5) 
		WITHIN GROUP (ORDER BY [TotalDue]) 
		OVER (PARTITION BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate]))
		AS [Median Totalt belopp], 
		YEAR([OrderDate]) AS [År], 
		DATEPART(QUARTER, [OrderDate]) AS [Kvartal]
FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
ORDER BY 
		[År], [Kvartal];

----------------------------
 -- DONE --
----------------------------
-- 01110 -- Antal beställningar och det totala försäljningsbeloppet per land för varje säljare

SELECT 
	A.[SalesPersonID], 
	C.[FirstName], 
	C.[LastName], 
	D.[CountryRegionCode] AS [Land], 
	COUNT(A.[SalesPersonID]) AS [Antal Beställningar], 
	CAST(SUM(A.TotalDue) AS int) AS [Total Försäljning]
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
	[Total Försäljning];

----------------------------
 -- DONE --
----------------------------
-- 01120 -- Statistisk analys (konfidensintervall), Totalt

WITH [CTE_konfidensintervall] AS 
	(
	SELECT 
		COUNT([TotalDue]) AS [n],
		CAST(AVG([TotalDue]) AS int) AS [Medelvärde],
		CAST(STDEV([TotalDue]) AS int) AS [Standardavvikelse]
	FROM 
		[AdventureWorks2022].[Sales].[SalesOrderHeader]
	) 

SELECT 
	[Medelvärde], 
	[Standardavvikelse],
	CAST(([Medelvärde]) - (1.96 * [Standardavvikelse] / SQRT(n)) AS INT) AS [KI_Nedre],
    CAST(([Medelvärde]) + (1.96 * [Standardavvikelse] / SQRT(n)) AS INT) AS [KI_Övre]
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
-- 01122 -- Statistisk analys (konfidensintervall), Månadsvist

SELECT 
    YEAR([OrderDate]) AS [År], 
	MONTH([OrderDate]) AS [Månad], 
	COUNT([SalesOrderID]) AS [Antal beställningar],
    CAST(AVG([TotalDue]) AS INT) AS [Medelvärde Totalt belopp],
    CAST(STDEV([TotalDue]) AS INT) AS [Standardavvikelse Totalt belopp],
    CAST((AVG([TotalDue]) - 1.96 * STDEV([TotalDue]) / SQRT(COUNT([TotalDue]))) AS INT) AS [KI_Nedre],
    CAST((AVG([TotalDue]) + 1.96 * STDEV([TotalDue]) / SQRT(COUNT([TotalDue]))) AS INT) AS [KI_Övre]
FROM 
    [AdventureWorks2022].[Sales].[SalesOrderHeader] 
GROUP BY  
    YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY 
    [År], [Månad];


----------------------------
 -- DONE --
----------------------------
-- 01133 -- En funktion för att beräkna konfidensintervall för skillnaden mellan medelvärden för två angivna år i tabellen: [AdventureWorks2022].[Sales].[SalesOrderHeader].
GO
CREATE FUNCTION dbo.SkillnadMedelvärde (@År1 INT, @År2 INT) 
RETURNS @SkillnadsIntervall TABLE (SkillnadÖvre INT, SkillnadNedre INT)
AS
BEGIN
    DECLARE @SkillnadÖvre INT;
    DECLARE @SkillnadNedre INT;

    SELECT @SkillnadÖvre = 
        ( -- (Medelvärde1 - Medelvärde2) +  z. sqrt [(standardavvickelse1)^2/n1 + (standardavvickelse2)^2/n2]
            ( -- Medelvärde1 - Medelvärde2
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @År1 THEN [TotalDue] END) AS INT)
                -
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @År2 THEN [TotalDue] END) AS INT)
            )
            +
            ( -- Z (1.96 för konfidensgrad 95 procent
                1.96
                *
                SQRT
                    (
                        ( -- (standardavvickelse1)^2/n1
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @År1 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @År1 THEN [SalesOrderID] END), 0)
                        )
                        +
                        ( -- (standardavvickelse2)^2/n2
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @År2 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @År2 THEN [SalesOrderID] END), 0)
                        )
                    )
            )
        )
    FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
    WHERE YEAR([OrderDate]) IN (@År1, @År2);

   
    SELECT @SkillnadNedre = 
        ( -- (Medelvärde1 - Medelvärde2) -  z. sqrt [(standardavvickelse1)^2/n1 + (standardavvickelse2)^2/n2]
            ( -- Medelvärde1 - Medelvärde2
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @År1 THEN [TotalDue] END) AS INT)
                -
                CAST(AVG(CASE WHEN YEAR([OrderDate]) = @År2 THEN [TotalDue] END) AS INT)
            )
            -
            ( -- Z (1.96 för konfidensgrad 95 procent
                1.96
                *
                SQRT
                    (
                        ( -- (standardavvickelse1)^2/n1
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @År1 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @År1 THEN [SalesOrderID] END), 0)
                        )
                        +
                        ( -- (standardavvickelse2)^2/n2
                            POWER(STDEV(CASE WHEN YEAR([OrderDate]) = @År2 THEN [TotalDue] END), 2)
                            / NULLIF(COUNT(CASE WHEN YEAR([OrderDate]) = @År2 THEN [SalesOrderID] END), 0)
                        )
                    )
            )
        )
    FROM [AdventureWorks2022].[Sales].[SalesOrderHeader]
    WHERE YEAR([OrderDate]) IN (@År1, @År2);

	INSERT INTO @SkillnadsIntervall (SkillnadÖvre, SkillnadNedre) VALUES (@SkillnadÖvre, @SkillnadNedre)

    RETURN;
END;
GO

-- Kalla på funktionen
SELECT SkillnadÖvre, SkillnadNedre FROM dbo.SkillnadMedelvärde(2012, 2013);