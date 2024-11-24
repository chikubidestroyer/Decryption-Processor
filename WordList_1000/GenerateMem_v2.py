def pad32(input):
    length = (32-len(input))
    return '0'*length + input
dict=[]
# Open the file in read mode
with open('1-1000.txt', 'r') as file:
    # Read each line in the file
    for line in file:
        # Print each line
        dict.append(line.strip().lower())
        
with open('dictionary.mem', 'w') as file:
    count = 0
    current_line = ''
    for word in dict:
        if count + 2 + len(word) > 4096:
            print(word)
            break
        for character in word:
            
            binary_formatted_char = pad32(format(ord(character), 'b'))
            current_line = str(binary_formatted_char)
            file.write(current_line + "\n")
            count += 1
        file.write(pad32(format(3,'b')) + "\n")
        count += 1
    file.write(pad32('0') + "\n")
    count += 1

        