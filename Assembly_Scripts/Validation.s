# Match percentage computation
# m_word = the computer architecture definition of word
# d_word = English language definition of word
# Inputs:
#   $a0 - Pointer to decrypted string
# Outputs:
#   $v1 - Percentage of matched words (0-100)

Validation:
    addi $t0, $zero, 0           # Initialize matched d_word count to 0
    addi $t1, $zero, 0           # Initialize total d_word count to 0
    addi $t2, $a0, 0             # Pointer to the beginning (m_word) of current d_word
    addi $t4, $zero, 0           # Pointer to dictionary m_word
    addi $t5, $t2, 0             # Pointer to character of current d_word

read_next_word: # memory word
    lw $t3, 0($t5)               # Load the next word from the input string
    bne $t3, $zero, process_char # If not null, process character
    j compute_result             # If null, compute result

process_char:
    addi $sp, $sp, -5
    sw $t5, 4($sp)
    sw $t3, 3($sp)             
    sw $t0, 2($sp)              
    sw $t1, 1($sp)               
    sw $t2, 0($sp)

    addi $a0, $t3, 
    jal check_in_range

    lw $t5, 4($sp)
    lw $t3, 3($sp)             
    lw $t0, 2($sp)              
    lw $t1, 1($sp)               
    lw $t2, 0($sp)
    addi $sp, $sp, 5

    bne $v1, $zero, match_to_dictionary

match_to_dictionary:
    lwDict $t6, 0($t4)
    bne $t6, $t3, check_next_dictionary_word     # characters don't match which indicates this word in dictionary does not match


check_next_dictionary_word:
    addi $t4, $t4, 1                             # Increment to next mem word in dictionary
    lwDict $t6, 0($t4)
    addi $t7, $zero, 3                           # delimiter
    bne $t6, $t7, check_next_dictionary_word     # if not delimiter, move to next word in dict
    addi $t4, $t4, 1                             # point to next mem word in dict

    addi $t5, $t2, 0

    j read_next_word


finalize:
    jr $ra                      # Return to caller