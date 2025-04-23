USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_HISTORICO]    Script Date: 23/10/2024 22:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<MELINA PEREIRA NALIA VIANA>
-- Create date: <2024-10-22>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[SGT_SP_UPSET_CONTRATO_ERROS]
    @json NVARCHAR(max),
    @id INT output
AS
BEGIN
    BEGIN TRANSACTION;

    SET NOCOUNT ON;

    DECLARE @Error BIT = 0;
    DECLARE @MsgError VARCHAR(2047) = 'Erro ao inserir ou atualizar erro sgt.';

    IF ISJSON(@json) = 0
    BEGIN
        SET @ERROR = 1;
        SET @MsgError = @MsgError + 'JSON inválido.';
        GOTO erro;
    END

    BEGIN TRY
        BEGIN

			PRINT 'Insert erro sgt';
			INSERT INTO [dbo].[SGT_CONTRATO_ERROS]
			(
				[id_etapa]
				,[erro]
				,[data]
				,[local_transaction_id]
			)
			VALUES
			(
				COALESCE(JSON_VALUE(@json, '$.idEtapa'), ''),
				COALESCE(JSON_VALUE(@json, '$.erro'), ''),
				GETDATE(),
				COALESCE(JSON_VALUE(@json, '$.localTransactionId'), '')
			);

			SET @id = SCOPE_IDENTITY();

	END
	END TRY

    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_CONTRATO_ERROS. ' + ERROR_MESSAGE();
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
