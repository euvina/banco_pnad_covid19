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

renda AS (
  SELECT 
      m.mes
    , m.semana  
    , r.regiao
    , m.sigla_uf AS estado
    , CASE WHEN CAST(m.a003 AS INT)=1 THEN 'M' ELSE 'F' END AS sexo
    , CASE CAST(m.a004 AS INT)
        WHEN 1 THEN 'Branca'
        WHEN 2 THEN 'Preta'
        WHEN 3 THEN 'Amarela'
        WHEN 4 THEN 'Parda'
        WHEN 5 THEN 'Indígena'
        ELSE 'Ignorada' END AS raca_cor
    , CASE CAST(m.c01011 AS INT)
        WHEN 0 THEN '0 a 100'
        WHEN 1 THEN '101 a 300'
        WHEN 2 THEN '301 a 600'
        WHEN 3 THEN '601 a 800'
        WHEN 4 THEN '801 a 1.600'
        WHEN 5 THEN '1.601 a 3.000'
        WHEN 6 THEN '3.001 a 10.000'
        WHEN 7 THEN '10.001 a 50.000'
        WHEN 8 THEN '50.001 a 100.000'
        WHEN 9 THEN 'mais de 100.000'
        ELSE 'Não aplicável' END AS faixa_renda_dinheiro
    , COUNT(*) AS respondentes
  FROM `basedosdados.br_ibge_pnad_covid.microdados` AS m
  RIGHT JOIN regioes AS r
    ON (m.sigla_uf=r.estado)
  WHERE 
        mes BETWEEN 7 AND 9
  GROUP BY m.mes, m.semana, r.regiao, m.sigla_uf, m.a003, m.a004, m.c01011
  ORDER BY r.regiao, m.sigla_uf, m.mes, m.semana, m.a003, m.a004, m.c01011
)

SELECT * FROM renda