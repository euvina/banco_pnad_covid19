-- região
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