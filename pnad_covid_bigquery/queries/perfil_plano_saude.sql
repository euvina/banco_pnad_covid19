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

plano_saude AS (
  SELECT
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , SUM(CASE WHEN CAST(m.b007 AS INT)=1 THEN 1 ELSE 0 END) AS sim_plano_saude
    , SUM(CASE WHEN CAST(m.b007 AS INT)=2 THEN 1 ELSE 0 END) AS nao_plano_saude
    , ROUND(SUM(CASE WHEN CAST(m.b007 AS INT)=1 THEN 1 ELSE 0 END)/COUNT(b007)*100, 2) AS per_sim_plano
    , ROUND(SUM(CASE WHEN CAST(m.b007 AS INT)=2 THEN 1 ELSE 0 END)/COUNT(b007)*100, 2) AS per_nao_plano
  FROM `basedosdados.br_ibge_pnad_covid.microdados` AS m
  RIGHT JOIN regioes AS r
    ON (m.sigla_uf=r.estado)
  WHERE 
        mes BETWEEN 9 AND 11
    -- remover 'Ignorado'
    AND CAST(m.b007 AS INT)<>9
  GROUP BY r.regiao, m.sigla_uf, m.mes
  ORDER BY sim_plano_saude DESC, r.regiao, m.sigla_uf, m.mes
)

SELECT * FROM plano_saude;