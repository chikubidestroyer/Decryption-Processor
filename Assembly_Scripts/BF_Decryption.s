# Caesar cipher decryption function without key
# Inputs:
#   $a0 - Pointer to input string
#   $a1 - Pointer to output string
# Outputs:
#   Decrypted string is stored in the location pointed to by $a1
SETUP:
    addi $sp, $zero, 1000 # default sp, should initialize in final script
    addi $a0, $zero, 0
    addi $a1, $a0, 500

decryption_loop:
    addi $t1, $zero, 25
    blt $t1, t0, end_brute_force   # If shift key > 25, end brute force

    # Call decryption function with the current shift key
    addi $sp, $sp, -3        # Allocate 4 words for arguments
    sw $a0, 2($sp)           # Save $a0 (encrypted string pointer) at offset 2
    sw $a1, 1($sp)           # Save $a2 (output pointer) at offset 1
    sw $t0, 0($sp)           # Save shift key as argument at offset 0

    addi $a0, $a0, 0         # Pass encrypted string pointer
    addi $a2, $t0, 0         # Pass shift count
    addi $a1, $a0, 100       # Pass output address
    jal decrypt_string       # Call decryption function
    nop                      # Delay slot

    addi $t1, $a1, 0         # store pointer of decryption into t1

    # Restore arguments
    lw $t0, 0($sp)           # Restore shift key
    lw $a1, 1($sp)           # Restore output pointer
    lw $a0, 2($sp)           # Restore encrypted string pointer
    addi $sp, $sp, 3         # Deallocate 3 words for arguments

    # Check decrypted string word by word in the dictionary
    addi $t2, $zero, 0       # Word match counter

check_decrypted_words:
    lb $t3, 0($t1)           # Load current word (byte by byte if necessary)
    beq $t3, $zero, check_success # If null character, check success
    nop

    # Check if word starts with 0x02 and ends with 0x03
    andi $t4, $t3, 0xFF      # Extract first character
    bne $t4, 2, skip_word    # If not start of word, skip
    nop
    # Additional word validation logic here...

    # Increment match counter for valid words
    addi $t2, $t2, 1

skip_word:
    addi $t1, $t1, 1         # Move to next word (byte-level addressing)
    j check_decrypted_words  # Repeat for next word
    nop

check_success:
    addi $t6, $zero, 5       # Minimum matches threshold (example: 5)
    blt $t2, $t6, next_shift # If matches < threshold, try next shift
    nop

    # Successful decryption logic (copy to output)...

next_shift:
    addi $t0, $t0, 1         # Increment shift key
    j decryption_loop        # Try next shift key

end_brute_force:
    # Restore caller-saved registers (byte-level)
    lb $t2, 0($sp)           # Restore $t2
    lb $t0, 1($sp)           # Restore $t0
    lb $ra, 2($sp)           # Restore return address
    addi $sp, $sp, 3         # Deallocate 3 bytes

    jr $ra                   # Return to caller
    nop
