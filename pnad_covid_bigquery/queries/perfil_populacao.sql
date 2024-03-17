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

populacao_individual AS (
  SELECT 
      m.mes
    , m.semana  
    , r.regiao
    , m.sigla_uf AS estado
    , CAST(m.a002 AS INT) AS idade
    , CASE WHEN CAST(m.a003 AS INT)=1 THEN 'M' ELSE 'F' END AS sexo
    , CASE CAST(m.a004 AS INT)
        WHEN 1 THEN 'Branca'
        WHEN 2 THEN 'Preta'
        WHEN 3 THEN 'Amarela'
        WHEN 4 THEN 'Parda'
        WHEN 5 THEN 'Indígena'
        ELSE 'Ignorada' 
      END AS raca_cor
    , CASE CAST(m.a005 AS INT)
        WHEN 1 THEN 'Sem instrução'
        WHEN 2 THEN 'Fundamental incompleto'
        WHEN 3 THEN 'Fundamental completo'
        WHEN 4 THEN 'Médio incompleto'
        WHEN 5 THEN 'Médio completo'
        WHEN 6 THEN 'Superior incompleto'
        WHEN 7 THEN 'Superior completo'
        WHEN 8 THEN 'Pós-graduação, mestrado ou doutorado'
      END AS escolaridade
    , CASE CAST(m.c001 AS INT)
        WHEN 1 THEN 'Sim'
        WHEN 2 THEN 'Não'
        ELSE 'Não aplicável'
      END AS trabalhou_semana_passada  
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m
  RIGHT JOIN regioes AS r
    ON(m.sigla_uf=r.estado)
  WHERE mes BETWEEN 9 AND 11
),

populacao_total AS(
  SELECT
      DISTINCT 
      regiao
    , estado  
    , sexo
    , CAST(AVG(idade) AS INT) AS media_idade
    , COUNT(*) AS respondentes
  FROM populacao_individual
  GROUP BY regiao, estado, sexo
  ORDER BY regiao, estado, sexo
)

/*
SELECT
    regiao
  , CAST(AVG(idade) AS INT) AS media_idade
  , COUNT(*) AS respondentes
FROM populacao_individual
  GROUP BY regiao
  ORDER BY regiao
*/

SELECT * FROM populacao_total;