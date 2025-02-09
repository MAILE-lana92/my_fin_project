import os, openpyxl, sys
import pandas as pd, numpy as np

seed_file =  r"D:\my_fin_project\seeds\base_transaction.csv"
backup_file = r"D:\my_fin_project\seeds\base_transaction_backup.csv"
ingested_file_path = r"D:\my_fin_project\data_ingestion\data"

def read_backup_data(backup_file):
    try:
        backup_data = pd.read_csv(backup_file, skiprows= 1, header=None)
        backup_data.iloc[:,1] = backup_data.iloc[:,1].astype('datetime64[ns]').dt.strftime('%Y-%m-%d')
        return backup_data
    except Exception as e:
        print(f'Error: {e}')

def refresh_seed_file(seed_file):
    header = pd.read_csv(seed_file).columns
    new_df = pd.DataFrame(columns=header)
    new_df.to_csv(seed_file, index=False)

def append_backup_data(seed_file, backup_file):
    backup_data = read_backup_data(backup_file)
    refresh_seed_file(seed_file)
    backup_data.to_csv(seed_file, mode= 'a', index=False, header=False)

def append_ingested_data(seed_file, ingested_file_path, file_name):
    df = pd.read_csv(f'{ingested_file_path}\{file_name}.csv', skiprows=1, header=None)
    df.iloc[:,1] = df.iloc[:,1].astype('datetime64[ns]').dt.strftime('%Y-%m-%d')
    df.to_csv(seed_file, mode='a', index=False, header=False)

def main(seed_file, backup_file, ingested_file_path, file_name):
    refresh_seed_file(seed_file)
    append_backup_data(seed_file, backup_file)
    append_ingested_data(seed_file, ingested_file_path, file_name)
    print(f'{file_name} has been ingested to {seed_file}')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python ingest_excel_data.py <file_name>")
        sys.exit(1)
    
    file_name = sys.argv[1]

main(seed_file, backup_file, ingested_file_path, file_name)