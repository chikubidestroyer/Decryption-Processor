setup:
    addi $t8, $zero, 0
    addi $t4, $zero, 0
    addi $sp, $sp, 1000
    
    addi $t8, $t8, 1                                  # update pointer to next character in dictionary
    lwDict $t6, $t4, 0

    addi $sp, $sp, -8
    sw $t6, 7($sp)
    sw $t8, 6($sp)
    sw $ra, 5($sp)
    sw $t5, 4($sp)
    sw $t3, 3($sp)             
    sw $t0, 2($sp)              
    sw $t1, 1($sp)               
    sw $t2, 0($sp)
    addi $a0, $t8, 0                                  # pass the pointer to dictionary m_word character

    jal bit_masking_dictionary_parsing

    lw $t6, 7($sp)
    lw $t8, 6($sp)
    lw $ra, 5($sp)
    lw $t5, 4($sp)
    lw $t3, 3($sp)             
    lw $t0, 2($sp)              
    lw $t1, 1($sp)               
    lw $t2, 0($sp)
    addi $sp, $sp, 8

    addi $t0, $v0, 0                                  # mask
    addi $t1, $v1, 0                                  # shamt
    and $t6, $t0, $t6                                 # masking the loaded dictionary word

    addi $sp, $sp, -3
    sw $ra, 2($sp)
    sw $a0, 1($sp)
    sw $a1, 0($sp)
    addi $a0, $t1, 0
    addi $a1, $t6, 0
    jal sra_variable                                 # shift bits to the right, t6 should contain the ascii of char in dict
    addi $t6, $v0, 0
    lw $a1, 0($sp)
    lw $a0, 1($sp)
    lw $ra, 2($sp)
    addi $sp, $sp, 3
    j end

bit_masking_dictionary_parsing:
    addi $t9, $zero, 0          # Initialize $t9 to 0
    bne $a0, $zero, mask_f000     # If $a0 != 0, check next condition
    addi $t9, $zero, 61440              # Load 32'hf000 into $t9
    addi $t7, $zero, 24
    j mask_construction_complete                      # Skip the rest

mask_f000:
    addi $t0, $zero, 1          # Load 1 into temporary register $t0
    bne $a0, $t0, mask_0f00       # If $a0 != 1, check next condition
    addi $t9, $zero, 3840              # Load 32'h0f00 into $t9
    addi $t7, $zero, 16
    j mask_construction_complete                      # Skip the rest

mask_0f00:
    addi $t0, $zero, 2          # Load 2 into temporary register $t0
    bne $a0, $t0, mask_00f0       # If $a0 != 2, check next condition
    addi $t9, $zero, 240              # Load 32'h00f0 into $t9
    addi $t7, $zero, 8
    j mask_construction_complete                      # Skip the rest

mask_00f0:
    addi $t0, $zero, 3          # Load 3 into temporary register $t0
    bne $a0, $t0, mask_construction_complete          # If $a0 != 3, skip the rest
    addi $t9, $zero, 15
    addi $t7, $zero, 4

mask_construction_complete:
    # t9 is the mask
    # t7 is the bits to shift after ANDing
    addi $v0, $t9, 0
    addi $v1, $t7, 0
    jr $ra

# inputs: a0 = shamt, a1 = register shifted
# output: v0 = result
sra_variable:
    bne $a0, $zero, continue_sra_shifter
    addi $v0, $a1, 0
    jr $ra

continue_sra_shifter:
    sra $a1, $a1, 1
    addi $a0, $a0, -1
    j sra_variable

end:
    nop