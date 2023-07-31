#!/bin/bash

# Get the name of the source file from user input
read -p "Enter the name of the source file: " filename

# Add the new command to redirect lines with characters not present in the specified group
awk '/[^A-ZÁÉÍÓÚÑa-záéíóúñü\s\.,;:"'\''?!¿¡\-\─\–\$]/ { print NR ":" $0 }' "$filename" > "${filename}_other_characters.txt"

# Create a list of unique line numbers with disallowed characters
cut -d: -f1 "${filename}_other_characters.txt" | sort -n | uniq > "disallowed_line_numbers.txt"

# Extract the lines with disallowed characters from the original file and save them to a new file
awk 'NR==FNR{a[$0];next} FNR in a' "disallowed_line_numbers.txt" "$filename" > "${filename}_lines_with_disallowed_characters.txt"

# Remove the temporary files
rm "disallowed_line_numbers.txt" "${filename}_other_characters.txt"

# Create a list of characters identified in the "${filename}_other_characters.txt" file
grep -o '[^A-ZÁÉÍÓÚÑa-záéíóúñü\s\.,;:"'\''?!¿¡\-\─\–\$]' "${filename}_lines_with_disallowed_characters.txt" | sort | uniq > "disallowed_characters_list.txt"

echo "Finished"