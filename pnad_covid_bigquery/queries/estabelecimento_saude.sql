WITH regioes AS (
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

estabelecimento_saude AS (
  SELECT
      m.mes
    , m.semana
    , m.mes||'_'||m.semana AS mes_semana
    , r.regiao
    , m.sigla_uf as estado
    , SUM(CASE WHEN CAST(m.b002 AS INT)=1 THEN 1 ELSE 0 END) AS buscou_estabelecimento_saude
    , SUM(CASE WHEN CAST(m.b005 AS INT)=1 THEN 1 ELSE 0 END) AS foi_internado
    , SUM(CASE WHEN CAST(m.b005 AS INT)=3 THEN 1 ELSE 0 END) AS sem_atendimento
    , SUM(CASE WHEN CAST(m.b006 AS INT)=1 THEN 1 ELSE 0 END) AS sedado_entubado
    , COUNT(*) AS respondentes
  FROM `basedosdados.br_ibge_pnad_covid.microdados` AS m
  RIGHT JOIN regioes AS r
    ON (m.sigla_uf=r.estado)
  WHERE
          mes BETWEEN 9 AND 11
      -- remover ignorados
      AND CAST(m.b002 AS INT)<>9
      AND m.b002 IS NOT NULL
  GROUP BY 
          m.mes
        , m.semana 
        , mes_semana
        , r.regiao
        , m.sigla_uf
        , m.b002
        , m.b005
        , m.b006
)

SELECT * 
FROM estabelecimento_saude
-- apenas quem buscou estabelecimento de saúde
WHERE buscou_estabelecimento_saude > 0