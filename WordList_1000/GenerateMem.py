def padToEight(input):
    length = (8-len(input))
    return '0'*length + input
dict=[]
# Open the file in read mode
with open('1-1000.txt', 'r') as file:
    # Read each line in the file
    for line in file:
        # Print each line
        dict.append(line.strip().lower())
        
with open('dictionary.mem', 'w') as file:
    current_line = ''
    for word in dict:
        # escaping start
        if len(current_line) == 24:
            file.write(current_line + "00000010"+ "\n")
            current_line = ""
        elif len(current_line) == 32:
            file.write(current_line+"\n")
            current_line = "00000010"
        else:
            current_line = current_line + "00000010"
        
        
        word_length = len(word)
        
        for character in word:
            print(current_line, len(current_line))
            assert len(current_line) < 32
            binary_formatted_char = padToEight(format(ord(character), 'b'))
            assert len(binary_formatted_char) == 8
            current_line += str(binary_formatted_char)
            if len(current_line) == 32:
                file.write(current_line + "\n")
                current_line = ""
        assert len(current_line) < 32
        if len(current_line) == 32:
            file.write(current_line + "\n")
            current_line = "00000011"
        else:
            current_line = current_line + "00000011"
    if current_line!= "":
        file.write(current_line + '0'*(32-len(current_line)))
        #file.write(resultant_string + "\n")


        