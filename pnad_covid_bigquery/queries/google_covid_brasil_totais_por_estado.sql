SELECT 
      DISTINCT province_state AS estado 
    , SUM(confirmed) AS total_confirmados
    , SUM(deaths) AS total_mortes
    , SUM(CASE WHEN recovered IS NULL THEN 1 ELSE recovered END) AS total_recuperados
    , SUM(CASE WHEN active IS NULL THEN 1 ELSE active END) AS total_ativos
    , ROUND(SUM(deaths)/SUM(confirmed)*100, 2) AS taxa_morte
    , ROUND(SUM(CASE WHEN recovered IS NULL THEN 1 ELSE recovered END)/
            SUM(confirmed)*100, 2) AS taxa_recuperados
FROM `bigquery-public-data.covid19_open_data.compatibility_view` 
WHERE 
          country_region = 'Brazil'
      AND DATE(date) >= DATE(2020, 09, 01)
      AND DATE(date) < DATE(2020, 12, 01)
GROUP BY province_state
ORDER BY province_state, taxa_morte DESC