USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_PRODUTO_HISTORICO]    Script Date: 26/03/2025 15:12:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<RAFAEL DE ROSSO>
-- Create date: <2025-3-26>
-- =============================================

CREATE PROCEDURE [dbo].[SGT_SP_UPSET_PRODUTO_HISTORICO]
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

			SELECT @idExiste = id FROM [dbo].[SGT_PRODUTO_HISTORICO]
			WHERE [id] = JSON_VALUE(@json,'$.idHistorico')

			IF @idExiste IS NULL
				BEGIN

					PRINT 'Insert histórico sgt';
					INSERT INTO [dbo].[SGT_PRODUTO_HISTORICO]
					(
					   [id_registro_crm]
					  ,[id_fila_crm]
					  ,[status]
					  ,[sucesso]
					  ,[data_criacao]
					  ,[local_transaction_id]
					)
					VALUES
					(
					 COALESCE(JSON_VALUE(@json, '$.idRegistro'), ''),
					 COALESCE(JSON_VALUE(@json, '$.idFila'), ''),
					 COALESCE(JSON_VALUE(@json, '$.status'), ''),
					 COALESCE(JSON_VALUE(@json, '$.sucesso'), ''),
					 GETDATE(),
					 COALESCE(JSON_VALUE(@json, '$.parentTransactionId'), '')
					);

					SET @id = SCOPE_IDENTITY();

				END
		ELSE
			BEGIN

				UPDATE [dbo].[SGT_PRODUTO_HISTORICO]
				SET
					[status] = COALESCE(JSON_VALUE(@json, '$.status'), '')
					,[sucesso] = COALESCE(JSON_VALUE(@json, '$.sucesso'), '')
					,[data_atualizacao] = GETDATE()
				WHERE
				[id] = @idExiste

				SET @id = @idExiste;

			END

	END
	END TRY

    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_PRODUTO_HISTORICO]. ' + ERROR_MESSAGE();
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
