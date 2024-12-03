# Caesar cipher decryption function without key
# Inputs:
#   $a0 - Pointer to input string
#   $a1 - Pointer to output string
# Outputs:
#   Decrypted string is stored in the location pointed to by $a1
SETUP_BF_DECRYPT:
    addi $sp, $zero, 1000 # default sp, should initialize in final script
    addi $a0, $zero, 0
    addi $a1, $a0, 500
    addi $t0, $zero, 0
    addi $t2, $zero, 0    # max score for a decryption
    addi $t3, $zero, 0    # shift amount for max score for a decryption


decryption_loop:
    addi $sp, $sp, -1
    sw $ra, 0($sp)

    addi $t1, $zero, 25
    blt $t1, t0, end_brute_force   # If shift key > 25, end brute force

    # Call decryption function with the current shift key
    addi $sp, $sp, -5        # Allocate 5 words for arguments
    sw $t2, 4($sp)
    sw $t3, 3($sp)           # Save max score for a decryption at offset 3
    sw $a0, 2($sp)           # Save $a0 (encrypted string pointer) at offset 2
    sw $a1, 1($sp)           # Save $a2 (output pointer) at offset 1
    sw $t0, 0($sp)           # Save shift key as argument at offset 0

    addi $a0, $a0, 0         # Pass encrypted string pointer
    addi $a2, $t0, 0         # Pass shift count
    addi $a1, $a1, 0         # Pass output address
    jal decrypt_string       # Call decryption function

    # Restore arguments
    lw $t0, 0($sp)           # Restore shift key
    lw $a1, 1($sp)           # Restore output pointer
    lw $a0, 2($sp)           # Restore encrypted string pointer
    lw $t2, 4($sp)
    lw $t3, 3($sp)           # Save max score for a decryption at offset 3
    addi $sp, $sp, 5         # Deallocate 5 words for arguments
    addi $t1, $a1, 0         # store pointer of decryption into t1

    addi $sp, $sp, -6        # Allocate 6 words for arguments
    sw $t2, 5($sp)
    sw $t3, 4($sp)           # Save max score for a decryption at offset 4
    sw $t1, 3($sp)           # save $t1, pointer to decrypted message at offset 3
    sw $a0, 2($sp)           # Save $a0 (encrypted string pointer) at offset 2
    sw $a1, 1($sp)           # Save $a1 (output pointer) at offset 1
    sw $t0, 0($sp)           # Save shift key as argument at offset 0

    jal Validation

    # Restore arguments
    lw $t0, 0($sp)           # Restore shift key
    lw $a1, 1($sp)           # Restore output pointer
    lw $a0, 2($sp)           # Restore encrypted string pointer
    lw $t1, 3($sp)
    lw $t2, 5($sp)
    lw $t3, 4($sp)           # load max score for a decryption at offset 4
    addi $sp, $sp, 4         # Deallocate 6 words for arguments

    blt $v1, $t2, max_not_modified
    add $t2, $v1, $zero      # update max score
    add $t3, $t0, $zero      # update shamt for max score

max_not_modified:

    addi $t0, $t0, 1         # increment shift amount by 1

    j decrypt_loop

end_brute_force:

    # If we've gone through all possible shift values and found nothing better,
    # Call decryption function with the current shift key
    addi $sp, $sp, -5        # Allocate 5 words for arguments
    sw $t2, 4($sp)
    sw $t3, 3($sp)           # Save max score for a decryption at offset 3
    sw $a0, 2($sp)           # Save $a0 (encrypted string pointer) at offset 2
    sw $a1, 1($sp)           # Save $a2 (output pointer) at offset 1
    sw $t0, 0($sp)           # Save shift key as argument at offset 0

    addi $a0, $a0, 0         # Pass encrypted string pointer
    addi $a2, $t3, 0         # Pass shift count (which is max at this point)
    addi $a1, $a1, 0         # Pass output address
    jal decrypt_string       # Call decryption function

    # Restore arguments
    lw $t0, 0($sp)           # Restore shift key
    lw $a1, 1($sp)           # Restore output pointer
    lw $a0, 2($sp)           # Restore encrypted string pointer
    lw $t2, 4($sp)
    lw $t3, 3($sp)           # Save max score for a decryption at offset 3
    addi $sp, $sp, 5         # Deallocate 5 words for arguments
    addi $t1, $a1, 0         # store pointer of decryption into t1

    # decrypted message with score score should exist in a1 in memory
    
    lw $ra, 0($sp) # Restore ra
    addi $sp, $sp, 1
    jr $ra

    