USE [BROKER]
GO

/****** Object:  Table [dbo].[SGT_PRODUTO_HISTORICO]    Script Date: 22/10/2024 08:49:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SGT_PRODUTO_HISTORICO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_registro_crm] [varchar](100) NOT NULL,
	[id_fila_crm] [varchar](100) NOT NULL,
	[data_criacao] [datetime] NOT NULL,	
	[data_atualizacao] [datetime] NULL,	
	[status] [varchar](100) NOT NULL,
	[sucesso] [bit] NULL,	
	[local_transaction_id] [varchar](100) NULL
 CONSTRAINT [PK_SGT_PRODUTO_HISTORICO_ID] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

