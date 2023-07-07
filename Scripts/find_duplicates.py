from collections import defaultdict

def find_duplicate_sentences(file_path):
    sentence_dict = defaultdict(list)

    # Read sentences from the file and store them in a dictionary
    with open(file_path, 'r') as f:
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

# Provide the file path
file_path = 'cv_praza_clean.txt'

# Call the function to find duplicated sentences
duplicates = find_duplicate_sentences(file_path)

# Provide the output file name
output_file = 'duplicate_praza.txt'

# Write duplicated sentences to the output file
write_duplicates_to_file(duplicates, output_file)

print(f"Duplicated sentences written to '{output_file}'.")


