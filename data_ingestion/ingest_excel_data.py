import os, openpyxl, sys
import pandas as pd, numpy as np
file_path = r'D:\working\data_projects\converted'
save_path = r'D:\my_fin_project\data_ingestion\data'

def get_sheet1_data(file_path, file_name):
    try:
        header = ['No','Date','Code','Desc','Credit','Debit','Balance']
        df = pd.read_excel(f'{file_path}\{file_name}.xlsx', sheet_name='Sheet1', engine='openpyxl',skiprows=1,header=None)
        df.columns = header
        df['Desc'] = df['Desc'].str.replace('\n', ' ', regex=False) 
        df['Desc'] = df['Desc'].str.replace('\r', ' ', regex=False)  
        return df
    except Exception as e:
        print(f'Error: {e}')
        
def get_first_row(file_path, file_name):
    try:
        df = pd.read_excel(f'{file_path}\{file_name}.xlsx', sheet_name='Sheet1', engine='openpyxl',header=0)
        first_transdate = str(df['STT/No'][0].astype(str))
        return first_transdate
    except Exception as e:
        print(f'Error: {e}')

def get_sheet_list(file_path, file_name):
    xls = pd.ExcelFile(f'{file_path}\{file_name}.xlsx')
    sheet_list= xls.sheet_names[1:]
    return sheet_list

def save_ingest_data(file_path, file_name):
    try:
        get_sheet1_data(file_path, file_name).to_csv(os.path.join(save_path,f'ingest_data_{get_first_row(file_path, file_name)}.csv'), index=False)
        for sheet in get_sheet_list(file_path, file_name):
            df = pd.read_excel(f'{file_path}\{file_name}.xlsx', sheet_name=sheet, engine='openpyxl',skiprows=1, header=None)
            df.iloc[:,3]= df.iloc[:,3].str.replace('\n', ' ', regex=False) 
            df.iloc[:,3] = df.iloc[:,3].str.replace('\r', ' ', regex=False)  
            df.to_csv(os.path.join(save_path,f'ingest_data_{get_first_row(file_path, "test")}.csv'),mode='a', index=False,header=False)
            print(f'{sheet} has been ingested to {save_path}')
    except Exception as e:
        print(f'Error: {e}')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python ingest_excel_data.py <file_name>")
        sys.exit(1)
    
    file_name = sys.argv[1]

save_ingest_data(file_path, file_name)  