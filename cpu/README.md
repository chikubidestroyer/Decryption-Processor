# MultDiv
    - I used a a 64 bit divider and a 65 bit multiplier to implement non-restoring division and booth's algorithm multiplication respectively. 
    - I implmented a latch for when multiplication is interrupted by division and vice versa using a D flip-flop to remember the state.
    - Both multiplier and divider use the same 32 bit CLA adder.
# Multiplier
- I use a 2 to 1 Mux to select the initial value that goes into the 65 bit register. It selects the initial value when ctrl_MULT is high otherwise it selects the shifted value to enter into the register. 
- I check whether an operation occurs by XOR ing the 2 LSB and check add or subtract by checking the 2nd bit. 
- Exception are detected by checking if the top bits are all the same, if operands are nonzero while the result is zero, and if the operands are negative and the result is negative and if the operands are positive and the result is negative. This is done through bitwise logic.
# Divider
- I use two 2 to 1 muxes to select the values for the Q and R register. These select between the initial value and shifted Q and the current R or the top bits that are the final restore.
- I use 2 32 bit registers to hold the values of R and Q. Originally this was 1 64 bit register, but I had issues initializing the remainder to the right value. Later discovered it was because the reset condition for the register was ctrl_DIV. 
- Negative values are dealt with by finding the twos complement and then flipping at the end.
- Exceptions are handled by checking if the divisor is 0.
- I had to extend the the cycle count by 1 to allow the values to settle into the register because the R register resets on ctrl_DIV.