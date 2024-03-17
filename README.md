# Banco de Dados Hospitalar a partir da pesquisa PNAD-COVID19 do IBGE
Criação de banco de dados e análise sobre a pandemia no Brasil, com período de Setembro a Novembro de 2020, a partir da pesquisa PNAD COVID19 do IBGE. 
*FIAP: Pós Tech - Data Analytics Tech Challenge #03*

Grupo 32 - Autores:
- Cristiane Aline Fischer
- Pedro Baldini
- Vinícius Prado Lima
- Vitor Sarilio

**[Link do artigo](colocar link)**

---

### Objetivos
- Organizar 3 meses de microdados da pesquisa PNAD COVID19 do IBGE em um banco de dados em nuvem.
- Traçar perfil populacional e ressaltar indicadores importantes para o planejamento, caso haja um novo surto da doença.
- Facilitar o acesso aos dados, com um dashboard para monitoramento.

---

### Arquivos Importantes

**Pesquisa PNAD COVID19**

Os dados da pesquisa podem ser obtidos diretamente no portal do IBGE, [clicando aqui](https://www.ibge.gov.br/estatisticas/investigacoes-experimentais/estatisticas-experimentais/27946-divulgacao-semanal-pnadcovid1?t=downloads&utm_source=covid19&utm_medium=hotsite&utm_campaign=covid_19).

**main/**

- `pnad_covid_bigquery`: pasta contendo consultas SQL e tabelas do banco de dados
- `dashboard_pnad_covid.pbix`: pasta contendo consultas SQL e tabelas do banco de dados
- `data_pnad_covid.ipynb`: notebook para organização inicial dos dados
- `data_pnad_covid.ipynb`: notebook com análise exploratória dos dados
- `pyspark_pnad_covid_perfil`: notebook com consultas sobre o perfil dos respondentes, utilizando o PySpark
- `utils.py`: funções úteis para o mapeamento de microdados e dicionários da pesquisa PNAD COVID19
