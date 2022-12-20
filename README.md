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
* Left pushbutton will be used to execute the next instruction in the instruction memory.
Toavoid pressing multiple times a debouncer has been implemented.
* Right pushbutton will be used to execute the instruction defined by switches. It is the signal
isexternal. Here also, a debouncer is implemented.
* Middle pushbutton will be used to load the instruction that is specified by the user to the
back of the queue in the instruction memory. Here also, a debouncer is implemented.
* Upper pushbutton will be used to load the data value that is specified by the user to the
register-file address that is also specified by the user. Here also, a debouncer is implemented.
* Lower pushbutton will be used to clear everything existed in the processor and reset the
controller. Here also, a debouncer is implemented.
* 12 rightmost switches on Basys3 will be used to provide user-defined instruction.
* 7 leftmost switches on Basys3 will be used to provide user-defined data value along with the
register-file address where the 4 leftmost switches correspond to the data value and the
remaining ones correspond to the register-file address. For instance, if the user inputs
0010110, RF[6] should get the decimal value 2.
* SevenSegment Display will be used for Sub, Add, Asc, Des, and Disp instructions.
  * For Sub and Add instructions, the inputs A, B should be displayed in the leftmost
2 digits and the result should be displayed on the rightmost digit. The remaining
digit should be turned off.
  * For Asc and Des instructions, the resulting sorted values should be displayed in
order with 1 second time periods in the rightmost digit. The constant value
should be displayed in the leftmost digit at each period. The remaining digits
should be turned off.
  * For Disp instruction, the data values should be displayed with 1 second time
periods in the rightmost digit. The constant value should be displayed in the
leftmost digit at each period. The remaining digits should be turned off.
