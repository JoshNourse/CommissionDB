USE [Commission]
GO

/****** Object:  Table [dbo].[CommMatrixCSR]    Script Date: 8/8/2019 3:22:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CommMatrixCSR](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MfgCode] [nvarchar](10) NOT NULL,
	[Tert] [nvarchar](255) NOT NULL,
	[Rep] [nvarchar](255) NOT NULL,
	[Customer] [nvarchar](255) NOT NULL,
	[Item] [nvarchar](255) NOT NULL,
	[OrderOverride] [nvarchar](255) NULL,
	[CommCSR] [decimal](5, 4) NOT NULL,
	[LineManager] [nvarchar](255) NOT NULL,
	[PctShare] [decimal](5, 4) NOT NULL,
	[PctLine] [decimal](5, 4) NOT NULL,
	[PctTert] [decimal](5, 4) NOT NULL,
	[PctBonus] [decimal](5, 4) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateStart] [date] NOT NULL,
	[DateEnd] [date] NULL,
	[RulePriority] [tinyint] NOT NULL,
	[Memo] [nvarchar](1000) NULL,
 CONSTRAINT [PK__CommMatr__3214EC27E353BA82] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


