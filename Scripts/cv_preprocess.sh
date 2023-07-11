#!/bin/bash

# Get the name of the source file from user input
read -p "Enter the name of the source file: " filename

# Leading and trailing space/tab deletion
sed -i 's/^[ \t]*//' "$filename"
sed -i 's/[ \t]*$//' "$filename"
#OPTION sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' "$filename"

# Double space deletion
#sed -i 's/  / /g' "$filename"
sed -i 's/[ \t][ \t]*/ /g' "$filename"

# Space before punctuation deletion
sed -i 's/\s\([,.?!:;]\)/\1/g' "$filename"

# Replace … with ... and non-breaking space with regular space
sed -i 's/…/.../g' "$filename"
sed -i 's/ / /g' "$filename"

# Replace long dash with short dash
sed -i 's/—/-/g' "$filename"

# Replace all double quotation marks with straight double quotation marks
sed -i -e 's/«/"/g' -e 's/»/"/g' -e 's/“/"/g' -e 's/”/"/g' -e 's/„/"/g' -e 's/“/"/g' -e 's/„/"/g' -e 's/‟/"/g' -e 's/‹/"/g' -e 's/›/"/g' "${filename}.txt"

# Line splitting (excluding cases of single capital letter)
sed 's/\([.!?—]\) \([[:upper:]]\)/\1\n\2/g' "$filename" > "${filename}_lines.txt"
sed -i 's/\([.?!—]\) "\([[:upper:]]\)/\1\n"\2/g' "${filename}_lines.txt"
sed -i -r 's/ ([¿!])([A-Z_ÁÉÍÓÚÑ])/\n\1\2/g' "${filename}_lines.txt"

#Line splitting for CRTVG (lowercase, full stop-no space-, uppercase)
sed -i -r 's/([a-záéíóúñ]\.)([A-ZÁÉÍÓÚÑ])/\1\n\2/g' "${filename}_lines.txt"

# Replace all ?. !. ., ,? ,!
sed -i -r 's/(\?\.|!\.|,\.)/\./g' "${filename}_lines_14.txt"
sed -i -r 's/(,\?|,\!)/,/g' "${filename}_lines_14.txt"

# Extract lines with a maximum of 14 words
awk 'NF<=14' "${filename}_lines.txt" > "${filename}_lines_14.txt"

# Extract lines with ellipsis in the middle of the sentence ("A mesa...quedáballe un pouco lonxe.")
#sed -i -r '[...][a-záéíóúñA-ZÁÉÍÓUÚÑ]' "${filename}_lines_14.txt" > "${filename}_ellipsis.txt"
#sed -i '[...][a-záéíóúñA-ZÁÉÍÓUÚÑ]' "${filename}_lines_14.txt"

# Extract lines with disallowed roots to a new file and delete them from the source file
grep -E -i '\b(?!Morte\b)(\breanim\w*\b|\bacab\w+\b\s*\b\w*a\b\s*\bvida\b|\bmaltrat\w*\b|\b\w*coitela\w*\b|\b\w*icidio\w*\b|\b\w*maric\w*\b|\b\w*puñal\w*\b|\b\w*sangr\w*\b|\b\w*sexual\w*\b|\b\w*terror\w*\b|\babus\w*\b|\bacab\w*\b coa \w* vida\b|\bafog\w*\b|\baforc\w*\b|\baparec\w*\b \w* corpo\w*\b|\basalt\w*\b|\basasin\w*\b|\basfix\w*\b|\bataud\w*\b|\bataúd\w*\b|\batop\w*\b \w* corpo\w*\b|\bautopsi\w*\b|\bbomba\w*\b|\bcadáver\w*\b|\bcaga\w*\b|\bcarall\w*\b|\bcargo d\w* corpo\w*\b|\bcrime\w*\b|\bcrimin\w*\b|\bcusp\w*\b|\bdecapit\w*\b|\bdegol\w*\b|\bdesaparec\w*\b|\bdrog\w*\b|\bensangue\b|\bestrangul\w*\b|\bfacha\b|\bfachas\b|\bfalec\w*\b|\bfascis\w*\b|\bfod\w*\b|\bjod\w*\b|\bfuner\w*\b|\bfusil\w*\b|\bidiot\w*\b|\bimbecil\w*\b|\bimbécil\w*\b|\bmalos tratos\b|\bmata\w*\b|\bmatá\w*\b|\bmorr\w*\b|\bmort\w*\b|\bmutil\w*\b|\bnarco\w*\b|\bpatada\w*\b|\bpenetr\w*\b|\bpornogr\w*\b|\bprisión permanente revisable\b|\bprostitu\w*\b|\bputa\w*\b|\bputeir\w*\b|\bpuñal\b|\bpuñazo\w*\b|\bquit\w*\b \w* vida\w*\b|\bsangue\b|\bsen vida\b|\bsepult\w*\b|\bsuicid\w*\b|\btiro\b|\btiros\b|\btirote\w*\b|\btortur\w*\b|\bvaxin\w*\b|\bviola\w*\b|\bviolá\w*\b|\bvulv\w*\b|\bvítim\w*\b|\bzorra\w*\b|\bóso\w*\b|\b\w*abort\w*\b|\babus\w*\b|\bmutil\w*\b|\batentad\w*\b|\batrop\w*\b|\bagres\w*\b|\bcona\w*\b|\b\w*velen\w*\b|\bescrav\w*\b|\bDaesh\b|\b Dáesh \b|\b Daish \b|\betarr\w*\b|\bestado islámico\b|\bisis\b|\blapid\w*\b|\bcag\w*\b|\bcocaína\b|\bextermin\w*\b|\bHitler\b|\bHolocausto\b|\bsubnorm\w*\b|\bgilipoll\w*\b|\bcabrón\w*\b|\bcabron\w*\b|\btont\w*\b|\bestúpid\w*\b|\bparv\w*\b|\bcapull\w*\b|\bretrasad\w*\b|\binválid\w*\b|\bdiscapacitad\w*\b)' "${filename}_lines_14.txt" > "${filename}_disallowed.txt"
sed -i '\b(?!Morte\b)(\breanim\w*\b|\bacab\w+\b\s*\b\w*a\b\s*\bvida\b|\bmaltrat\w*\b|\b\w*coitela\w*\b|\b\w*icidio\w*\b|\b\w*maric\w*\b|\b\w*puñal\w*\b|\b\w*sangr\w*\b|\b\w*sexual\w*\b|\b\w*terror\w*\b|\babus\w*\b|\bacab\w*\b coa \w* vida\b|\bafog\w*\b|\baforc\w*\b|\baparec\w*\b \w* corpo\w*\b|\basalt\w*\b|\basasin\w*\b|\basfix\w*\b|\bataud\w*\b|\bataúd\w*\b|\batop\w*\b \w* corpo\w*\b|\bautopsi\w*\b|\bbomba\w*\b|\bcadáver\w*\b|\bcaga\w*\b|\bcarall\w*\b|\bcargo d\w* corpo\w*\b|\bcrime\w*\b|\bcrimin\w*\b|\bcusp\w*\b|\bdecapit\w*\b|\bdegol\w*\b|\bdesaparec\w*\b|\bdrog\w*\b|\bensangue\b|\bestrangul\w*\b|\bfacha\b|\bfachas\b|\bfalec\w*\b|\bfascis\w*\b|\bfod\w*\b|\bjod\w*\b|\bfuner\w*\b|\bfusil\w*\b|\bidiot\w*\b|\bimbecil\w*\b|\bimbécil\w*\b|\bmalos tratos\b|\bmata\w*\b|\bmatá\w*\b|\bmorr\w*\b|\bmort\w*\b|\bmutil\w*\b|\bnarco\w*\b|\bpatada\w*\b|\bpenetr\w*\b|\bpornogr\w*\b|\bprisión permanente revisable\b|\bprostitu\w*\b|\bputa\w*\b|\bputeir\w*\b|\bpuñal\b|\bpuñazo\w*\b|\bquit\w*\b \w* vida\w*\b|\bsangue\b|\bsen vida\b|\bsepult\w*\b|\bsuicid\w*\b|\btiro\b|\btiros\b|\btirote\w*\b|\btortur\w*\b|\bvaxin\w*\b|\bviola\w*\b|\bviolá\w*\b|\bvulv\w*\b|\bvítim\w*\b|\bzorra\w*\b|\bóso\w*\b|\b\w*abort\w*\b|\babus\w*\b|\bmutil\w*\b|\batentad\w*\b|\batrop\w*\b|\bagres\w*\b|\bcona\w*\b|\b\w*velen\w*\b|\bescrav\w*\b|\bDaesh\b|\b Dáesh \b|\b Daish \b|\betarr\w*\b|\bestado islámico\b|\bisis\b|\blapid\w*\b|\bcag\w*\b|\bcocaína\b|\bextermin\w*\b|\bHitler\b|\bHolocausto\b|\bsubnorm\w*\b|\bgilipoll\w*\b|\bcabrón\w*\b|\bcabron\w*\b|\btont\w*\b|\bestúpid\w*\b|\bparv\w*\b|\bcapull\w*\b|\bretrasad\w*\b|\binválid\w*\b|\bdiscapacitad\w*\b)' "${filename}_lines_14.txt"

# Specific cases: Delete lines ending in lowercase dash
#sed -i '/[a-z]-$/d' "${filename}_lines_14.txt"

# Specific cases: Extract lines with lowercase dash (space) lowercase / uppercase and delete them from the source file
#sed -n -e '/[a-z]-[[:space:]]\?[a-záéíóúA-ZÁÉÍÓÚ]/{w '"${filename}_guions.txt"'' -e 'd;}' "${filename}_lines_14.txt" && sed -i '/[a-z]-[[:space:]]\?[a-záéíóúA-ZÁÉÍÓÚ]/d' "${filename}_lines_14.txt"

# Delete lines with fewer than 4 characters
sed -i '/^.\{1,4\}$/d' "${filename}_lines_14.txt"

# Extract lines with acronyms to a new file and delete them from the source file
grep -E '([A-Z_ÁÉÍÓÚÑ]+\.*[A-Z_ÁÉÍÓÚÑ]|[A-Z_ÁÉÍÓÚÑ]\.$,|[A-Z_ÁÉÍÓÚÑ][A-Z_ÁÉÍÓÚÑ]+|[A-Za-z]*[A-Z][A-Za-z]*[A-Z][A-Za-z]*|[A-Za-z]*[A-Z_ÁÉÍÓÚÑ][A-Za-z]*[A-Z_ÁÉÍÓÚÑ][A-Za-z]*|[A-Z_ÁÉÍÓÚÑ]\\.$|.*[A-Z_ÁÉÍÓÚÑ]\.$|^[A-Z_ÁÉÍÓÚÑ ]+$|\([A-ZÁÉÍÓÚÑ]+\)|[A-ZÁÉÍÓÚÑ]\.+|[a-záéíóúñ]+[A-ZÁÉÍÓÚÑ]+)' "${filename}_lines_14.txt" | cut -d$'\n' -f1- > "${filename}_abbrev.txt"
sed -i -r '/([A-Z_ÁÉÍÓÚÑ]+\.*[A-Z_ÁÉÍÓÚÑ]|[A-Z_ÁÉÍÓÚÑ]\.$,|[A-Z_ÁÉÍÓÚÑ][A-Z_ÁÉÍÓÚÑ]+|[A-Za-z]*[A-Z][A-Za-z]*[A-Z][A-Za-z]*|[A-Za-z]*[A-Z_ÁÉÍÓÚÑ][A-Za-z]*[A-Z_ÁÉÍÓÚÑ][A-Za-z]*|[A-Z_ÁÉÍÓÚÑ]\\.$|.*[A-Z_ÁÉÍÓÚÑ]\.$|^[A-Z_ÁÉÍÓÚÑ ]+$|\([A-ZÁÉÍÓÚÑ]+\)|[A-ZÁÉÍÓÚÑ]\.+|[a-záéíóúñ]+[A-ZÁÉÍÓÚÑ]+)/d' "${filename}_lines_14.txt"

# Clean acronyms file (delete all caps lines and lines with one capital letter followed by a full stop at the end of line; delete all lines with numbers)
sed -i '/^[[:upper:][:punct:][:space:]]*$/d; /[[:upper:]]\.$/d' "${filename}_abbrev.txt"
sed -i '/[0-9]/d' "${filename}_abbrev.txt"

# Extract lines with numbers to a new file and delete them from the source file
grep '[0-9]' "${filename}_lines_14.txt" | cut -d$'\n' -f1- > "${filename}_numbers.txt"
sed -i '/[0-9]/d' "${filename}_lines_14.txt"

# Extract lines with an odd number of quotation marks to a new file
awk 'BEGIN{FS=""}{count=0;for(i=1;i<=NF;i++){if($i=="\""){count++}}if(count%2==1){print}}' "${filename}_lines_14.txt" > "${filename}_odd_double_quotes.txt"
awk 'BEGIN{FS=""}{count=0;for(i=1;i<=NF;i++){if($i=="'\''"){count++}}if(count%2==1){print}}' "${filename}_lines_14.txt" > "${filename}_odd_single_quotes.txt"
cat "${filename}_odd_double_quotes.txt" "${filename}_odd_single_quotes.txt" > "${filename}_odd_quotes.txt"
#sed -i '/\"/d' "${filename}_lines_14.txt"

# Delete lines that match "${filename}_odd_quotes.txt" from the source file
grep -v -f "${filename}_odd_quotes.txt" "${filename}_lines_14.txt" > "${filename}_preprocessed.txt"

# Extract lines ending in lowercase not followed by punctuation and delete from source file
grep -E '^.*[^\.!\?:\"]$' "${filename}_preprocessed.txt" > "${filename}_finalpunct.txt"
sed -i -r '^.*[^\.!\?:\"]$' "${filename}_preprocessed.txt"

# Check that all sentences are 14 words or fewer
# grep -E '\b(\w+\b\s+){14,}\w+[.?!]' *.txt > longer.txt

echo "Finished"
