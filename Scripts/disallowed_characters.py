import re
import os

allowed_patterns = re.compile(r'^[A-ZÁÉÍÓÚÑa-záéíóúñüï.,:;?¿!\'"¡\s\-\─\−–]+$')

# Get the name of the source file from user input
entrada = input("Enter the name of the source file/folder: ")

# Request the name of the "Valid files" folder
valid_dir = input("Enter the path of the Valid files folder: ")

# Request the name of the "Invalid files" folder
invalid_dir = input("Enter the path of the Invalid files folder: ")

# Create output folders if necessary
os.makedirs(valid_dir, exist_ok=True)
os.makedirs(invalid_dir, exist_ok=True)

def process_file(input_file, valid_file, invalid_file):
    with open(input_file, 'r', encoding='utf-8') as file_entrada, \
         open(valid_file, 'w', encoding='utf-8') as file_validas, \
         open(invalid_file, 'w', encoding='utf-8') as file_invalidas:

        for line in file_entrada:
            line = line.strip()
            if allowed_patterns.match(line):
                file_validas.write(f"{line}\n")
            else:
                file_invalidas.write(f"{line}\n")

# Check if the input is a file or a folder
if os.path.isfile(entrada):
    # Process a file
    nombre_archivo = os.path.basename(entrada)
    valid_file = os.path.join(valid_dir, f'{nombre_archivo}_validas.txt')
    invalid_file = os.path.join(invalid_dir, f'{nombre_archivo}_invalidas.txt')
    process_file(entrada, valid_file, invalid_file)
else:
    # Process a folder
    for archivo_nombre in os.listdir(entrada):
        input_file = os.path.join(entrada, archivo_nombre)
        valid_file = os.path.join(valid_dir, f'{archivo_nombre}_validas.txt')
        invalid_file = os.path.join(invalid_dir, f'{archivo_nombre}_invalidas.txt')
        process_file(input_file, valid_file, invalid_file)

print("Done.")
