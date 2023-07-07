import os
from collections import defaultdict

def find_duplicate_sentences(files):
    sentence_dict = defaultdict(list)

    # Read sentences from each file and store them in a dictionary
    for file in files:
        with open(file, 'r') as f:
            sentences = [line.strip() for line in f if line.strip()]
            for sentence in sentences:
                lowercase_sentence = sentence.lower()
                sentence_dict[lowercase_sentence].append(sentence)

    # Find duplicated sentences
        duplicated_sentences = []
    for sentence_list in sentence_dict.values():
        if len(sentence_list) >= 2:
            duplicated_sentences.extend(sentence_list)

    return duplicated_sentences

def write_duplicates_to_file(duplicates, output_file):
    with open(output_file, 'w') as f:
        f.write("Duplicated Sentences:\n")
        for sentence in duplicates:
            f.write(f"{sentence}\n")

# Provide the list of file paths
file_paths = ['cv_nos_diario.txt', 'cv_PG_anon.txt', 'cv_praza_clean.txt', 'cv_tvg_MARTA.txt']

# Call the function to find duplicated sentences
duplicates = find_duplicate_sentences(file_paths)

# Provide the output file name
output_file = 'common_sentences.txt'

# Write duplicated sentences to the output file
write_duplicates_to_file(duplicates, output_file)

print(f"Duplicated sentences written to '{output_file}'.")

