# Register usage:
# $r1 - PS/2 interface read data address
# $r2 - PS/2 interface status address
# $r3 - VGA character data address
# $r4 - Current character from keyboard
# $r5 - Current X position (in multiples of 50)
# $r6 - Current Y position (in multiples of 50)
# $r7 - Display width limit (590)
# $r8 - Display height limit (430)

main:
    # Initialize registers
    addi $r1, $r0, 1000     # PS/2 data address (adjust based on your memory map)
    addi $r2, $r0, 1004     # PS/2 status address
    addi $r3, $r0, 2000     # VGA control address
    
    # Initialize cursor position
    addi $r5, $r0, 150      # Starting X position
    addi $r6, $r0, 150      # Starting Y position
    
    # Set display limits
    addi $r7, $r0, 590      # Max X (screen width - char width)
    addi $r8, $r0, 430      # Max Y (screen height - char height)

input_loop:
    # Check if there's new keyboard data
    lw $r4, 0($r2)          # Load PS/2 status
    bne $r4, $r0, read_char
    j input_loop            # No new data, keep checking

read_char:
    # Read the character
    lw $r4, 0($r1)          # Get character from PS/2 interface
    
    # Check if it's a printable character (ASCII 33-126)
    addi $r9, $r0, 32       # Space character
    blt $r4, $r9, input_loop # Skip if less than space
    addi $r9, $r0, 126      # Tilde character
    blt $r9, $r4, input_loop # Skip if greater than tilde
    
    # Write character to VGA
    sw $r4, 0($r3)          # Write character
    sw $r5, 4($r3)          # Write X position
    sw $r6, 8($r3)          # Write Y position
    
    # Move cursor position
    addi $r5, $r5, 50       # Move X by character width
    
    # Check if we need to wrap to next line
    blt $r7, $r5, newline   # If X > 590, go to new line
    j input_loop

newline:
    # Reset X and increment Y
    addi $r5, $r0, 150      # Reset X to start position
    addi $r6, $r6, 50       # Move Y down by character height
    
    # Check if we've hit bottom of screen
    blt $r8, $r6, reset_display
    j input_loop

reset_display:
    # Reset to top of screen
    addi $r5, $r0, 150      # Reset X
    addi $r6, $r0, 150      # Reset Y
    j input_loop