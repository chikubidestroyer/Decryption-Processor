decrypt_string:
    addi $t9, $zero, 26       # Constant for alphabet length (used for wrapping)

decrypt_loop:
    lw $t3, 0($a0)            # Load current character
    bne $t3, $zero, validate_char # If not null character, validate range
    j end_decrypt             # Jump to end if null character encountered

validate_char:
    addi $a3, $t3, 0          # Pass character in $a3 to check_in_range
    jal check_in_range        # Call check_in_range
    bne $v0, $zero, decrypt_char # If in range, decrypt character
    j store_char              # If not in range, store as-is

decrypt_char:
    addi $v0, $zero, 0        # Initialize range type (0 = uppercase, 1 = lowercase)
    sub $t8, $t3, 97          # Check if character is in lowercase range (a-z)
    blt $t8, $zero, decrypt_uppercase
    addi $v0, $zero, 1        # Set range type to 1 (lowercase)
    sub $t8, $t3, 122
    blt $zero, $t8, decrypt_uppercase

decrypt_lowercase:
    sub $t3, $t3, $a2         # Shift character backward by key
    sub $t8, 97, $t3          # Check if before 'a'
    blt $t8, $zero, wrap_lowercase # If within range, proceed to store

store_lowercase:
    j store_char              # Go to store character

wrap_lowercase:
    add $t3, $t3, $t9         # Wrap around if before 'a'
    j store_lowercase         # Go to store character

decrypt_uppercase:
    sub $t3, $t3, $a2         # Shift character backward by key
    sub $t8, 65, $t3          # Check if before 'A'
    blt $t8, $zero, wrap_uppercase # If within range, proceed to store

store_uppercase:
    j store_char              # Go to store character

wrap_uppercase:
    add $t3, $t3, $t9         # Wrap around if before 'A'
    j store_uppercase         # Go to store character

store_char:
    sw $t3, 0($a1)            # Store decrypted character in output
    addi $a0, $a0, 1          # Move to next character in input
    addi $a1, $a1, 1          # Move to next character in output
    j decrypt_loop            # Repeat for next character

end_decrypt:
    sw $zero, 0($a1)          # Null-terminate the output string
    jr $ra                    # Return to caller
