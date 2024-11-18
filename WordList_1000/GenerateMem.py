
dict=[]
# Open the file in read mode
with open('1-1000.txt', 'r') as file:
    # Read each line in the file
    for line in file:
        # Print each line
        dict.append(line.strip().toLowerCase())
        
with open('dictionary.mem', 'w') as file:
    for word in dict:
        result_line
        word_length = len(word)
        
        for character in word:
            binary_formatted_char = format(ord(character), 'b')