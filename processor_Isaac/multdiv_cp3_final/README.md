# Multiplication Division Unit
## Name
Isaac Yang iy27

## Description of Design

This project implements `multiplication` and `division` modules in Verilog. The `booth_multiplier` module uses Booth's multiplication algorithm, and the `divider` module is based on a non-restoring division algorithm. A combined `multdiv` module integrates both functionalities.

### Multiplier
The `mult` module implements Booth's algorithm for signed integer multiplication. Booth's encoding reduces the number of addition/subtraction operations by grouping bits of the multiplier.

#### Features:
- Supports signed multiplication
- Reduces operations via Booth recoding
- Iterative, resource-efficient design

### Divider
The `divider` module implements a non-restoring division algorithm for signed and unsigned integers, providing both quotient and remainder outputs.

#### Features:
- Supports signed division
- Computes quotient and remainder
- non-restoring algorithm

## Combined Multiplier-Divider (`multdiv`)
The `multdiv` module combines the multiplier and divider into a single unit, sharing resources and control logic to optimize hardware usage.

## Bugs
No known bugs found