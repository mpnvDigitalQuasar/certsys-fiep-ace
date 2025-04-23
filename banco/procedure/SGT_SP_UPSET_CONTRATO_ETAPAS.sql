USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_CONTRATO_ETAPAS]    Script Date: 04/12/2024 16:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<MELINA PEREIRA NALIA VIANA>
-- Create date: <2024-10-22>
-- =============================================

ALTER   PROCEDURE [dbo].[SGT_SP_UPSET_CONTRATO_ETAPAS]
    @json NVARCHAR(max),
    @id INT output
AS
BEGIN
    BEGIN TRANSACTION;

    SET NOCOUNT ON;

    DECLARE @Error BIT = 0;
    DECLARE @MsgError VARCHAR(2047) = 'Erro ao inserir ou atualizar histórico sgt.';

    IF ISJSON(@json) = 0
    BEGIN
        SET @ERROR = 1;
        SET @MsgError = @MsgError + 'JSON inválido.';
        GOTO erro;
    END

   BEGIN TRY
        BEGIN

			DECLARE @idExiste INT;

			--Comentado para sempre entrar no IF e inserir uma novo registro.
			--SELECT @idExiste = id FROM [dbo].[SGT_CONTRATO_ETAPAS]
			--WHERE [id] = JSON_VALUE(@json,'$.idEtapa')
			
			IF @idExiste IS NULL
				BEGIN

					PRINT 'Insert etapa sgt';
					INSERT INTO [dbo].[SGT_CONTRATO_ETAPAS]
					(
					   [id_historico]
					  ,[id_nome_etapa]
					  ,[status]
					  ,[sucesso]
					  ,[data_criacao]
					)
					VALUES
					(
					 COALESCE(JSON_VALUE(@json, '$.idHistorico'), ''),
					 COALESCE(JSON_VALUE(@json, '$.idNomeEtapa'), ''),
					 COALESCE(JSON_VALUE(@json, '$.status'), ''),
					 COALESCE(JSON_VALUE(@json, '$.sucesso'), ''),
					 GETDATE()
					);

					SET @id = SCOPE_IDENTITY();

				END
		ELSE
			BEGIN
				
				PRINT 'Update etapa sgt'
				UPDATE [dbo].[SGT_CONTRATO_ETAPAS]
				SET 
				   [status] = COALESCE(JSON_VALUE(@json, '$.status'), '')
				  ,[sucesso] = COALESCE(JSON_VALUE(@json, '$.sucesso'), '')
				WHERE
				[id] = @idExiste

				SET @id = @idExiste;

			END

	END
	END TRY

    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_CONTRATO_ETAPAS]. ' + ERROR_MESSAGE();
        GOTO erro;
    END CATCH

    COMMIT;
    SELECT @id AS id;

    IF @ERROR = 1
    BEGIN
        erro:
        --Rollback da transacao
        ROLLBACK;

        RAISERROR(   @MsgError, -- Message text.  
                     11,        -- Severity,  
                     1          -- State,  
                 );
    END
END
