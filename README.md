# ECE 350 Decryption CPU (Specialized CPU for Decryption)

## Group Members
- **Isaac Yang**: iy27
- **Alexander Chen**: azc4

## Idea
A simple code decryption CPU that primarily handles software/algorithm tasks. This processor is designed to both encode and decode messages using basic encryption algorithms, such as Caesar ciphers. Decryption for simple algorithms is achieved through brute force, while more complex encryptions are decrypted with a provided key.

### Elements
- **Computational**: Algorithmic decryption of Caesar cipher
- **Inputs**: Encrypted message provided via a text file or keyboard input
- **Outputs**: Decrypted message displayed on a monitor

## MVP
- Capable of decrypting simple Caesar ciphers given an encrypted message, with or without a key
- Reads user input (text/memory file)
- Outputs decrypted message to designated memory addresses
- Implements a Caesar Cipher decryption algorithm in simplified MIPS (ISA for ECE 350 CPU)

## Implementation Ideas
- **Brute Force for Caesar Cipher**: Since Caesar Cipher involves alphabet rotation, only 26 possible rotations exist. Trying all 26 guarantees a solution if the message is encoded in Caesar.
- **Frequency Analysis**: To speed up brute force, frequency analysis can be applied.
- **Result Validation Algorithm**: MIPS code to check decryption result correctness.

### Result Validation Ideas
- Preload English vocabulary into memory
- Check if words in the decrypted message match the vocabulary bank
- Set a validity threshold (e.g., 0.6) — decryption is deemed successful if 60% of the words match the vocabulary.

## Additional Features
- Extend decryption capability to Vigenere Cipher or other more complex encryption algorithms

## Project Milestones (4 Weeks)
- **Mon 11/11**: Complete CPU design
- **Mon 11/18**: Implement basic Caesar Cipher decryption
- **Mon 11/25**: Add frequency detection for Caesar Cipher decryption and validity checking
- **Mon 12/2**: Implement additional features, such as Vigenere Cipher decryption

## Components
- **FPGA**
- **Keyboard**
- **Monitor**

## Basic Functionality
- **File Handling**: Read/write text files
- **Display**: Show decrypted text on monitor
- **User Input**: Accept keyboard input for encryption/decryption settings
- **Encrypt/Decrypt Operations**:
  - Rotate characters based on shift amount
  - Loop around for the last 3 letters in Caesar Cipher
  - Identify the most frequently occurring letter
  - Calculate the ASCII value relative to ASCII “e”
  - Check decrypted words against a dictionary to determine viability

### Implementation Notes
- **Behavioral Verilog**: Enter text into data memory (similar to lab setup)
- **Assembly Code**: Handle encryption/decryption operations
- **Idle State**: Processor remains idle until "Enter" is pressed to start encryption/decryption
- **Dictionary Storage**: Store dictionary in memory and check decrypted words for dictionary match
