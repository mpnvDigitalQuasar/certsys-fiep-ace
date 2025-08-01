USE [BROKER]
GO
/****** Object:  Trigger [dbo].[TR_INSERT_HIERARQUIA_HIST_CENTRO_RESPONSABILIDADE]    Script Date: 19/08/2024 22:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER TRIGGER [dbo].[TR_INSERT_HIERARQUIA_HIST_CENTRO_RESPONSABILIDADE]
   ON  [dbo].[HIERARQUIA_CENTRO_RESPONSABILIDADE]
   AFTER INSERT
AS 
BEGIN

		INSERT INTO [dbo].[HIERARQUIA_HIST_CENTRO_RESPONSABILIDADE]
			   ([codigo]
			   ,[descricao]
			   ,[data_inicio_vigencia]
			   ,[data_fim_vigencia]
			   ,[data_criacao]
			   ,[desabilitado]
			   ,[desativado_integracao]
			   ,[id_unidade_departamental]
			   ,[id_centro_responsabilidade]
			   ,[data_atualizacao]
			   ,[id_processo])
		SELECT [codigo]
			  ,[descricao]
			  ,[data_inicio_vigencia]
			  ,[data_fim_vigencia]
			  ,[data_criacao]
			  ,[desabilitado]
			  ,[desativado_integracao]
			  ,[id_unidade_departamental]
			  ,[id]
			  ,GETDATE()
			  ,[id_processo]
		FROM INSERTED;
END
