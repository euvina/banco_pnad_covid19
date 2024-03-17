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

sabao_detergente AS (
  SELECT 
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , COUNT(IF(CAST(m.f002a1 AS INT64) = 1, 1, NULL)) AS sim
    , COUNT(IF(CAST(m.f002a1 AS INT64) = 2, 1, NULL)) AS nao
    , COUNT(IF(CAST(m.f002a1 AS INT64) NOT IN (1, 2), 1, NULL)) AS nao_sei
    , ROUND((COUNT(IF(CAST(m.f002a1 AS INT64) = 1, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_sim
    , ROUND((COUNT(IF(CAST(m.f002a1 AS INT64) = 2, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao
    , ROUND((COUNT(IF(CAST(m.f002a1 AS INT64) NOT IN (1, 2), 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao_sei
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m 
  JOIN regioes AS r 
    ON(m.sigla_uf=r.estado) 
  WHERE mes BETWEEN 9 AND 11
  GROUP BY 
      m.mes
    , r.regiao
    , m.sigla_uf
  ORDER BY 
      r.regiao
    , m.sigla_uf
    , m.mes
),

alcool_70 AS (
  SELECT 
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , COUNT(IF(CAST(m.f002a2 AS INT64) = 1, 1, NULL)) AS sim
    , COUNT(IF(CAST(m.f002a2 AS INT64) = 2, 1, NULL)) AS nao
    , COUNT(IF(CAST(m.f002a2 AS INT64) NOT IN (1, 2), 1, NULL)) AS nao_sei
    , ROUND((COUNT(IF(CAST(m.f002a2 AS INT64) = 1, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_sim
    , ROUND((COUNT(IF(CAST(m.f002a2 AS INT64) = 2, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao
    , ROUND((COUNT(IF(CAST(m.f002a2 AS INT64) NOT IN (1, 2), 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao_sei
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m 
  JOIN regioes AS r 
    ON(m.sigla_uf=r.estado) 
  WHERE mes BETWEEN 9 AND 11
  GROUP BY 
      m.mes
    , r.regiao
    , m.sigla_uf
  ORDER BY 
      r.regiao
    , m.sigla_uf
    , m.mes
),

mascara_descartavel AS (
  SELECT 
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , COUNT(IF(CAST(m.f002a3 AS INT64) = 1, 1, NULL)) AS sim
    , COUNT(IF(CAST(m.f002a3 AS INT64) = 2, 1, NULL)) AS nao
    , COUNT(IF(CAST(m.f002a3 AS INT64) NOT IN (1, 2), 1, NULL)) AS nao_sei
    , ROUND((COUNT(IF(CAST(m.f002a3 AS INT64) = 1, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_sim
    , ROUND((COUNT(IF(CAST(m.f002a3 AS INT64) = 2, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao
    , ROUND((COUNT(IF(CAST(m.f002a3 AS INT64) NOT IN (1, 2), 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao_sei
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m 
  JOIN regioes AS r 
    ON(m.sigla_uf=r.estado) 
  WHERE mes BETWEEN 9 AND 11
  GROUP BY 
      m.mes
    , r.regiao
    , m.sigla_uf
  ORDER BY 
      r.regiao
    , m.sigla_uf
    , m.mes
),

luva_descartavel AS (
  SELECT 
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , COUNT(IF(CAST(m.f002a4 AS INT64) = 1, 1, NULL)) AS sim
    , COUNT(IF(CAST(m.f002a4 AS INT64) = 2, 1, NULL)) AS nao
    , COUNT(IF(CAST(m.f002a4 AS INT64) NOT IN (1, 2), 1, NULL)) AS nao_sei
    , ROUND((COUNT(IF(CAST(m.f002a4 AS INT64) = 1, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_sim
    , ROUND((COUNT(IF(CAST(m.f002a4 AS INT64) = 2, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao
    , ROUND((COUNT(IF(CAST(m.f002a4 AS INT64) NOT IN (1, 2), 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao_sei
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m 
  JOIN regioes AS r 
    ON(m.sigla_uf=r.estado) 
  WHERE mes BETWEEN 9 AND 11
  GROUP BY 
      m.mes
    , r.regiao
    , m.sigla_uf
  ORDER BY 
      r.regiao
    , m.sigla_uf
    , m.mes
),

agua_sanitaria_desinfetante AS (
  SELECT 
      m.mes
    , r.regiao
    , m.sigla_uf AS estado
    , COUNT(IF(CAST(m.f002a5 AS INT64) = 1, 1, NULL)) AS sim
    , COUNT(IF(CAST(m.f002a5 AS INT64) = 2, 1, NULL)) AS nao
    , COUNT(IF(CAST(m.f002a5 AS INT64) NOT IN (1, 2), 1, NULL)) AS nao_sei
    , ROUND((COUNT(IF(CAST(m.f002a5 AS INT64) = 1, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_sim
    , ROUND((COUNT(IF(CAST(m.f002a5 AS INT64) = 2, 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao
    , ROUND((COUNT(IF(CAST(m.f002a5 AS INT64) NOT IN (1, 2), 1, NULL)) * 100.0) / COUNT(*), 2) AS porcentagem_nao_sei
  FROM `basedosdados.br_ibge_pnad_covid.microdados` as m 
  JOIN regioes AS r 
    ON(m.sigla_uf=r.estado) 
  WHERE mes BETWEEN 9 AND 11
  GROUP BY 
      m.mes
    , r.regiao
    , m.sigla_uf
  ORDER BY 
      r.regiao
    , m.sigla_uf
    , m.mes
)

-- SELECT * FROM sabao_detergente;
-- SELECT * FROM alcool_70;
-- SELECT * FROM mascara_descartavel;
-- SELECT * FROM luva_descartavel;
SELECT * FROM agua_sanitaria_desinfetante;

