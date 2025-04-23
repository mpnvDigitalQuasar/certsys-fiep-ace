USE [BROKER]
GO
/****** Object:  StoredProcedure [dbo].[SGT_SP_SEL_NOME_ETAPAS]    Script Date: 23/10/2024 22:42:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  	<Melina Pereira Nalia Viana>
-- Create date: <2024-10-22>
-- =============================================

ALTER   PROCEDURE [dbo].[SGT_SP_SEL_NOME_ETAPAS] 
	@nome_etapa varchar(50),
	@nome_tipo_processo varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Variáveis
    DECLARE @Error BIT = 0;
    DECLARE @MsgError VARCHAR(2047) = 'Erro ao buscar informações tipo processo.';

    BEGIN TRY
        BEGIN

            SELECT ne.id AS id, ne.id_tipo_processo AS id_processo, ne.nome_etapa AS nome_etapa
            FROM [dbo].[SGT_NOME_ETAPAS] ne
			INNER JOIN [SGT_TIPO_PROCESSO] tp
			ON ne.id_tipo_processo = tp.id
            WHERE ne.nome_etapa = @nome_etapa AND tp.nome_tipo_processo = @nome_tipo_processo

        END
    END TRY
    BEGIN CATCH
        SET @ERROR = 1;
        SET @MsgError
            = @MsgError + 'Erro ao buscar valor na tabela SGT_NOME_ETAPAS. '
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
