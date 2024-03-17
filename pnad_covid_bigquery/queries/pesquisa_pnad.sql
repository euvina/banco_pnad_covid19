-- total de respostas por mês e semana
WITH respostas_total AS (
  SELECT 
    mes
  , semana
  , mes||'_'||semana AS mes_semana
  , COUNT(*) AS total_respostas
  FROM `basedosdados.br_ibge_pnad_covid.microdados` 
  GROUP BY mes, semana, mes_semana
  ORDER BY mes, semana
),

-- período de análise: set-nov/20
periodo_analisado AS (
  SELECT *
  FROM respostas_total
  WHERE mes BETWEEN 9 AND 11
  ORDER BY mes, semana
),

regioes AS (
  SELECT 
      DISTINCT sigla_uf AS estado
    , CASE
        WHEN sigla_uf IN ('DF', 'GO', 'MT', 'MS') THEN 'Centro-Oeste'
        WHEN sigla_uf IN ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE') THEN 'Nordeste'
        WHEN sigla_uf IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN 'Norte'
        WHEN sigla_uf IN ('ES', 'MG', 'RJ', 'SP') THEN 'Sudeste'
        WHEN sigla_uf IN ('PR', 'RS', 'SC') THEN 'Sul'
        ELSE NULL
      END AS regiao
  FROM `basedosdados.br_ibge_pnad_covid.microdados` 
),

-- total de respostas por região e estado
respostas_estado AS (
  SELECT 
    m.mes
  , r.regiao
  , m.sigla_uf AS estado
  , COUNT(*) AS total_respostas
  FROM `basedosdados.br_ibge_pnad_covid.microdados` AS m
  RIGHT JOIN regioes AS r
    ON (r.estado=m.sigla_uf)
  GROUP BY m.mes, r.regiao, m.sigla_uf
  ORDER BY m.sigla_uf, m.mes, r.regiao
)

SELECT * FROM respostas_estado;