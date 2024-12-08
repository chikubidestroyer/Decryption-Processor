# Generates an order in wihich the decryption process will proceed
# Inputs:
# a0: the pointer to the input string
# output:
# v0: pointer to the order
# Notes: this assumes the inputs are all capitalized characters
Freq_List:
  addi $t0, $a0, 0              # the index of the current position of the input string
  addi $t1, $zero, 0            # value of the current position of the input string
  addi $t2, $zero, 0            # pointer to memory keeping track of the number of times each character appears in the input string
  j Freq_List_Read_Next

Freq_List_READ_NEXT:
    lw $t1, 0($t0)

    bne $t1, $zero, continue_Freq_List_READ_NEXT # if not null

    j Gen_order


continue_Freq_List_READ_NEXT:

    addi $sp, $sp, -5
    sw $t0, 0($sp)
    sw $t1, 1($sp)
    sw $t2, 2($sp)
    sw $a0, 3($sp)
    sw $ra, 4($sp)

    addi $a0, $t1, 0
    jal check_in_range

    lw $t0, 0($sp)
    lw $t1, 1($sp)
    lw $t2, 2($sp)
    lw $a0, 3($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 5

    bne $zero, $v0, continue_contine_Freq_List_READ_NEXT
    addi $t0, $t0, 1
    j Freq_List_READ_NEXT

continue_continue_Freq_List_READ_NEXT:

    addi $t3, $t2, $t1          # pointer to memory keeping track of the number of times this character appears in the input string
    lw $t4, 0($t3)              # value of frequency of this character
    addi $t4, $t4, 1            # updates char frequency
    sw $t4, 0($t3)              # updates char frequency in memory
    addi $t0, $t0, 1

    j Freq_List_Next

Gen_order:
    addi $t0, $zero, 65        # Ascii for 'A'

    addi $v0, $a0, 1000        # order set at ~1000 words away from the input string

    

