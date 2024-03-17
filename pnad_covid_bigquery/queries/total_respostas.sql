WITH total_respostas AS (
  SELECT COUNT(*) AS total_respostas
  FROM `basedosdados.br_ibge_pnad_covid.microdados`
),

respostas_periodo_selecionado AS (
  SELECT COUNT(*) AS respostas_periodo_selecionado
  FROM `basedosdados.br_ibge_pnad_covid.microdados`
  WHERE mes BETWEEN 9 AND 11
)

-- SELECT * FROM total_respostas;
SELECT * FROM respostas_periodo_selecionado;