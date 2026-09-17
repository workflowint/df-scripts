if OBJECT_ID('[dbo].[ID_ExchangeRatesID]','U') is not null DROP TABLE [dbo].[ID_ExchangeRatesID]
GO
CREATE TABLE [dbo].[ID_ExchangeRatesID](
                    [ID] [int] IDENTITY(1,1) NOT NULL,
                    CONSTRAINT [PK_ID_ExchangeRatesID] PRIMARY KEY CLUSTERED 
              ([ID] ASC) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
                  ) ON [PRIMARY]
GO                
GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[ID_ExchangeRatesID] TO [DeskFlowUsers]
