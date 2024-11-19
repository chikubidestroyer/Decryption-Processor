# Caesar cipher decryption function with key
# Inputs:
#   $a0 - Pointer to input string
#   $a1 - Pointer to output string
#   $a2 - Shift key
# Outputs:
#   Decrypted string is stored in the location pointed to by $a1
decrypt_string:
    addi $t4, $zero, 65       # ASCII 'A'
    addi $t5, $zero, 90       # ASCII 'Z'
    addi $t6, $zero, 97       # ASCII 'a'
    addi $t7, $zero, 122      # ASCII 'z'

decrypt_loop:
    lw $t3, 0($a0)            # Load current character
    bne $t3, $zero, check_uppercase # If not null character, check case
    j end_decrypt             # Jump to end if null character encountered

check_uppercase:
    # Check if character is uppercase (A-Z)
    sub $t8, $t3, $t4         # $t8 = char - 'A'
    blt $t8, $zero, store_char # If char < 'A', store as-is
    sub $t8, $t3, $t5         # $t8 = char - 'Z'
    blt $zero, $t8, check_lowercase # If char > 'Z', check lowercase

    # Decrypt uppercase character
    sub $t3, $t3, $a2         # Shift character backward by key
    sub $t8, $t4, $t3         # Check if before 'A'
    blt $t8, $zero, wrap_uppercase # If within 'A-Z', proceed to store

store_uppercase:
    j store_char              # Go to store character

wrap_uppercase:
    addi $t3, $t3, 26         # Wrap around if before 'A'
    j store_uppercase         # Go to store character

check_lowercase:
    # Check if character is lowercase (a-z)
    sub $t8, $t3, $t6         # $t8 = char - 'a'
    blt $t8, $zero, store_char # If char < 'a', store as-is
    sub $t8, $t3, $t7         # $t8 = char - 'z'
    blt $zero, $t8, store_char # If char > 'z', store as-is

    # Decrypt lowercase character
    sub $t3, $t3, $a2         # Shift character backward by key
    sub $t8, $t6, $t3         # Check if before 'a'
    blt $t8, $zero, wrap_lowercase # If within 'a-z', proceed to store

store_lowercase:
    j store_char              # Go to store character

wrap_lowercase:
    addi $t3, $t3, 26         # Wrap around if before 'a'
    j store_lowercase         # Go to store character

store_char:
    sw $t3, 0($a1)            # Store decrypted character in output
    addi $a0, $a0, 1          # Move to next word in input
    addi $a1, $a1, 1          # Move to next word in output
    j decrypt_loop            # Repeat for next character

end_decrypt:
    sw $zero, 0($a1)          # Null-terminate the output string
    jr $ra                    # Return to caller
