USE [BROKER]
GO

/****** Object:  Table [dbo].[SGT_CONTRATO_ETAPAS]    Script Date: 22/10/2024 08:49:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SGT_CONTRATO_ETAPAS](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_historico] [int] NOT NULL,
	[id_nome_etapa] [int] NULL,
	[status] [varchar](100) NOT NULL,
	[sucesso] [bit] NULL,	
	[data_criacao] [datetime] NOT NULL

 CONSTRAINT [PK_SGT_CONTRATO_ETAPAS_ID] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SGT_CONTRATO_ETAPAS]  WITH CHECK ADD  CONSTRAINT [FK_SGT_CONTRATO_ETAPAS_ID_HISTORICO] FOREIGN KEY([id_historico])
REFERENCES [dbo].[SGT_CONTRATO_HISTORICO] ([id])
GO

ALTER TABLE [dbo].[SGT_CONTRATO_ETAPAS] CHECK CONSTRAINT [FK_SGT_CONTRATO_ETAPAS_ID_HISTORICO]
GO

ALTER TABLE [dbo].[SGT_CONTRATO_ETAPAS]  WITH CHECK ADD  CONSTRAINT [FK_SGT_CONTRATO_ETAPAS_ID_NOME_ETAPA] FOREIGN KEY([id_nome_etapa])
REFERENCES [dbo].[SGT_NOME_ETAPAS] ([id])
GO

ALTER TABLE [dbo].[SGT_CONTRATO_ETAPAS] CHECK CONSTRAINT [FK_SGT_CONTRATO_ETAPAS_ID_NOME_ETAPA]
GO
