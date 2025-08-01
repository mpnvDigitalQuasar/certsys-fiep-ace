USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_PRODUTO_ERROS]    Script Date: 26/03/2025 15:11:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<RAFAEL DE ROSSO>
-- Create date: <2025-3-26>
-- =============================================


CREATE PROCEDURE [dbo].[SGT_SP_UPSET_PRODUTO_ERROS]
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

			DECLARE @idExiste INT;

			SELECT @idExiste = id FROM [dbo].[SGT_PRODUTO_ERROS]
			WHERE [id] = JSON_VALUE(@json,'$.idErro')

			IF @idExiste IS NULL
			BEGIN

				PRINT 'Insert erro sgt';
				INSERT INTO [dbo].[SGT_PRODUTO_ERROS]
				(
				   [id_etapa]
				  ,[erro]
				  ,[data]
				)
				VALUES
				(
				 COALESCE(JSON_VALUE(@json, '$.idEtapa'), ''),
				 COALESCE(JSON_VALUE(@json, '$.erro'), ''),
				 GETDATE()
				);

				SET @id = SCOPE_IDENTITY();

			END
	END
	END TRY

    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_PRODUTO_ERROS]. ' + ERROR_MESSAGE();
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
