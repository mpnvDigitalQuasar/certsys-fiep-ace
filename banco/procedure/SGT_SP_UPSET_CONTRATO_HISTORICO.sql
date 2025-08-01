USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_CONTRATO_HISTORICO]    Script Date: 21/01/2025 10:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<MELINA PEREIRA NALIA VIANA>
-- Create date: <2024-10-22>
-- =============================================

ALTER   PROCEDURE [dbo].[SGT_SP_UPSET_CONTRATO_HISTORICO]
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

			SELECT @idExiste = id FROM [dbo].[SGT_CONTRATO_HISTORICO]
			WHERE [id] = JSON_VALUE(@json,'$.idHistorico')

			IF @idExiste IS NULL
				BEGIN

					PRINT 'Insert histórico sgt';
					INSERT INTO [dbo].[SGT_CONTRATO_HISTORICO]
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

				UPDATE [dbo].[SGT_CONTRATO_HISTORICO]
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
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_CONTRATO_HISTORICO]. ' + ERROR_MESSAGE();
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
