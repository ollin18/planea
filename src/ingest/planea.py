#!/usr/bin/env python3
import pandas as pd
import urllib.request
from pandas.io.sql import get_schema

url='http://planea.sep.gob.mx/content/ba/docs/2019/base_de_datos/nac_escuelas_peb2019.xlsx'
urllib.request.urlretrieve(url, '/data/raw/planea_sec_2019.xlsx')

colnames = ["ent",
        "entidad",
        "escuela",
        "clave",
        "turno",
        "municipio",
        "localidad",
        "tipo_escuela",
        "grado",
        "marginacion",
        "alumnos_programados",
        "evaluados_len",
        "evaluados_mat",
        "porc_len",
        "porc_mat",
        "repre_len",
        "repre_mat",
        "escuelas_similares",
        "I_total_len",
        "II_total_len",
        "III_total_len",
        "IV_total_len",
        "I_porc_len",
        "II_porc_len",
        "III_porc_len",
        "IV_porc_len",
        "I_similar_len",
        "II_similar_len",
        "III_similar_len",
        "IV_similar_len",
        "I_total_mat",
        "II_total_mat",
        "III_total_mat",
        "IV_total_mat",
        "I_porc_mat",
        "II_porc_mat",
        "III_porc_mat",
        "IV_porc_mat",
        "I_similar_mat",
        "II_similar_mat",
        "III_similar_mat",
        "IV_similar_mat"
        ]

df = pd.read_excel("/data/raw/planea_sec_2019.xlsx", skiprows=4, header=None, engine="openpyxl")
df.columns = colnames
df.ent = df.ent.map(int).map(lambda x: str(x).zfill(2))
df.to_csv("/data/clean/planea.csv",sep="|",index=False)

schema = get_schema(df,'planea')
with open("/data/clean/planea.sql", "w") as text_file:
    text_file.write(schema)
