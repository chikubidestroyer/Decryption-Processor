# Processor
## ISAAC YANG (IY27)

## Description of Design
### ALU
The ALU design includes six operations: 32 bit Add, Subtract, bitwise AND, bitwise OR, Shift Left Logical, Shift Right Arithmetic

Add was implement with a two level carry lookahead algorithm, subtraction was realized by negating the second operand before passing it to the Add operation.
AND and OR operations were implemented simply by AND/ORing every bit of the operands. Shifting was made as a barrel shifter, modules that shifts the operand by 1, 2, 4, 8, 16 bits were written along with a sequence of mux that decided whether or not to shift accordingly. Not equal to and is less than simply checked for some conditions after a subtraction operation.
Finally, these calculation results were put together into a mux that took the opcode as input which decided which calculation was to be stored into the data result register.

### Multiplication and Division
The `multdiv` module implements `multiplication` and `division` in Verilog and operates separately from the ALU. The `booth_multiplier` module uses Booth's multiplication algorithm, and the `divider` module is based on a non-restoring division algorithm. A combined `multdiv` module integrates both functionalities.

The `mult` module implements Booth's algorithm for signed integer multiplication. Booth's encoding reduces the number of addition/subtraction operations by grouping bits of the multiplier.
- Supports signed multiplication
- Reduces operations via Booth recoding
- Iterative, resource-efficient design


The `divider` module implements a non-restoring division algorithm for signed and unsigned integers, providing both quotient and remainder outputs.
- Supports signed division
- Computes quotient and remainder
- non-restoring algorithm

Both multiplication and division takes multiple (32) cycles to complete

### PC control
PC control was done in both the `fetch` and `execute` stages. The processor takes either the default (next word) from the instruction memory, or from a jump instruction which is calculated in the execute stage. An adder was implemented that does calculations for `PC` exclusively, the ALU of the processor also outputs results of branch conditions that are used to determine whether if the fetch stage actually takes the calculated PC.

When a jump instruction passes its conditions in the execution stage, the processor flushes instructions currently in `fetch` and `decode`.

No PC prediction is performed in this processor

### Pipelines
This processor has 5 stages:
- `Fetch`: fetches instructions based on current `PC`
- `Decode`: decodes the fetched instructions and reads registers that are used in this instruction
- `Execute`: performs calculations used in the instruction
- `Memory`: reads or writes into memory as needed
- `Write Back`: writes results back to the registers

## Bypassing
Bypassing was implemented for all hazardous instruction sequences, some of the toughest implementations were from jump instrctions such as jr which took the value of a register as the program counter. Bypassing logic was essentially hard coded for all instructions since they were difficult to generalize.

## Stalling
The processor is stalled only when one of two things happens:
- multiplication or division is in progress
- loading was the previous instruction and the current instruction has a hazard with the loading
when multdiv is occurring, all stages of the processor are stalled whereas loading stalls only the Fetch and Decode stages.

## Optimizations
- CLA adder
- booth multiplication
- non-restorative division
- 5-stage pipelined processor
- forwarding and minimal stalling for hazardous sequences

## Bugs
There are no known bugs in the current implementation.