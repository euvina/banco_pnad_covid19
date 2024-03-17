WITH testagem_individual AS (
  SELECT 
      sigla_uf as estado
    , mes
    , semana
    -- realizou algum teste
    , CASE WHEN CAST(b008 AS INT64)=1 THEN 1 ELSE 0 END AS realizou_teste
    -- cotonete
    , CASE WHEN CAST(b009a AS INT64)=1 THEN 1 ELSE 0 END AS realizou_cotonete
    , CASE WHEN CAST(b009b AS INT64)=1 THEN 1 ELSE 0 END AS cotonete_positivo
    -- inconclusivo + ainda não recebeu o resultado como "inconclusivo"
    , CASE WHEN CAST(b009b AS INT64)=3 OR CAST(b009b AS INT64)=4 THEN 1 ELSE 0 END AS cotonete_inconclusivo
    , CASE WHEN CAST(b009b AS INT64)=2 THEN 1 ELSE 0 END AS cotonete_negativo
    -- coleta de sangue dedo
    , CASE WHEN CAST(b009c AS INT64)=1 THEN 1 ELSE 0 END AS realizou_sangue_dedo
    , CASE WHEN CAST(b009d AS INT64)=1 THEN 1 ELSE 0 END AS sangue_dedo_positivo
    , CASE WHEN CAST(b009d AS INT64)=3 OR CAST(b009d AS INT64)=4 THEN 1 ELSE 0 END AS sangue_dedo_inconclusivo
    , CASE WHEN CAST(b009d AS INT64)=2 THEN 1 ELSE 0 END AS sangue_dedo_negativo
    -- coleta de sangue braço
    , CASE WHEN CAST(b009e AS INT64)=1 THEN 1 ELSE 0 END AS realizou_sangue_braco
    , CASE WHEN CAST(b009f AS INT64)=1 THEN 1 ELSE 0 END AS sangue_braco_positivo
    , CASE WHEN CAST(b009f AS INT64)=3 OR CAST(b009f AS INT64)=4 THEN 1 ELSE 0 END AS sangue_braco_inconclusivo
    , CASE WHEN CAST(b009f AS INT64)=2 THEN 1 ELSE 0 END AS sangue_braco_negativo
  FROM `basedosdados.br_ibge_pnad_covid.microdados`
  WHERE mes BETWEEN 9 AND 11
),

testagem_total AS (
  SELECT 
    estado, mes, semana
    -- 1 pessoa conta uma única vez, mesmo que tenha feito mais de 1 teste
  , SUM(realizou_teste) AS realizou_algum_teste
    -- 1 pessoa pode ter realizado até 3 testes
  , SUM(realizou_cotonete) + SUM(realizou_sangue_dedo) + SUM(realizou_sangue_braco) AS testes_realizados
  , SUM(cotonete_positivo) + SUM(sangue_dedo_positivo) + SUM(sangue_braco_positivo) AS testes_positivos
  , SUM(cotonete_inconclusivo) + SUM(sangue_dedo_inconclusivo) + SUM(sangue_braco_inconclusivo) AS testes_inconclusivos
  , SUM(cotonete_negativo) + SUM(sangue_dedo_negativo) + SUM(sangue_braco_negativo) AS testes_negativos
  FROM testagem_individual
  GROUP BY estado, mes, semana
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
)

SELECT 
    r.regiao
,   t.estado
  -- absolutos
, SUM(t.testes_realizados) AS testes_realizados
, SUM(t.realizou_algum_teste) AS testes_individuais
, SUM(t.testes_positivos) AS testes_positivos
, SUM(t.testes_inconclusivos) AS testes_inconclusivos
, SUM(t.testes_negativos) AS tstes_negativos
  -- percentuais
, ROUND(SUM(t.testes_positivos)/SUM(t.testes_realizados)*100, 2) AS percentual_positivo
, ROUND(SUM(t.testes_inconclusivos)/SUM(t.testes_realizados)*100, 2) AS percentual_inconclusivo
, ROUND(SUM(t.testes_negativos)/SUM(t.testes_realizados)*100, 2) AS percentual_negativo
  -- quem realizou teste, em média, fez mais de um?
, ROUND(SUM(t.testes_realizados)/SUM(t.realizou_algum_teste), 2) as frequencia_teste
FROM testagem_total AS t
RIGHT JOIN regioes AS r
  ON (t.estado=r.estado)
GROUP BY r.regiao, t.estado
ORDER BY percentual_positivo DESC, percentual_inconclusivo DESC, r.regiao, t.estado
