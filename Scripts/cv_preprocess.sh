#!/bin/bash

# Get the name of the source file from user input
read -p "Enter the name of the source file: " filename

# Leading and trailing space/tab deletion
sed -i 's/^[ \t]*//' "$filename"
sed -i 's/[ \t]*$//' "$filename"
#sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' "$filename"

# Double space deletion
sed -i 's/  / /g' "$filename"
sed -i 's/[ \t][ \t]*/ /g' "$filename"

# Space before punctuation deletion
sed -i 's/\s\([,.?!:;]\)/\1/g' "$filename"

# Replace … with ... and non-breaking space with regular space
sed -i 's/…/.../g' "$filename"
sed -i 's/ / /g' "$filename"

# Replace long dash with short dash
sed -i -e 's/—/-/g' -e 's/――/-/g' "$filename"

# Replace all double quotation marks with straight double quotation marks
sed -i -e 's/«/"/g' -e 's/»/"/g' -e 's/“/"/g' -e 's/”/"/g' -e 's/„/"/g' -e 's/“/"/g' -e 's/„/"/g' -e 's/‟/"/g' -e 's/‹/"/g' -e 's/›/"/g' "$filename"

# Replace common abbreviations
sed -i.bak -e 's/D\./Don/g; s/Dna\./Dona/g; s/Sr\./Señor/g; s/Sra\./Señora/g; s/Mr\./Señor/g; s/Mrs\./Señora/g; s/Prof\./Profesor/g; s/Dir\./Director/g; s/Tlf\./Teléfono/g; s/Tel\./Teléfono/g; s/Vol\./Volume/g; s/Cía\./Compañía/g; s/Fco\./Francisco/g; s/Fdez\./Fernández/g; s/Dr\./Doutor/g; s/Dra\./Doutora/g; s/Núm\./Número/g; s/Fdo\./Asinado/g; s/Asdo\./Asinado/g; s/Dña\./Dona/g; s/Soc\./Sociedade/g; s/Coop\./Cooperativa/g; s/Dir\./Diretor/g; s/Sta\./Santa/g; s/St\./Santo/g; s/Ms\./Señora/g; s/Jr\./Junior/g; s/Sr\./Senior/g; s/Co\./Compañía/g; s/Av\./Avenida/g; s/Avda\./Avenida/g; s/Ed\.//g; s/Mt\.//g; s/Edic\./Edicións/g; s/•//g; s/a\.C\./antes de Cristo/g; s/d\.C\./despois de Cristo/g' "$filename"

# Line splitting (excluding cases of single capital letter)
sed 's/\([.!?—]\) \([[:upper:]][^.]\)/\1\n\2/g' "$filename" > "${filename}_lines.txt"
sed -i 's/\([.?!—]\) "\([[:upper:]][^.]\)/\1\n"\2/g' "${filename}_lines.txt"
sed -i -r 's/ ([¿!])([A-Z_ÁÉÍÓÚÑ])/\n\1\2/g' "${filename}_lines.txt"

#Line splitting for CRTVG (lowercase, full stop-no space-, uppercase)
sed -i -r 's/([a-záéíóúñ]\.)([A-ZÁÉÍÓÚÑ])/\1\n\2/g' "${filename}_lines.txt"

# Replace all ?. !. ., ,? ,!
sed -i -r 's/(\?\.|!\.|,\.)/\./g' "${filename}_lines.txt"
sed -i -r 's/(,\?|,\!)/,/g' "${filename}_lines.txt"

# Extract lines with a maximum of 14 words
awk 'NF<=14' "${filename}_lines.txt" > "${filename}_lines_14.txt"

# Extract lines with ellipsis in the middle of the sentence ("A mesa...quedáballe un pouco lonxe.")
grep -E '/\.\.\.[a-záéíóúñA-ZÁÉÍÓUÚÑ]/' "${filename}_lines_14.txt" > "${filename}_ellipsis.txt"
sed -i '/\.\.\.[a-záéíóúñA-ZÁÉÍÓUÚÑ]/d' "${filename}_lines_14.txt"

# Extract lines with disallowed roots to a new file and delete them from the source file
grep -i -f "regex_patterns.txt" "${filename}_lines_14.txt" > "${filename}_disallowed.txt"
grep -v -f "${filename}_disallowed.txt" "${filename}_lines_14.txt" > "${filename}_temp.txt"
mv "${filename}_temp.txt" "${filename}_lines_14.txt"

# Specific cases: Delete lines ending in lowercase dash
#sed -i '/[a-z]-$/d' "${filename}_lines_14.txt"

# Specific cases: Extract lines with lowercase dash (space) lowercase / uppercase and delete them from the source file
#sed -n -e '/[a-z]-[[:space:]]\?[a-záéíóúA-ZÁÉÍÓÚ]/{w '"${filename}_guions.txt"' -e 'd;}' "${filename}_lines_14.txt" && sed -i '/[a-z]-[[:space:]]\?[a-záéíóúA-ZÁÉÍÓÚ]/d' "${filename}_lines_14.txt"

# Delete lines with fewer than 4 characters
sed -i '/^.\{1,4\}$/d' "${filename}_lines_14.txt"

# Extract lines with acronyms to a new file and delete them from the source file
grep -E '([A-Z_ÁÉÍÓÚÑ]+\.*[A-Z_ÁÉÍÓÚÑ]|[A-Z_ÁÉÍÓÚÑ]\.$|[A-Z_ÁÉÍÓÚÑ][A-Z_ÁÉÍÓÚÑ]+|[A-Za-záéíóúñ]*[A-Z][A-Za-záéíóúñ]*[A-Z][A-Za-záéíóúñ]*|[A-Za-záéíóúñ]*[A-Z_ÁÉÍÓÚÑ][A-Za-záéíóúñ]*[A-Z_ÁÉÍÓÚÑ][A-Za-záéíóúñ]*|[A-Z_ÁÉÍÓÚÑ]\.$|.*[A-Z_ÁÉÍÓÚÑ]\.$|^[A-Z_ÁÉÍÓÚÑ ]+$|\([A-ZÁÉÍÓÚÑ]+\)|[A-ZÁÉÍÓÚÑ]\.+|[a-záéíóúñ]+[A-ZÁÉÍÓÚÑ]+|[A-ZÁÉÍÓÚÑa-záéíóúñ]\.\x20?[a-záéíóúñ]+)' "${filename}_lines_14.txt" | cut -d$'\n' -f1- > "${filename}_abbrev.txt"
sed -i -r '/([A-Z_ÁÉÍÓÚÑ]+\.*[A-Z_ÁÉÍÓÚÑ]|[A-Z_ÁÉÍÓÚÑ]\.$|[A-Z_ÁÉÍÓÚÑ][A-Z_ÁÉÍÓÚÑ]+|[A-Za-záéíóúñ]*[A-Z][A-Za-záéíóúñ]*[A-Z][A-Za-záéíóúñ]*|[A-Za-záéíóúñ]*[A-Z_ÁÉÍÓÚÑ][A-Za-záéíóúñ]*[A-Z_ÁÉÍÓÚÑ][A-Za-záéíóúñ]*|[A-Z_ÁÉÍÓÚÑ]\.$|.*[A-Z_ÁÉÍÓÚÑ]\.$|^[A-Z_ÁÉÍÓÚÑ ]+$|\([A-ZÁÉÍÓÚÑ]+\)|[A-ZÁÉÍÓÚÑ]\.+|[a-záéíóúñ]+[A-ZÁÉÍÓÚÑ]+|[A-ZÁÉÍÓÚÑa-záéíóúñ]\.\x20?[a-záéíóúñ]+)/d' "${filename}_lines_14.txt"

# Clean acronyms file (delete all caps lines and lines with one capital letter followed by a full stop at the end of line; delete all lines with numbers)
sed -i '/^[[:upper:][:punct:][:space:]]*$/d; /[[:upper:]]\.$/d' "${filename}_abbrev.txt"
sed -i '/[0-9]/d' "${filename}_abbrev.txt"

# Extract lines with numbers to a new file and delete them from the source file
grep '/[0-9]/' "${filename}_lines_14.txt" | cut -d$'\n' -f1- > "${filename}_numbers.txt"
sed -i '/[0-9]/d' "${filename}_lines_14.txt"

# Extract lines with an odd number of quotation marks to a new file
awk 'BEGIN{FS=""}{count=0;for(i=1;i<=NF;i++){if($i=="\""){count++}}if(count%2==1){print}}' "${filename}_lines_14.txt" > "${filename}_odd_double_quotes.txt"
awk 'BEGIN{FS=""}{count=0;for(i=1;i<=NF;i++){if($i=="'\''"){count++}}if(count%2==1){print}}' "${filename}_lines_14.txt" > "${filename}_odd_single_quotes.txt"
cat "${filename}_odd_double_quotes.txt" "${filename}_odd_single_quotes.txt" > "${filename}_odd_quotes.txt"
rm "${filename}_odd_double_quotes.txt"
rm "${filename}_odd_single_quotes.txt"
#sed -i '/\"/d' "${filename}_lines_14.txt"

# Delete lines that match "${filename}_odd_quotes.txt" from the source file
#grep -v -f "${filename}_odd_quotes.txt" "${filename}_lines_14.txt" > "${filename}_preprocessed.txt"

# Escape special characters in the odd quotes file and save it to a temporary file
sed 's/[][()\.?*+^$|]/\\&/g' "${filename}_odd_quotes.txt" > "${filename}_odd_quotes_escaped.txt"

# Delete lines that match the escaped patterns from the source file
grep -v -f "${filename}_odd_quotes_escaped.txt" "${filename}_lines_14.txt" > "${filename}_preprocessed.txt"

# Remove the temporary file
rm "${filename}_odd_quotes_escaped.txt"

# Extract lines ending in lowercase not followed by punctuation and delete from source file
grep -E '^.*[^\.!\?:\"]$' "${filename}_preprocessed.txt" > "${filename}_finalpunct.txt"
sed -i -r '/^.*[^\.!\?:\"]$/d' "${filename}_preprocessed.txt"

# Delete blank lines from the preprocessed file
sed -i '/^[[:space:]]*$/d' "${filename}_preprocessed.txt"

# Delete repeated lines from the preprocessed file
awk '!seen[$0]++' "${filename}_preprocessed.txt" > "${filename}_temp.txt"
mv "${filename}_temp.txt" "${filename}_preprocessed.txt"

# Check that all sentences are 14 words or fewer
#grep -E '\b(\w+\b\s+){14,}\w+[.?!]' "${filename}_preprocessed.txt" > longer.txt

# Move all the files generated by the script to a new folder with the same name as the source file
output_folder="${filename}_output"
mkdir "$output_folder"
mv "${filename}_lines.txt" "${filename}_lines_14.txt" "${filename}_ellipsis.txt" "${filename}_disallowed.txt" "${filename}_abbrev.txt" "${filename}_numbers.txt" "${filename}_odd_quotes.txt" "${filename}_finalpunct.txt" "${filename}_preprocessed.txt" "$output_folder/"

echo "Finished"
