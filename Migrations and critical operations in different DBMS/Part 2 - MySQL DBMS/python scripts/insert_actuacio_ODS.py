# ==========================================================================================================
#                                       Mario Ventura Burgos - 43223476J
#                           Sistemas de gestión de bases de datos - proyecto final
#                   Script de tratamiento de fichero ODS para inserción en base de datos
# ==========================================================================================================
# ==================== TABLA SOBRE LA QUE SE TRABAJARÁ ---> ACTUACIO
# ==========================================================================================================

# Importar las bibliotecas necesarias
from pandas_ods_reader import read_ods
import mysql.connector
from mysql.connector import errorcode
from unidecode import unidecode

# Función para generar la sentencia INSERT en SQL
def generate_insert(nameDB, path):
    # Leer el archivo ODS
    df = read_ods(path)
    df = df.loc[:, ~df.columns.str.contains('^unnamed')]
    # Obtener los nombres de todas las columnas
    nombres_columnas = df.columns.tolist()
    print(nombres_columnas)
    # Construir la sentencia INSERT en SQL
    sql = f"INSERT INTO {nameDB} ({', '.join(nombres_columnas)}) VALUES " + "\n"
    # Reemplazar comillas simples en el DataFrame
    df = df.replace("'", "\\'", regex=True)
    # Iterar sobre las filas del DataFrame
    for index, row in df.iterrows():
        insert = "("
        # Iterar sobre las columnas
        for column in nombres_columnas:
            value = row[column]
            # Verificar el tipo del valor y construir la parte de la sentencia INSERT
            if value is None or value == " ":
                insert += f"NULL"','
            elif isinstance(value, str):
                insert += f"'{value}',"
            else:
                insert += f"{int(value)},"
        # Eliminar la coma final y agregar el paréntesis de cierre
        insert = insert.rstrip(',') + ")"
        sql += insert + ',' + '\n' if index < len(df) - 1 else insert + '\n'
    
    # Eliminar la coma final y agregar el punto y coma al final de la sentencia INSERT
    sql = sql.rstrip(',') + ";"
    
    # Escribir la sentencia SQL en un archivo o realizar alguna operación
    writeSQL(sql)

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

# Ruta del archivo ODS
path = "ACTUACIONS.ods"
table_name = "ACTUACIO"
# Llamar a la función para generar la sentencia INSERT y escribir en la base de datos
generate_insert(table_name, path)
