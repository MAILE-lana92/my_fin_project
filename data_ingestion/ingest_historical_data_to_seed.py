import os, openpyxl, sys
from os import listdir
import pandas as pd, numpy as np

file_path = r"D:\working\data_projects\converted\three_years_history"
save_path = r"D:\my_fin_project\seeds\base_transaction.csv"
header = ['No','Date','Code','Desc','Credit','Debit','Balance']

file_list = os.listdir(file_path)

def concat_df(file_path, save_path):
    df = pd.DataFrame(columns= header)
    df.to_csv(save_path, index= False)
    for file in file_list:
        sheets = pd.ExcelFile(os.path.join(file_path, file)).sheet_names
        print(os.path.join(file_path, file))
        for sheet in sheets:
            try:
                df_batch = pd.read_excel(os.path.join(file_path, file), sheet_name= sheet, skiprows= 1, header= None)
                df_batch.columns = header
                df = pd.concat([df, df_batch], ignore_index= True)
            except Exception as e:
                print(f'Error: {e}')
                print(f'fail in concate file {file} and sheet {sheet}')
        
    return df
        
def clean_df(df_concat):
    # dedup dataframe
    df_dedup = df_concat.drop_duplicates(subset= ['Date','Code','Desc', 'Credit', 'Credit'], keep= 'first') 
    # remove records with invalid value                                                                                                                                                                                               
    df = df_dedup[df_dedup['Balance'].notnull()]
    df = df[df['Date'] != 'Ngày/Date'] 
    df = df[df['Date'] != 'NgàylDate' ] 
    # convert not NA value to numeric
    df['No'] = df['No'].apply(lambda x: pd.to_numeric(x, errors='coerce'))
    # with value NaN in row n, replace by value in row n - 1
    df['No'] = df['No'].ffill() + df['No'].isnull().astype(int)
    # convert Date column to correct date format
    # df['Date'] = df['Date'].astype('datetime64[ns]').dt.strftime('%Y-%m-%d')
    df['Date'] = df['Date'].astype('datetime64[ns]').dt.strftime('%d-%m-%Y')
    df['Date'] = df['Date'].astype('datetime64[ns]').dt.strftime('%Y-%m-%d')
    # remove invalue characters in convert Credit, Debit. Balance columns into int
    df['Credit'] = df['Credit'].astype(str).str.replace(r'[^0-9]', '', regex=True).apply(lambda x: int(x) if x.isdigit() else 0)
    df['Debit'] = df['Debit'].astype(str).str.replace(r'[^0-9]', '', regex=True).apply(lambda x: int(x) if x.isdigit() else 0)
    df['Balance'] = df['Balance'].astype(str).str.replace(r'[^0-9]', '', regex=True).apply(lambda x: int(x) if x.isdigit() else 0)
    # replace Enter pattern with ' '
    df['Desc'] = df['Desc'].replace('\n', ' ', regex= True)
    return df

def ingest_historical_data(file_path, save_path):
    try:
        df_concat = concat_df(file_path, save_path)
        print('success to concat file')
    except Exception as e:
        print(f'Error: {e}')
        print('fail in append file')

    try:
        df = clean_df(df_concat)
        print('success to clean file')
    except Exception as e:
        print(f'Error: {e}')
        print('fail in clean file')
    
    try:
        df.to_csv(save_path, index= False)
        print('success to export file')
    except Exception as e:
        print(f'Error: {e}')
        print('fail in export to csv')


ingest_historical_data(file_path, save_path)