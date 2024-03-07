# ==========================================================================================================
#                                       Mario Ventura Burgos - 43223476J
#                           Sistemas de gestión de bases de datos - proyecto final
#                   Script de tratamiento de fichero CSV para inserción en base de datos
# ==========================================================================================================
# ==================== TABLA SOBRE LA QUE SE TRABAJARÁ ---> ESDEVENIMENT
# ==========================================================================================================

import time
import pandas as pd
import mysql.connector
from mysql.connector import errorcode

# Función para generar la sentencia INSERT en SQL con carga por lotes
def generate_insert(nameDB, path):
    tamano_lote = 250000  # Tamaño del lote de inserción
    contador = 0

    # Iterar sobre el archivo CSV en lotes
    for chunk in pd.read_csv(path, chunksize=tamano_lote):
        # Obtener los nombres de todas las columnas
        nombres_columnas = chunk.columns.tolist()
        chunk = chunk.replace("'", "\\'", regex=True)
        # Construir la sentencia INSERT en SQL
        sql = f"INSERT INTO {nameDB} ({', '.join(nombres_columnas)}) VALUES " + "\n"
        count = 0  # Contador de filas procesadas en el lote
        # Iterar sobre las filas del lote
        for index, row in chunk.iterrows():
            insert = "("
            # Iterar sobre las columnas
            for column in nombres_columnas:
                value = row[column]
                # Verificar el tipo del valor y construir la parte de la sentencia INSERT
                if pd.isna(value) or value == " ":
                    insert += "NULL,"
                elif isinstance(value, str):
                    insert += f"'{value}',"
                else:
                    insert += f"{int(value)},"
            # Eliminar la coma final y agregar el paréntesis de cierre
            count += 1
            insert = insert.rstrip(',') + ")"
            sql += insert + ',' + '\n' if count < len(chunk) else insert + '\n'
        # Eliminar la coma final y agregar el punto y coma al final de la sentencia INSERT
        sql = sql.rstrip(',') + ";"
        # Escribir la sentencia SQL y realizar operaciones adicionales
        writeSQL(sql)
        #print(sql)
        time.sleep(5)  # Simular una pausa de 5 segundos entre lotes
        contador+=1
        print("LOTE NUMERO ",contador, " INSERTADO. TOTAL APROXIMADO INSERTADO: ", contador*tamano_lote)

# Función para escribir la sentencia SQL y ejecutarla
def writeSQL(sql):
    global cursor, cnx
    try:
        # Conectar a la base de datos MySQL
        cnx = mysql.connector.connect(user='IMPBD', password='impbd_user_passwd', host='localhost', database='IMPBD')
        cursor = cnx.cursor()
        # Ejecutar la sentencia SQL
        cursor.execute(sql)
        cnx.commit()
    except mysql.connector.Error as err:
        # Manejar los errores de conexión o ejecución de SQL
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Algo está mal con tu nombre de usuario o contraseña")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("La base de datos no existe")
        else:
            print(err)
    finally:
        # Imprimir un mensaje de éxito y cerrar la conexión y el cursor
        print("Operación completada con éxito")
        cursor.close()
        cnx.close()

# Ruta del archivo CSV
path = "esdeveniments.csv"
table_name = "esdeveniment"

# Llamar a la función para generar la sentencia INSERT y escribir en la base de datos
generate_insert(table_name, path)
