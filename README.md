# Simplified-Programmable-Processor
___________________________________________________

This is a simple programmable processor written in SystemVerilog for the Basys3 FPGA implementation

## Supported Instructions
The architecture supports 12-bit instructions with the three MSBs specifying the opcode

1. LOAD 
```
000 xx r2r1r0 d3d2d1d0
This instruction specifies a move of data from the data
memory location (D) whose address is specified by bits [d3d2d1d0] into the register file (RF)
whose address location is specified by the bits [r2r1r0]. For example, the instruction “000
00 001 0010” specifies a move of data memory location 0010, D[2], into register file
location 001 (or RF[1]) – In other words, that instruction represents the operation RF[1] =
D[2]. There are 2 redundant “don’t care” bits, so
instructions “000 00 001 0010” and “000 11 001 0010” should both do the same thing as
they only differ in those bits
```
