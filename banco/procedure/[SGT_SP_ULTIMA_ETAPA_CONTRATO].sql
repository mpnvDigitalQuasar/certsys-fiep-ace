-- CTE para pegar a última etapa por contrato
WITH UltimaEtapa AS (
    SELECT
        ce.id AS id_etapa,
        ce.id_historico,
        ce.id_nome_etapa,
        ce.status AS status_etapa,
        ce.sucesso AS sucesso_etapa,
        ce.data_criacao,
        ROW_NUMBER() OVER (PARTITION BY ce.id_historico ORDER BY ce.data_criacao DESC) AS rn
    FROM dbo.SGT_CONTRATO_ETAPAS ce
)

SELECT
    ch.id AS id_historico,
    ch.id_registro_crm,
    ch.id_fila_crm,
    ch.data_criacao AS data_criacao_historico,
    ch.data_atualizacao,
    ch.status AS status_historico,
    ch.sucesso AS sucesso_historico,
    ch.local_transaction_id,

    -- Última etapa (apenas se for falha)
    ne.nome_etapa,
    ue.status_etapa,
    ue.sucesso_etapa,
    ue.data_criacao AS data_criacao_ultima_etapa,

    err.erro,
    err.data AS data_erro

FROM dbo.SGT_CONTRATO_HISTORICO ch
LEFT JOIN UltimaEtapa ue ON ue.id_historico = ch.id AND ue.rn = 1
LEFT JOIN dbo.SGT_NOME_ETAPAS ne ON ue.id_nome_etapa = ne.id
LEFT JOIN dbo.SGT_CONTRATO_ERROS err ON err.id_etapa = ue.id_etapa
WHERE ch.sucesso = 0 -- Apenas contratos com falha
--AND ne.nome_etapa = 'Inserir Endereço SGT'
--AND ch.local_transaction_id = '0541b70b-5702-45ee-bd24-4e552e4f6953-2'
--AND ch.id = 5989
AND ch.data_criacao > '2025-04-22T13:47:07'
ORDER BY ch.data_atualizacao DESC
