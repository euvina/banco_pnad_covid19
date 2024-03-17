WITH sintomas AS (
    SELECT
      sigla_uf as estado
    , mes
    , semana
    , mes||'_'||semana AS mes_semana
    -- sintoma leve não indicativo
    , SUM(CASE
                WHEN CAST(b0011 AS INT64)=1 THEN 1
                ELSE 0 END) AS febre
    , SUM(CASE
                WHEN CAST(b0012 AS INT64)=1 THEN 1
                ELSE 0 END) AS tosse
    , SUM(CASE
                WHEN CAST(b0013 AS INT64)=1 THEN 1
                ELSE 0 END) AS dor_garganta        
    , SUM(CASE
                WHEN CAST(b0015 AS INT64)=1 THEN 1
                ELSE 0 END) AS dor_cabeca
    , SUM(CASE
                WHEN CAST(b00110 AS INT64)=1 THEN 1
                ELSE 0 END) AS dor_olhos
    , SUM(CASE
                WHEN CAST(b0018 AS INT64)=1 THEN 1
                ELSE 0 END) AS coriza
    , SUM(CASE
                WHEN CAST(b0019 AS INT64)=1 THEN 1
                ELSE 0 END) AS fadiga
    , SUM(CASE
                WHEN CAST(b0017 AS INT64)=1 THEN 1
                ELSE 0 END) AS nausea
    , SUM(CASE
                WHEN CAST(b00113 AS INT64)=1 THEN 1
                ELSE 0 END) AS diarreia
    -- sintoma moderado  
    , SUM(CASE
                WHEN CAST(b0016 AS INT64)=1 THEN 1
                ELSE 0 END) AS dor_peito
    , SUM(CASE
                WHEN CAST(b00112 AS INT64)=1 THEN 1
                ELSE 0 END) AS dor_muscular
    -- sintoma grave    
    , SUM(CASE
                WHEN CAST(b0014 AS INT64)=1 THEN 1
                ELSE 0 END) AS dificuldade_respirar
    -- sintoma leve indicativo
    , SUM(CASE
                WHEN CAST(b00111 AS INT64)=1 THEN 1
                ELSE 0 END) AS cheiro_sabor
    -- idade risco e comorbidades
    , SUM(CASE
                WHEN CAST(a002 AS INT64)<6 OR CAST(a002 AS INT64)>59 THEN 1
                ELSE 0 END) AS risco_idade     
    , SUM(CASE
                WHEN CAST(b0101 as INT64)=1 THEN 1
                ELSE 0 END) as diabetes
    , SUM(CASE
                WHEN CAST(b0102 AS INT64)=1 THEN 1
                ELSE 0 END) AS hipertensao 
    , SUM(CASE
                WHEN CAST(b0103 AS INT64)=1 THEN 1
                ELSE 0 END) AS doenca_respiratoria  
    , SUM(CASE
                WHEN CAST(b0104 AS INT64)=1 THEN 1
                ELSE 0 END) AS doenca_cardiaca  
    , SUM(CASE
                WHEN CAST(b0105 AS INT64)=1 THEN 1
                ELSE 0 END) AS depessao
    , SUM(CASE
                WHEN CAST(b0106 AS INT64)=1 THEN 1
                ELSE 0 END) AS cancer
    FROM `basedosdados.br_ibge_pnad_covid.microdados` 
    WHERE mes BETWEEN 9 AND 11
    GROUP BY sigla_uf, mes, semana, mes_semana
    ORDER BY sigla_uf, mes, semana
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

sintomas_comorbidades AS (
    SELECT 
        r.regiao
      , s.*
    FROM sintomas AS s
    RIGHT JOIN regioes AS r
    ON (s.estado=r.estado)
)

SELECT * FROM sintomas_comorbidades;