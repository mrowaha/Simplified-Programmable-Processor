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

2. STORE
```
001 xx r2r1r0 d3d2d1d0
This instruction specifies a move of data in the opposite
direction as the instruction load, meaning a move of data from the register file to the data
memory. So, “001 00 001 0100” specify D[4] = RF[1]. Similar to the load instruction, the 3th
and 4th most significant bits are redundant.
```

3. SUBTRACT
```
010 wa2wa1wa0 rb2rb1rb0 ra2ra1ra0
This instruction specifies a subtraction of two
register-file specified by [rb2rb1rb0] and [ra2ra1ra0], with the result stored in the register
file specified by [wa2wa1wa0]. For example, “010 010 000 001” specifies the instruction
RF[2] = RF[0] - RF[1].
```

4. ADD
```
011 wa2wa1wa0 rb2rb1rb0 ra2ra1ra0
This instruction specifies an addition of two
register-file specified by [rb2rb1rb0] and [ra2ra1ra0], with the result stored in the register
file specified by [wa2wa1wa0]. For example, “011 010 000 001” specifies the instruction
RF[2] = RF[0] + RF[1]. The result can overflow 4 bits. In that case, only the
rightmost 4 bits of the result are considered and the others are discarded
```

5. ASCENDING
```
100 xxx r2r1r0 c2c1c0
This instruction specifies the in-place sorting of multiple
consecutive register files in ascending order. The addresses of consecutive register files to
be sorted is denoted by [r2r1r0] and [c2c1c0]. [c2c1c0] is the constant that is the number of
consecutive register files to be sorted starting from the address [r2r1r0]. 
```

6. DESCENDING
```
101 xxx r2r1r0 c2c1c0
This instruction is for the descending version of the
Asc instruction, refer to Asc instruction details.
```

7. DISPLAY
```
110 xxx r2r1r0 c2c1c0
This instruction is responsible for displaying the data values
stored in constant [c2c1c0] number of consecutive register-files starting from the register
file [r2r1r0]. The constant is defined as an offset from the specified register address
For example, "101 000 010 000" will only display the data stored at R[2]
```

## User interface
