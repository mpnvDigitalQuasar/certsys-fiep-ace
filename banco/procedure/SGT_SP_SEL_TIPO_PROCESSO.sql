USE [BROKER]
GO

/****** Object:  StoredProcedure [dbo].[SGT_SP_SEL_TIPO_PROCESSO]    Script Date: 22/10/2024 16:04:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<Melina Pereira Nalia Viana>
-- Create date: <2024-10-22>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[SGT_SP_SEL_TIPO_PROCESSO] 
	@tipo_processo varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Variáveis
    DECLARE @Error BIT = 0;
    DECLARE @MsgError VARCHAR(2047) = 'Erro ao buscar informações tipo processo.';

    BEGIN TRY
        BEGIN

            SELECT tp.id AS id, tp.nome_tipo_processo AS tipo_processo
            FROM [dbo].[SGT_TIPO_PROCESSO] tp
            WHERE tp.nome_tipo_processo = @tipo_processo

        END
    END TRY
    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao buscar valor na tabela SGT_TIPO_PROCESSO. '
              + ERROR_MESSAGE();
        GOTO erro;
    END CATCH

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
GO


