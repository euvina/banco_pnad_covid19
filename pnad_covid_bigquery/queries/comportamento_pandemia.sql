WITH regioes AS (
  SELECT 
      -- 26 estados + DF
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

comportamento AS (
  SELECT
      m.mes
    , m.semana
    , r.regiao
    , m.sigla_uf as estado
    , CASE CAST(m.b011 AS INT) 
        WHEN 1 THEN 'Continuou saindo normalmente'
        WHEN 2 THEN 'Reduziu contato com as pessoas, mas continuou saindo ou recebendo visitas'
        WHEN 3 THEN 'Ficou em casa e só saiu quando necessário'
        WHEN 4 THEN 'Ficou rigorosamente em casa'
        ELSE 'Ignorado' END AS comportamento_pandemia
    , CASE CAST(m.a006b AS INT)
        WHEN 1 THEN 'Presencial'
        WHEN 2 THEN 'Híbrido'
        WHEN 3 THEN 'Remoto'
        WHEN 4 THEN 'Remoto'
        ELSE 'Não aplicável' END AS modalidade_ensino
    -- trabalho na semana passada
    , CASE CAST(m.c013 AS INT)
        WHEN 1 THEN 'Remoto'
        WHEN 2 THEN 'Presencial'
        ELSE 'Não aplicável' END AS modalidade_trabalho
    , COUNT(*) as respondentes
  FROM `basedosdados.br_ibge_pnad_covid.microdados` AS m
  RIGHT JOIN regioes AS r
    ON (r.estado=m.sigla_uf)
  WHERE m.mes BETWEEN 9 AND 11
  GROUP BY m.mes, m.semana, r.regiao, m.sigla_uf, m.b011, m.a006b, m.c013
  ORDER BY r.regiao, m.sigla_uf, m.mes, m.semana, m.b011, m.a006b, m.c013
)

SELECT * FROM comportamento;