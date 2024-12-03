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
    addi $t2, $a0, 0             # Pointer to the beginning (m_word) of current d_word for decrypted message
    addi $t4, $zero, 0           # Pointer to dictionary m_word
    addi $t5, $t2, 0             # Pointer to character of current decrypted d_word
    addi $t8, $t4, 0             # Pointer to current character of d_word in dictionary

read_next_word: # memory word
    lw $t3, 0($t5)               # Load the next word from the input string
    bne $t3, $zero, process_char # If not null, process character
    j compute_result             # If null, compute result

process_char:
    addi $sp, $sp, -6
    sw $ra, 5($sp)
    sw $t5, 4($sp)
    sw $t3, 3($sp)             
    sw $t0, 2($sp)              
    sw $t1, 1($sp)               
    sw $t2, 0($sp)

    addi $a0, $t3, 
    jal check_in_range

    lw $ra, 5($sp)
    lw $t5, 4($sp)
    lw $t3, 3($sp)             
    lw $t0, 2($sp)              
    lw $t1, 1($sp)               
    lw $t2, 0($sp)
    addi $sp, $sp, 6

    bne $v1, $zero, match_to_dictionary
    j update_stats                            # all characters in previous decrypted word matched to a word inthe dictionary

update_stats:
    addi $t0, $t0, 1               # Increment matched d_word count
    addi $t1, $t1, 1               # Increment total d_word count
    addi $t2, $t5, 1               # Increment dictionary pointer
    addi $t5, $t2, 0
    addi $t4, $zero, 0             # start over in dictionary
    addi $t8, $zero, 0
    j read_next_word

match_to_dictionary:
    lwDict $t6, 0($t4)
    addi $sp, $sp, -6
    sw $ra, 5($sp)
    sw $t5, 4($sp)
    sw $t3, 3($sp)             
    sw $t0, 2($sp)              
    sw $t1, 1($sp)               
    sw $t2, 0($sp)
    addi $a0, $t8, 0  # pass the pointer to dictionary m_word character
    jal bit_masking_dictionary_parsing
    lw $ra, 5($sp)
    lw $t5, 4($sp)
    lw $t3, 3($sp)             
    lw $t0, 2($sp)              
    lw $t1, 1($sp)               
    lw $t2, 0($sp)
    addi $sp, $sp, 6
    addi $t9, $v0, 0
    addi $t7, $v1, 0
    and $t6, $t9, $t6                            # masking the loaded dictionary word
    sra $t6, $t6, $t7                             # shift bits to the right, t6 should contain the ascii of char in dict
    bne $t6, $t3, skip_to_next_word_in_dictionary     # characters don't match which indicates this word in dictionary does not match
    j setup_check_next_dictionary_character

setup_check_next_dictionary_character:
    addi $t9, $zero, 3
    bne $t9, $t8, increment_and_match_to_dictionary   # branch if we haven't reached the end of the m_word for dictionary
    addi $t8, $zero, -1
    addi $t4, $t4, 1                                  # point to next mem word in dict
increment_and_match_to_dictionary:
    addi $t8, $t8, 1
    addi $t5, $t5, 1
    j read_next_word
    
bit_masking_dictionary_parsing:
    addi $t9, $zero, 0          # Initialize $t9 to 0
    bne $a0, $zero, mask_f000     # If $a0 != 0, check next condition
    addi $t9, 61440              # Load 32'hf000 into $t9
    addi $t7, $zero, 24
    j mask_construction_complete                      # Skip the rest

mask_f000:
    addi $t0, $zero, 1          # Load 1 into temporary register $t0
    bne $a0, $t0, mask_0f00       # If $a0 != 1, check next condition
    addi $t9, 3840              # Load 32'h0f00 into $t9
    addi $t7, $zero, 16
    j mask_construction_complete                      # Skip the rest

mask_0f00:
    addi $t0, $zero, 2          # Load 2 into temporary register $t0
    bne $a0, $t0, mask_00f0       # If $a0 != 2, check next condition
    addi $t9, 240              # Load 32'h00f0 into $t9
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

skip_to_next_word_in_dictionary:
    addi $t9, $zero, 3
    bne $t9, $t8, continue_skip_to_next_word_in_dictionary   # branch if we haven't reached the end of the m_word for dictionary
    addi $t8, $zero, -1
    addi $t4, $t4, 1                             # point to next mem word in dict
    

continue_skip_to_next_word_in_dictionary:
    addi $t8, $t8, 1                                  # update pointer to next character in dictionary
    lwDict $t6, 0($t4)

    addi $sp, $sp, -6
    sw $ra, 5($sp)
    sw $t5, 4($sp)
    sw $t3, 3($sp)             
    sw $t0, 2($sp)              
    sw $t1, 1($sp)               
    sw $t2, 0($sp)
    addi $a0, $t8, 0                                  # pass the pointer to dictionary m_word character

    jal bit_masking_dictionary_parsing

    addi $t0, $v0, 0                                  # mask
    addi $t1, $v1, 0                                  # shamt
    and $t6, $t0, $t6                                 # masking the loaded dictionary word
    sra $t6, $t6, $t1                                 # shift bits to the right, t6 should contain the ascii of char in dict

    lw $ra, 5($sp)
    lw $t5, 4($sp)
    lw $t3, 3($sp)             
    lw $t0, 2($sp)              
    lw $t1, 1($sp)               
    lw $t2, 0($sp)
    addi $sp, $sp, 6

    addi $t7, $zero, 2                                # delimiter
    bne $t6, $t7, skip_to_next_word_in_dictionary     # if not delimiter, move to next word in dict

    addi $t4, $t4, 1                                  # point to next mem word in dict
    addi $t5, $t2, 0                                  # reset character pointer to start of word in encrypted message

    j read_next_word

compute_result:
    bne $t1, $zero, compute_percentage # If total d_words > 0
    addi $v1, $zero, 0
    j finalize                         # If no words, skip calculation

compute_percentage:
    mul $t7, $t0, 100           # Compute percentage: (matched / total) * 100
    div $t7, $t7, $t1           # Divide by total words
    addi $v1, $t7, $zero        # Store result in $v1
    j finalize


finalize:
    jr $ra                      # Return to caller

check_in_range:
    addi $v0, $zero, 0       # Initialize $v0 to 0 (default: out of range)

    # Check if ASCII is in the range of 'A' to 'Z' (65-90)
    addi $t0, $zero, 65               # Load ASCII for 'A'
    addi $t1, $zero, 91               # Load ASCII for 'Z' + 1
    blt $a0, $t0, check_lower_case # If $a0 < 65, skip to check lowercase range
    blt $t1, $a0, check_lower_case # If $a0 >= 91, skip to check lowercase range
    j in_range               # ASCII is in uppercase range

check_lower_case:
    # Check if ASCII is in the range of 'a' to 'z' (97-122)
    addi $t2, $zero, 97               # Load ASCII for 'a'
    addi $t3, $zero, 123              # Load ASCII for 'z' + 1
    blt $a0, $t2, return_result # If $a0 < 97, return 0
    blt $t3, $a0, return_result # If $a0 >= 123, return 0

in_range:
    addi $v0, $zero, 1       # Set $v0 to 1 (in range)

return_result:
    jr $ra                   # Return to caller
