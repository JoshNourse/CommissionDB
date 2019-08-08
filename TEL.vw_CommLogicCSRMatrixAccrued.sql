USE [Commission]
GO

/****** Object:  View [TEL].[vw_CommLogicCSRMatrixAccrued]    Script Date: 8/8/2019 2:57:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/


/**NEW: Uses commision DB instead of tables initallily in items DB  **/


/**  REVISION NOTES
1612-14 : Changed order of Priorty 9 and 10, Added commission override C00

**/




ALTER VIEW [TEL].[vw_CommLogicCSRMatrixAccrued]
AS

SELECT 
SP.[ID]
, SP.[AccountNo]
, SP.[NameCustomer]
, SP.[InvoiceNo]
, SP.[DateInvoice]
, SP.MonthPost
, SP.MonthComm
, SP.[MfgCodeLU]
, SP.[QBIncomeAccount]

, SP.[TertQB]
, SP.TertCheck
--, SP.[Item]
, SP.[AmountOriginal]

, SP.[RepQB]
, SP.REPCHECK
, SP.IsManualOverride

, Coalesce(C00.ID, C01.ID, C02.ID, C03.ID, C04.ID, C05.ID, C06.ID, C07.ID, C08.ID, C09.ID, C10.ID, C11.ID, C12.ID, C13.ID, C14.ID, C15.ID, C16.ID, C17.ID, C18.ID, C19.ID, C20.ID, C21.ID, C22.ID, C23.ID, C24.ID, C25.ID, C26.ID, C27.ID, C28.ID, C29.ID, C30.ID, C31.ID, C32.ID) AS 'RuleID'
, Coalesce(C00.CommCSR, C01.CommCSR, C02.CommCSR, C03.CommCSR, C04.CommCSR, C05.CommCSR, C06.CommCSR, C07.CommCSR, C08.CommCSR, C09.CommCSR, C10.CommCSR, C11.CommCSR, C12.CommCSR, C13.CommCSR, C14.CommCSR, C15.CommCSR, C16.CommCSR, C17.CommCSR, C18.CommCSR, C19.CommCSR, C20.CommCSR, C21.CommCSR, C22.CommCSR, C23.CommCSR, C24.CommCSR, C25.CommCSR, C26.CommCSR, C27.CommCSR, C28.CommCSR, C29.CommCSR, C30.CommCSR, C31.CommCSR, C32.CommCSR) AS 'CommCSR'
, Coalesce(C00.LineManager, C01.LineManager, C02.LineManager, C03.LineManager, C04.LineManager, C05.LineManager, C06.LineManager, C07.LineManager, C08.LineManager, C09.LineManager, C10.LineManager, C11.LineManager, C12.LineManager, C13.LineManager, C14.LineManager, C15.LineManager, C16.LineManager, C17.LineManager, C18.LineManager, C19.LineManager, C20.LineManager, C21.LineManager, C22.LineManager, C23.LineManager, C24.LineManager, C25.LineManager, C26.LineManager, C27.LineManager, C28.LineManager, C29.LineManager, C30.LineManager, C31.LineManager, C32.LineManager) AS 'LineManager'
, Coalesce(C00.PctShare, C01.PctShare, C02.PctShare, C03.PctShare, C04.PctShare, C05.PctShare, C06.PctShare, C07.PctShare, C08.PctShare, C09.PctShare, C10.PctShare, C11.PctShare, C12.PctShare, C13.PctShare, C14.PctShare, C15.PctShare, C16.PctShare, C17.PctShare, C18.PctShare, C19.PctShare, C20.PctShare, C21.PctShare, C22.PctShare, C23.PctShare, C24.PctShare, C25.PctShare, C26.PctShare, C27.PctShare, C28.PctShare, C29.PctShare, C30.PctShare, C31.PctShare, C32.PctShare) AS 'PctShare'
, Coalesce(C00.PctLine, C01.PctLine, C02.PctLine, C03.PctLine, C04.PctLine, C05.PctLine, C06.PctLine, C07.PctLine, C08.PctLine, C09.PctLine, C10.PctLine, C11.PctLine, C12.PctLine, C13.PctLine, C14.PctLine, C15.PctLine, C16.PctLine, C17.PctLine, C18.PctLine, C19.PctLine, C20.PctLine, C21.PctLine, C22.PctLine, C23.PctLine, C24.PctLine, C25.PctLine, C26.PctLine, C27.PctLine, C28.PctLine, C29.PctLine, C30.PctLine, C31.PctLine, C32.PctLine) AS 'PctLine'
, Coalesce(C00.PctTert, C01.PctTert, C02.PctTert, C03.PctTert, C04.PctTert, C05.PctTert, C06.PctTert, C07.PctTert, C08.PctTert, C09.PctTert, C10.PctTert, C11.PctTert, C12.PctTert, C13.PctTert, C14.PctTert, C15.PctTert, C16.PctTert, C17.PctTert, C18.PctTert, C19.PctTert, C20.PctTert, C21.PctTert, C22.PctTert, C23.PctTert, C24.PctTert, C25.PctTert, C26.PctTert, C27.PctTert, C28.PctTert, C29.PctTert, C30.PctTert, C31.PctTert, C32.PctTert) AS 'PctTert'
, Coalesce(C00.PctBonus, C01.PctBonus, C02.PctBonus, C03.PctBonus, C04.PctBonus, C05.PctBonus, C06.PctBonus, C07.PctBonus, C08.PctBonus, C09.PctBonus, C10.PctBonus, C11.PctBonus, C12.PctBonus, C13.PctBonus, C14.PctBonus, C15.PctBonus, C16.PctBonus, C17.PctBonus, C18.PctBonus, C19.PctBonus, C20.PctBonus, C21.PctBonus, C22.PctBonus, C23.PctBonus, C24.PctBonus, C25.PctBonus, C26.PctBonus, C27.PctBonus, C28.PctBonus, C29.PctBonus, C30.PctBonus, C31.PctBonus, C32.PctBonus) AS 'PctBonus'




  
  FROM [Commission].[TEL].[SalesAccruedTEL] AS SP
  
	LEFT JOIN Items.dbo.DateTable DTE
		ON SP.DateInvoice = DTE.Date

/* Commission Override  -- If Customer Matches and either Invoice Number, Sales Order Number, or PO Number matches, use this line as top priority */
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C00
		ON C00.Customer = SP.AccountNo
			AND
				(C00.OrderOverride = SP.InvoiceNo
				OR C00.OrderOverride = SP.SalesOrder
				OR C00.OrderOverride = SP.PurcahseOrder)	

/* Five Factor lookups*/
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C01
		ON C01.IsActive=1 AND C01.MfgCode = SP.MfgCodeLU		AND C01.Tert = SP.TertCheck	AND C01.Rep = SP.REPCHECK 	AND C01.Customer = SP.AccountNo 	AND C01.Item = SP.ItemNo

/* Four factor lookups*/
	
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C02
		ON C02.IsActive=1 AND  C02.MfgCode = 'All'				AND C02.Tert = SP.TertCheck	AND C02.Rep = SP.REPCHECK 	AND C02.Customer = SP.AccountNo		AND C02.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C03
		ON C03.IsActive=1 AND  C03.MfgCode = SP.MfgCodeLU		AND C03.Tert = 'All'		AND C03.Rep = SP.REPCHECK 	AND C03.Customer = SP.AccountNo 	AND C03.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C04
		ON C04.IsActive=1 AND  C04.MfgCode = SP.MfgCodeLU		AND C04.Tert = SP.TertCheck	AND C04.Rep = 'All'			AND C04.Customer = SP.AccountNo		AND C04.Item = SP.ItemNo
		LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C05
		ON C05.IsActive=1 AND  C05.MfgCode = SP.MfgCodeLU		AND C05.Tert = SP.TertCheck	AND C05.Rep = SP.REPCHECK 	AND C05.Customer = 'All' 			AND C05.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C06
		ON C06.IsActive=1 AND  C06.MfgCode = 'All'				AND C06.Tert = SP.TertCheck	AND C06.Rep = SP.REPCHECK	AND C06.Customer = SP.AccountNo 	AND C06.Item = 'All'



/* Three factor lookups*/

	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C07
		ON C07.IsActive=1 AND  C07.MfgCode = 'All'				AND C07.Tert = 'All'		AND C07.Rep = SP.REPCHECK 	AND C07.Customer = SP.AccountNo		AND C07.Item = SP.ItemNo

	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C08
		ON C08.IsActive=1 AND C08.MfgCode = 'All'				AND C08.Tert = SP.TertCheck	AND C08.Rep = 'All'		 	AND C08.Customer = SP.AccountNo 	AND C08.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C09
		ON C09.IsActive=1 AND C09.MfgCode = SP.MfgCodeLU		AND C09.Tert = 'All'		AND C09.Rep = 'All'		 	AND C09.Customer = SP.AccountNo 	AND C09.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C10
		ON C10.IsActive=1 AND C10.MfgCode = 'All'				AND C10.Tert = SP.TertCheck	AND C10.Rep = SP.REPCHECK 	AND C10.Customer = 'All'		 	AND C10.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C11
		ON C11.IsActive=1 AND C11.MfgCode = SP.MfgCodeLU		AND C11.Tert = 'All'		AND C11.Rep = SP.REPCHECK 	AND C11.Customer = 'All'		 	AND C11.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C12
		ON C12.IsActive=1 AND C12.MfgCode = SP.MfgCodeLU		AND C12.Tert = SP.TertCheck	AND C12.Rep = 'All'		 	AND C12.Customer = 'All'		 	AND C12.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C13
		ON C13.IsActive=1 AND C13.MfgCode = 'All'				AND C13.Tert = SP.TertCheck	AND C13.Rep = SP.REPCHECK 	AND C13.Customer = SP.AccountNo 	AND C13.Item = 'All'	
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C14
		ON C14.IsActive=1 AND C14.MfgCode = SP.MfgCodeLU		AND C14.Tert = 'All'		AND C14.Rep = SP.REPCHECK 	AND C14.Customer = SP.AccountNo 	AND C14.Item = 'All'	
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C15
		ON C15.IsActive=1 AND C15.MfgCode = SP.MfgCodeLU		AND C15.Tert = SP.TertCheck	AND C15.Rep = 'All'		 	AND C15.Customer = SP.AccountNo 	AND C15.Item = 'All'	
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C16
		ON C16.IsActive=1 AND C16.MfgCode = SP.MfgCodeLU		AND C16.Tert = SP.TertCheck	AND C16.Rep = SP.REPCHECK 	AND C16.Customer = 'All'			AND C16.Item = 'All'	


/* Two factor lookups*/

	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C17
		ON C17.IsActive=1 AND  C17.MfgCode = 'All'				AND C17.Tert = 'All'		AND C17.Rep = 'All'			AND C17.Customer = SP.AccountNo		AND C17.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C18
		ON C18.IsActive=1 AND  C18.MfgCode = 'All'				AND C18.Tert = 'All'		AND C18.Rep = SP.REPCHECK	AND C18.Customer = 'All'			AND C18.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C19
		ON C19.IsActive=1 AND  C19.MfgCode = 'All'				AND C19.Tert = SP.TertCheck	AND C19.Rep = 'All'			AND C19.Customer = 'All'			AND C19.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C20
		ON C20.IsActive=1 AND  C20.MfgCode = SP.MfgCodeLU		AND C20.Tert = 'All'		AND C20.Rep = 'All'			AND C20.Customer = 'All'			AND C20.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C21
		ON C21.IsActive=1 AND  C21.MfgCode = 'All'				AND C21.Tert = 'All'		AND C21.Rep = SP.REPCHECK	AND C21.Customer = SP.AccountNo		AND C21.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C22
		ON C22.IsActive=1 AND  C22.MfgCode = 'All'				AND C22.Tert = SP.TertCheck	AND C22.Rep = 'All'			AND C22.Customer = SP.AccountNo		AND C22.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C23
		ON C23.IsActive=1 AND  C23.MfgCode = SP.MfgCodeLU		AND C23.Tert = 'All'		AND C23.Rep = 'All'			AND C23.Customer = SP.AccountNo		AND C23.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C24
		ON C24.IsActive=1 AND  C24.MfgCode = 'All'				AND C24.Tert = SP.TertCheck	AND C24.Rep = SP.REPCHECK	AND C24.Customer = 'All'			AND C24.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C25
		ON C25.IsActive=1 AND  C25.MfgCode = SP.MfgCodeLU		AND C25.Tert = 'All'		AND C25.Rep = SP.REPCHECK	AND C25.Customer = 'All'			AND C25.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C26
		ON C26.IsActive=1 AND  C26.MfgCode = SP.MfgCodeLU		AND C26.Tert = SP.TertCheck	AND C26.Rep = 'All'			AND C26.Customer = 'All'			AND C26.Item = 'All'

/* One factor lookups*/
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C27
		ON C27.IsActive=1 AND  C27.MfgCode = 'All'				AND C27.Tert = 'All'		AND C27.Rep = 'All'			AND C27.Customer = 'All'			AND C27.Item = SP.ItemNo
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C28
		ON C28.IsActive=1 AND  C28.MfgCode = 'All'				AND C28.Tert = 'All'		AND C28.Rep = 'All'			AND C28.Customer = SP.AccountNo		AND C28.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C29
		ON C29.IsActive=1 AND  C29.MfgCode = 'All'				AND C29.Tert = 'All'		AND C29.Rep = SP.REPCHECK	AND C29.Customer = 'All'			AND C29.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C30
		ON C30.IsActive=1 AND  C30.MfgCode = 'All'				AND C30.Tert = SP.TertCheck	AND C30.Rep = 'All'			AND C30.Customer = 'All'			AND C30.Item = 'All'
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C31
		ON C31.IsActive=1 AND  C31.MfgCode = SP.MfgCodeLU		AND C31.Tert = 'All'		AND C31.Rep = 'All'			AND C31.Customer = 'All'			AND C31.Item = 'All'
	
	
/* Zero factory lookups*/
	LEFT JOIN [Commission].[dbo].[CommMatrixCSR] AS C32
		ON C32.IsActive=1 AND  C32.MfgCode = 'All'				AND C32.Tert = 'All'		AND C32.Rep = 'All'			AND C32.Customer = 'All'			AND C32.Item = 'All'

	


--WHERE SP.CustomerName LIKE 'David%'
--WHERE SP.CustomerName LIKE '%Bass%'
--WHERE SP.CustomerName LIKE '%CW%'
--WHERE SP.MfgCode = 'JVC' AND SP.QBRep != 'MSM'
--WHERE SP.MonthPost = '1610'

--ORDER BY SP.NameCustomer







GO


