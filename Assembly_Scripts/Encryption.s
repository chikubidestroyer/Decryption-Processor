    addi $29, $zero, 100      
    addi $t4, $zero, 73
    sw $t4, 0($29)
    addi $t4, $zero, 115
    sw $t4, 1($29)
    addi $t4, $zero, 97
    sw $t4, 2($29)
    addi $t4, $zero, 97
    sw $t4, 3($29)
    addi $t4, $zero, 99
    sw $t4, 4($29)
    addi $t2, $zero, 3        # Set Caesar cipher shift key, 3 for test case
    addi $t4, $zero, 65       # ASCII 'A'
    addi $t5, $zero, 90       # ASCII 'Z'
    addi $t6, $zero, 97       # ASCII 'a'
    addi $t7, $zero, 122      # ASCII 'z'
    addi $t0, $29, 0         # agreed to place pointer to memory in reg29
    addi $a0, $29, 100       # output placed 100 words after input for now
    addi $t1, $a0, 0
encrypt_loop:
    lw $t3, 0($t0)           # Load current character
    bne $t3, $zero, continue_loop
    j end_encrypt

continue_loop:
    # Check if character is uppercase (A-Z)
    sub $t8, $t3, $t4        # $t8 = char - 'A'
    blt $t8, $zero, store_char # If char < 'A', Store as-is because symbols are not translated
    sub $t8, $t3, $t5        # $t8 = char - 'Z'
    blt $zero, $t8, check_lowercase # If char > 'Z', check lowercase

    # Encrypt uppercase character
    add $t3, $t3, $t2        # Shift character by key
    sub $t8, $t3, $t5        # Check if past 'Z'
    blt $zero, $t8, wrap_uppercase # If not within 'Z', wrap around

store_uppercase:
    j store_char             # Go to store character

wrap_uppercase:
    addi $t3, $t3, -26         # Wrap around if past 'Z'
    j store_uppercase        # Go to store character

check_lowercase:
    # Check if character is lowercase (a-z)
    sub $t8, $t3, $t6        # $t8 = char - 'a'
    blt $t8, $zero, store_char      # If char < 'a', store as-is
    sub $t8, $t3, $t7        # $t8 = char - 'z'
    blt $zero, $t8, store_char # If char > 'z', store as-is

    # Encrypt lowercase character
    add $t3, $t3, $t2        # Shift character by key
    sub $t8, $t3, $t7        # Check if past 'z'
    blt $zero, $t8, wrap_lowercase # If not within 'z', wrap around

store_lowercase:
    j store_char             # Go to store character

wrap_lowercase:
    addi $t3, $t3, -26         # Wrap around if past 'z'
    j store_lowercase      

store_char:
    sw $t3, 0($t1)           # Store encrypted character in output
    addi $t0, $t0, 1          # Move to next word in input
    addi $t1, $t1, 1          # Move to next word in output
    j encrypt_loop           # Repeat for next character

end_encrypt:
    add $zero, $zero, $zero