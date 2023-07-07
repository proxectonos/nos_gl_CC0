def delete_common_sentences(common_sentences_file, files):
    # Read common sentences from the file
    common_sentences = []
    with open(common_sentences_file, 'r') as f:
        # Skip the header line
        next(f)
        for line in f:
            sentence = line.strip()
            common_sentences.append(sentence)

    # Delete common sentences from other files
    for file in files:
        updated_sentences = []
        with open(file, 'r') as f:
            sentences = [line.strip() for line in f if line.strip()]
            for sentence in sentences:
                if sentence not in common_sentences:
                    updated_sentences.append(sentence)

        # Overwrite the file with updated sentences
        with open(file, 'w') as f:
            for sentence in updated_sentences:
                f.write(f"{sentence}\n")

# Provide the path to the common_sentences.txt file
common_sentences_file = 'duplicate_tvg.txt'

# Provide the list of file paths to update
file_paths = ['cv_tvg_MARTA.txt']

# Call the function to delete common sentences
delete_common_sentences(common_sentences_file, file_paths)

print(f"Common sentences deleted from '{file_paths}'.")
