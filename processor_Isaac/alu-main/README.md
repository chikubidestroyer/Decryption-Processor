# ALU
## Name
Isaac Yang iy27

## Description of Design
This ALU design includes six operations: 32 bit Add, Subtract, bitwise AND, bitwise OR, Shift Left Logical, Shift Right Arithmetic

Add was implement with a two level carry lookahead algorithm, subtraction was realized by negating the second operand before passing it to the Add operation.
AND and OR operations were implemented simply by AND/ORing every bit of the operands. Shifting was made as a barrel shifter, modules that shifts the operand by 1, 2, 4, 8, 16 bits were written along with a sequence of mux that decided whether or not to shift accordingly. Not equal to and is less than simply checked for some conditions after a subtraction operation.
Finally, these calculation results were put together into a mux that took the opcode as input which decided which calculation was to be stored into the data result register.


## Bugs
No known bugs found