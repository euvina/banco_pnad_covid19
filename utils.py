### -------- Bibliotecas -------- ###
import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns


### -------- Preparo dos dados -------- ###
def open_pnad_dict(path, sheet_name='dicionário pnad covid'):
    '''Carregar arquivo excel com dicionário de variáveis PNAD COVID-19
    
    Params:
    path: str, caminho do arquivo
    sheet_name: str, nome da aba do arquivo excel
                default='dicionário pnad covid'
    
    Returns:
    pnad_dict: pandas DataFrame, dicionário de variáveis da PNAD COVID-19
    
    '''
    # pandas read excel
    pnad_dict = pd.read_excel(path, sheet_name=sheet_name, header=1, usecols='B:F', engine='xlrd')
    # rename columns
    pnad_dict.columns = ['questao', 'descricao', 'categoria', 'tipo', 'valor']
    # drop 0, 1, 2 rows
    pnad_dict = pnad_dict.drop([0, 1, 2])
    
    return pnad_dict



def clean_pnad_dict(df):
    ''' Preenche valores vazios quando há um dado anterior de referência,
        substiuiu quebras de linha textuais, símbolos e espaçoes duplos.
        
    Params:
    df: pandas DataFrame, dicionário de variáveis da PNAD COVID-19
    
    Returns:
    cleaned_pnad_dict: pandas DataFrame, dicionário de variáveis da PNAD COVID-19 limpo
    
    '''
    # ffills to fill the NaN values
    cleaned_pnad_dict = df.copy()
    cleaned_pnad_dict = df.ffill()
    # all lower case
    cleaned_pnad_dict = cleaned_pnad_dict.apply(lambda x: x.str.lower() 
                                                if x.dtype == 'object' else x)
    # replace all keys in df
    replaces = {
            '  ': ' ', 
            r'\n': ' ',
            r'\r': ' ',
            r'/': ' ou ',
            r'%': '_por_cento',
            }
    
    cleaned_pnad_dict = df.replace(replaces, regex=True)

    return cleaned_pnad_dict



def merge_dicts(dicts, drop_duplicates=True):
    '''Concatena os dicionários de variáveis PNAD COVID-19 e 
        remove duplicatas
    
    Params:
    dicts: list, lista de dicionários
    drop_duplicates: bool, default=True, remover duplicatas
    
    Returns:
    merged_dict: pandas DataFrame, dicionário de variáveis PNAD COVID-19
    
    '''
    # merge all dicts
    merged_dict = pd.concat(dicts)
    # ffills to fill the NaN values
    merged_dict = merged_dict.ffill()
    # drop duplicates
    if drop_duplicates:
        merged_dict = merged_dict.drop_duplicates()
    # if questao and valor are the same, drop
    merged_dict = merged_dict.drop_duplicates(subset=['questao', 'valor'])
    
    return merged_dict



def map_code_questao(df, questao=None, key='tipo', value='valor'):
    '''Retorna um dicionário com a chave e valor de um DataFrame
    
    Params:
    df: pandas DataFrame, dicionário de variáveis PNAD COVID-19
    questao: str, default=None, questão a ser filtrada
    key: str, default='tipo', chave do dicionário
    value: str, default='valor', valor do dicionário
    
    Returns:
    dict: dict, dicionário com a chave e valor do DataFrame
    
    '''
    if questao is None:
        return dict(zip(df[key], df[value]))
    
    else:
        return dict(zip(df.query(f'questao == "{questao}"')[key], 
                    df.query(f'questao == "{questao}"')[value]))



def read_microdata(dfs, selected_questions=None, rename_columns=False):
    '''Carrega os arquivos de microdados da PNAD COVID-19 e 
        filtra as colunas selecionadas
    
    Params:
    dfs: list, lista de DataFrames
    selected_questions: dict, dicionário com as questões selecionadas
    rename_columns: bool, default=False, renomear as colunas
                    default=False
    
    Returns:
    df: pandas DataFrame, microdados da PNAD COVID-19
    
    '''
    if selected_questions is None: 
        # merge all dfs
        df = pd.concat(dfs)
    else:
        # merge all dfs
        df = pd.concat(dfs)
        # filter selected questions
        df = df[list(selected_questions.keys())]
    # rename columns with selected_questions
    if rename_columns:
        df.columns = [selected_questions[col] for col in df.columns]
        
    return df



def make_df_from_dict(dict, df):
    '''Cria um DataFrame com as colunas do dicionário e 
        os valores do DataFrame
    
    Params:
    dict: dict, dicionário com as colunas do DataFrame
    df: pandas DataFrame, DataFrame com os valores
    
    Returns:
    df: pandas DataFrame, DataFrame com as colunas renomeadas
    
    '''
    # select keys as name of columns
    cols = list(dict.keys())
    # filter cols in df
    df = df[cols].copy()
    # rename columns with values of dict
    df.columns = [dict[col] for col in df.columns]
    
    return df

