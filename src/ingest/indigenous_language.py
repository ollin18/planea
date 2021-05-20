#!/usr/bin/env python3
import pandas as pd
import urllib.request
from pandas.io.sql import get_schema

url='http://www.inpi.gob.mx/cedulas/poblacion-indigena-municipal-2010.xls'
urllib.request.urlretrieve(url, '/data/raw/indigenous_language.xlsx')

df = pd.read_excel("/data/raw/indigenous_language.xlsx", skiprows=0, sheet_name="COMPARATIVO 2010")
df = df.loc[(~df.NOMMUN.isin(["Estados Unidos Mexicanos", "Total Estatal"])) & (~df.MPO.isnull())]
df.MPO = df.MPO.map(int).map(lambda x: str(x).zfill(3))

df.to_csv("/data/clean/indigenous_language.csv",sep="|",index=False)

schema = get_schema(df,'indigenous_language')
with open("/data/sql/indigenous_language.sql", "w") as text_file:
    text_file.write(schema)
