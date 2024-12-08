# Caesar cipher encryption function
# Inputs:
#   $a0 - Pointer to input string
#   $a1 - Pointer to output string
#   $a2 - Shift key
# Outputs:
#   Encrypted string is stored in the location pointed to by $a1
Start_Encrypt:
    addi $a0, $zero, 1500
    addi $a1, $zero, 5500
    
    addi $r28, $zero, 0
    jal encrypt_string
    addi $r28, $zero, 1
    j end_script

end_script:
    nop
    nop
    j end_script

encrypt_string:
    addi $t4, $zero, 65       # ASCII 'A'
    addi $t5, $zero, 90       # ASCII 'Z'
    addi $t6, $zero, 97       # ASCII 'a'
    addi $t7, $zero, 122      # ASCII 'z'

encrypt_loop:
    lw $t3, 0($a0)            # Load current character
    bne $t3, $zero, check_uppercase # If not null character, check case
    j end_encrypt             # Jump to end if null character encountered

check_uppercase:
    # Check if character is uppercase (A-Z)
    sub $t8, $t3, $t4         # $t8 = char - 'A'
    blt $t8, $zero, store_char # If char < 'A', store as-is
    sub $t8, $t3, $t5         # $t8 = char - 'Z'
    blt $zero, $t8, check_lowercase # If char > 'Z', check lowercase

    # Encrypt uppercase character
    add $t3, $t3, $a2         # Shift character by key
    sub $t8, $t3, $t5         # Check if past 'Z'
    blt $zero, $t8, wrap_uppercase # If within 'Z', proceed to store

store_uppercase:
    j store_char              # Go to store character

wrap_uppercase:
    addi $t3, $t3, -26        # Wrap around if past 'Z'
    j store_uppercase         # Go to store character

check_lowercase:
    # Check if character is lowercase (a-z)
    sub $t8, $t3, $t6         # $t8 = char - 'a'
    blt $t8, $zero, store_char # If char < 'a', store as-is
    sub $t8, $t3, $t7         # $t8 = char - 'z'
    blt $zero, $t8, store_char # If char > 'z', store as-is

    # Encrypt lowercase character
    add $t3, $t3, $a2         # Shift character by key
    sub $t8, $t3, $t7         # Check if past 'z'
    blt $zero, $t8, wrap_lowercase # If within 'z', proceed to store

store_lowercase:
    j store_char              # Go to store character

wrap_lowercase:
    addi $t3, $t3, -26        # Wrap around if past 'z'
    j store_lowercase         # Go to store character

store_char:
    sw $t3, 0($a1)            # Store encrypted character in output
    addi $a0, $a0, 1          # Move to next word in input
    addi $a1, $a1, 1          # Move to next word in output
    j encrypt_loop            # Repeat for next character

end_encrypt:
    sw $zero, 0($a1)          # Null-terminate the output string
    jr $ra                    # Return to caller