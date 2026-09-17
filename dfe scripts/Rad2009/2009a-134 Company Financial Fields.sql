ALTER TABLE Companies
ADD [AnnualSalesDate] [datetime] NULL,
	[StartupOrg] [bit] NOT NULL CONSTRAINT [DF_Companies_StartupOrg_1]  DEFAULT (0),
	[StartupOrgDate] [datetime] NULL,
	[VentureCapitalOrg] [bit] NOT NULL CONSTRAINT [DF_Companies_VentureCapitalOrg_1]  DEFAULT (0),
	[Unionized] [bit] NOT NULL CONSTRAINT [DF_Companies_Unionized_1]  DEFAULT (0),
	[EIN] [varchar](20) NULL,
	[Assets] [money] NULL,
	[Budget] [money] NULL