import re
import os

patron_permitido = re.compile(r'^[A-ZÁÉÍÓÚÑa-záéíóúñüï.,:;?¿!\'"¡\s\-\─\−–]+$')

# Solicitar la ubicación de la carpeta o archivo de entrada
entrada = input("Ingrese la ubicación de la carpeta o archivo de entrada: ")

# Solicitar la ubicación de la carpeta para archivos válidos
carpeta_validas = input("Ingrese la ubicación de la carpeta para archivos válidos: ")

# Solicitar la ubicación de la carpeta para archivos inválidos
carpeta_invalidas = input("Ingrese la ubicación de la carpeta para archivos inválidos: ")

# Crear las carpetas de salida si no existen
os.makedirs(carpeta_validas, exist_ok=True)
os.makedirs(carpeta_invalidas, exist_ok=True)

def procesar_archivo(archivo_entrada, archivo_validas, archivo_invalidas):
    with open(archivo_entrada, 'r', encoding='utf-8') as file_entrada, \
         open(archivo_validas, 'w', encoding='utf-8') as file_validas, \
         open(archivo_invalidas, 'w', encoding='utf-8') as file_invalidas:

        for linea in file_entrada:
            linea = linea.strip()
            if patron_permitido.match(linea):
                file_validas.write(f"{linea}\n")
            else:
                file_invalidas.write(f"{linea}\n")

# Verificar si la entrada es un archivo o una carpeta
if os.path.isfile(entrada):
    # Procesar un archivo
    nombre_archivo = os.path.basename(entrada)
    archivo_validas = os.path.join(carpeta_validas, f'{nombre_archivo}_validas.txt')
    archivo_invalidas = os.path.join(carpeta_invalidas, f'{nombre_archivo}_invalidas.txt')
    procesar_archivo(entrada, archivo_validas, archivo_invalidas)
else:
    # Procesar una carpeta
    for archivo_nombre in os.listdir(entrada):
        archivo_entrada = os.path.join(entrada, archivo_nombre)
        archivo_validas = os.path.join(carpeta_validas, f'{archivo_nombre}_validas.txt')
        archivo_invalidas = os.path.join(carpeta_invalidas, f'{archivo_nombre}_invalidas.txt')
        procesar_archivo(archivo_entrada, archivo_validas, archivo_invalidas)

print("Proceso completado. Archivos creados en las carpetas proporcionadas.")
