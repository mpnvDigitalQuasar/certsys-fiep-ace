USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_UPSET_PRODUTO_ETAPAS]    Script Date: 26/03/2025 15:11:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<RAFAEL DE ROSSO>
-- Create date: <2025-3-26>
-- =============================================

CREATE   PROCEDURE [dbo].[SGT_SP_UPSET_PRODUTO_ETAPAS]
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

			PRINT 'Insert etapa sgt';
			INSERT INTO [dbo].[SGT_PRODUTO_ETAPAS]
			(
				[id_historico]
				,[id_nome_etapa]
				,[status]
				,[data_criacao]
			)
			VALUES
			(
				COALESCE(JSON_VALUE(@json, '$.idHistorico'), ''),
				COALESCE(JSON_VALUE(@json, '$.idNomeEtapa'), ''),
				COALESCE(JSON_VALUE(@json, '$.status'), ''),
				GETDATE()
			);

			SET @id = SCOPE_IDENTITY();
	END
	END TRY

    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao inserir ou atualizar valor na tabela [SGT_PRODUTO_ETAPAS]. ' + ERROR_MESSAGE();
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
