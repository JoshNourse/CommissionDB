/****** Script for SelectTopNRows command from SSMS  ******/



DECLARE @PostMonth nvarchar(10)
SET @PostMOnth = '1906'


INSERT INTO [Commission].[TEL].[CommissionRecordAccrued] (SalesPaidID, CommType, PaidTo, IsManualOverride, AmountOriginal, RULEID, CommPct, AmountComm)



/*** 
This Script creates CSR Commission records from accrued sales
Creates Union of 4 commission queries; Line Manager, Territory(Account), Shared Commission, Bonus(for future plans)
Total CSR commision percent and breakouts by function called from dbo.Commission MatrixCSR which is applied by invoice line in the view [TEL].[vw_CommLogicCSRMatrixAccrued]
Territories and accounts are called from TerritoryCSR and applied by invoice line in the view [TEL].[vw_CommLogicCSRTerritoryAccrued]
Share commissions use the CommissionEntity Table to count the number of participants in the table and apply a proportion to each
***/




/**Calculation for shared commission each**/
SELECT 
--NULL AS 'ID'
	CLCSR.[ID] AS 'SalesPaidID'
	, 'CSRShare' AS 'CommType'
	, CE.EntityCode AS 'PaidTo'
	, CLCSR.[IsManualOverride]
    ,CLCSR.[AmountOriginal]
    ,CLCSR.[RuleID]

		/*ShareEach Amount = Amount Original * Total CSR Commission * Share Percentage, Then divides by number of active CSR reps returned from subquery*/
	, ROUND(
		(CLCSR.[CommCSR] * CLCSR.[PctShare] /
			(
					SELECT /*[EntityType] ,*/ COUNT([IsActive]) AS 'NumOfCSR'
					FROM [Commission].[dbo].[CommissionEntity]
					WHERE IsActive = 1 AND (EntityType = 'CSR' OR EntityType = 'SNR')
					GROUP BY IsActive

			))
		, 5) AS 'CommPct'
	
	
		/*ShareEach Amount = Amount Paid * Total CSR Commission * Share Percentage, Then divides by number of active CSR reps returned from subquery*/
	, ROUND(
		(CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctShare] /
			(
					SELECT COUNT([IsActive]) AS 'NumOfCSR'
					FROM [Commission].[dbo].[CommissionEntity]
					WHERE IsActive = 1 AND (EntityType = 'CSR' OR EntityType = 'SNR')
					GROUP BY IsActive

			))
		, 5) AS 'ShareEach'
							
	/*ShareEach amount is then applied to each active CSR using join to Enity table (Active applied in Join Clause)*/
   FROM Commission.[TEL].[vw_CommLogicCSRMatrixAccrued] CLCSR
		JOIN Commission.dbo.CommissionEntity AS CE
			ON CE.IsActive = 1 AND (CE.EntityType = 'CSR' OR CE.EntityType = 'SNR')
	--WHERE CE.EntityCode IS NULL
	WHERE CLCSR.MonthPost = @PostMOnth




UNION



/**Calculation for Line Manager**/
SELECT 
	CLCSR.[ID] AS 'SalesPaidID'
	, 'CSRLine' AS 'CommType'
	, CLCSR.LineManager AS 'PaidTo'
	, CLCSR.[IsManualOverride]
    ,CLCSR.[AmountOriginal]
    ,CLCSR.[RuleID]
    , ROUND((CLCSR.[CommCSR] * CLCSR.[PctLine] ), 5) AS 'CommPct'
	/*Total Line Amount = Amount Original * Total CSR Commission * Line Percentage*/
	, ROUND((CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctLine] ), 5) AS 'TotalLineAmount'
	
   FROM [Commission].[TEL].[vw_CommLogicCSRMatrixAccrued] CLCSR
	--WHERE CLCSR.LineManager IS NULL
	WHERE CLCSR.MonthPost = @PostMOnth



UNION



/**Calculation for Territory Manager**/

SELECT 
	CLCSR.[ID] AS 'SalesPaidID'
	, 'CSRTert' AS 'CommType'
	, TCSR.PaidTo AS 'PaidTo'
	, CLCSR.[IsManualOverride]
    , CLCSR.[AmountOriginal]
    , TCSR.[RuleID]
	/*TertShareEach is the toal commission percent * Territory proportion * PctTertCredit, PctTertCredit will allow for Split accounts for CSR*/
	, ROUND((CLCSR.[CommCSR] * CLCSR.[PctTert] * TCSR.PctTertCredit), 5) AS 'CommPct'
	/*Adds dollar amount to percentage calculated above*/
	, ROUND((CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctTert] * TCSR.PctTertCredit), 5) AS 'ShareTertAmount'
							
							/*  **********Useful Debugging fields**************
								, CLCSR.[CommCSR]
								, CLCSR.TertQB
								, CLCSR.TertCheck
								, CLCSR.[PctTert]
								, TCSR.PctTertCredit
									/*TOtal Territory Amount = Amount Paid * Total CSR Commission * Line Percentage*/
								, ROUND((CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctTert] ), 5) AS 'TotalTertAmount'

								/*TertShareEach is the toal amount multiplied by the PctTertCredit*/
								, ROUND((CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctTert] * TCSR.PctTertCredit), 5) AS 'ShareTertAmount'
							*/	
	--, CLCSR.REPCHECK
   FROM [Commission].[TEL].[vw_CommLogicCSRMatrixAccrued] CLCSR
		JOIN [Commission].[TEL].[vw_CommLogicCSRTerritoryAccrued] AS TCSR
			ON CLCSR.ID = TCSR.ID
	--WHERE TCSR.PaidTo IS NULL
	WHERE CLCSR.MonthPost = @PostMOnth
		


UNION




/**Calculation for Bonus Amount**/
SELECT 
	CLCSR.[ID] AS 'SalesPaidID'
	, 'CSRBonus' AS 'CommType'
	, 'Accrual' AS 'PaidTo'
	, CLCSR.[IsManualOverride]
    ,CLCSR.[AmountOriginal]
    ,CLCSR.[RuleID]
		/*CommPct = Total CSR Commission * Bonus Percentage*/
	, ROUND((CLCSR.[CommCSR] * CLCSR.[PctBonus] ), 5) AS 'CommPct'
    	/*TOtal Line Amount = Amount Paid * Total CSR Commission * Bonus Percentage*/
	, ROUND((CLCSR.[AmountOriginal] * CLCSR.[CommCSR] * CLCSR.[PctBonus] ), 5) AS 'TotalBonusAmount'

   FROM [Commission].[TEL].[vw_CommLogicCSRMatrixAccrued] CLCSR
   WHERE CLCSR.MonthPost = @PostMOnth
		





/*********Stuff Used when building*************/

/*
TRUNCATE TABLE [Commission].[TEL].[CommissionRecordAccrued]
*/


/*
/** Returns CSR Entity Codes**/
SELECT [EntityCode]
			--[ID],[EntityType],[EntityCode],[IsActive],[DateStart],[DateEnd],[NameFull],[SendReportTo]
  FROM [Commission].[dbo].[CommissionEntity]
  WHERE EntityType = 'CSR' AND IsActive = 1

/**Returns Active Number of CSRs**/
  SELECT [EntityType] , COUNT([IsActive]) AS 'NumOfCSR'
  FROM [Commission].[dbo].[CommissionEntity]
  WHERE EntityType = 'CSR' AND IsActive = 1
  GROUP BY IsActive

  */






/*
SELECT 
--NULL AS 'ID'
	[ID] AS 'SalesPaidID'
	, 'CSR' AS 'CommType'
	, [IsManualOverride]
    ,[AmountPaid]
    ,[RuleID]
    ,[CommCSR]
	, ROUND([AmountPaid] * [CommCSR], 2) AS 'AmountComm'
 
  FROM [Commission].[TEL].[vw_CommLogicCSRMatrixAccrued]
  --WHERE MonthPost = @PostMonth

  */





/*
SELECT 
--NULL AS 'ID'
	CLCSR.[ID] AS 'SalesPaidID'
	, 'CSRShare' AS 'CommType'
	, [IsManualOverride]
    ,[AmountPaid]
    ,[RuleID]
    ,[CommCSR]
	, [PctShare]
	, ROUND(([AmountPaid] * [CommCSR] * [PctShare] ), 5) AS 'TotalShareAmount'
	, CE.EntityCode
   FROM [Commission].[dbo].[vw_CommLogicCSR] CLCSR
	 JOIN CommissionEntity AS CE
		ON CE.EntityType = 'CSR' AND CE.IsActive = 1


*/

   --,[AccountNo]
      --,[CustomerName]
      --,[InvoiceNo]
      --,[PaidDate]
      --,[MfgCode]
      --,[IncomeAccount]
      --, COALESCE([SplitRep], [RepQB]) AS 'PaidTo'
      --,[QBTert]
	  --,[SplitRep]

/*
  UNION


SELECT 
--NULL AS 'ID'
[ID] AS 'SalesPaidID'
 , 'MGT' AS 'CommType'
      --,[AccountNo]
      --,[CustomerName]
      --,[InvoiceNo]
      --,[PaidDate]
      --,[MfgCode]
      --,[IncomeAccount]
      , MgtPaidTo AS 'PaidTo'
	  , [IsManualOverride]
      --,[QBTert]
      ,[AmountPaid]
      --,[SplitRep]
      ,[RuleID]
      ,[CommMgtPct]
	  , ROUND([AmountPaid] * [CommMgtPct], 2) AS 'AmountComm'
      --,[MgtPaidToPct]
      --,[CommMgtPct]
      --,[ConsultPaidToPct]
      --,[CommConsultPct]
      --,[CommCSPct]
  FROM [Commission].[dbo].[vw_CommLogicMgt]
  WHERE MonthPost = @PostMonth
*/

 