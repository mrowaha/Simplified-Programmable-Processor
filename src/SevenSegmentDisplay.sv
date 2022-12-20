`timescale 1ns / 1ps

module SevenSegmentDisplay(
     input logic CLK, 
     input [3:0] a, b, alu_result, 
     output [6:0]LEDs,  // 7bits for 7 LEDs
     output [3:0] enable );   // register for the 4 bit enable
    

    logic [6:0] sevseg; 
    logic [3:0]digit_en;  //local variable for enable
    logic [3:0]values;  
    localparam counter = 20;
    
    // divide system clock by 2^counter , to multiplex at lower speed
    logic [counter-1:0] count = {counter{1'b0}}; //initialized
    
    always@ (posedge clk)
        count <= 1 + count;   

    always@ (*)
     begin
     //Starting with default case     
     values = b; 
     digit_en = 4'b1111; 
     
      case(count[counter-1:counter-2]) //using only the 2 MSB's of the counter 
        
       2'b00 :  //Rightmost 7Seg.
        begin
         values = alu_result;
         digit_en = 4'b1110;
        end        
        
       2'b10:  //Second from Left 7Seg.
        begin
         values = b;
         digit_en = 4'b1011;
        end
         
       2'b11:  //Leftmost 7Seg.
        begin
         values = a;
         digit_en = 4'b0111;
        end
      endcase
     end
     

    always @(*)
         begin 
          sevseg = 7'b1111111; //default
          case( values)
               5'd0 : sevseg = 7'b1000000; //  0
               5'd1 : sevseg = 7'b1111001; //  1
               5'd2 : sevseg = 7'b0100100; //  2
               5'd3 : sevseg = 7'b0110000; //  3
               5'd4 : sevseg = 7'b0011001; //  4
               5'd5 : sevseg = 7'b0010010; //  5
               5'd6 : sevseg = 7'b0000010; //  6
               5'd7 : sevseg = 7'b1111000; //  7
               5'd8 : sevseg = 7'b0000000; //  8
               5'd9 : sevseg = 7'b0010000; //  9
               5'd10: sevseg = 7'b0001000; //  A
               5'd11: sevseg = 7'b0000011; //  b
               5'd12: sevseg = 7'b1000110; //  C
               5'd13: sevseg = 7'b0100001; //  d
               5'd14: sevseg = 7'b0000110; //  E
               5'd15: sevseg = 7'b0001110; //  F   
               default : sevseg = 7'b0111111; //dash
          endcase
         end
     
    assign enable = digit_en;
    assign LEDs = sevseg; 
 
 
endmodule
