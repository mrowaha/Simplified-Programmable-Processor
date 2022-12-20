`timescale 1ns / 1ps

module InstructionMemory_Loader(
    input logic CLK,
    input logic[11:0] switchesData, //external data input by user
    input logic loadSwitchesData,
    input logic reset,  
    input logic[2:0] IM_add,
    output logic[11:0] IM_rd   
);
    
    int unsigned IM_wadd; 
    logic[11:0] Memory[7:0];

    //for hard coding instruction memory
//    initial begin
//           Memory[0] = 12'b001100110011;
//           Memory[1] = 12'b001110110011;
//           Memory[2] = 12'b001101110011;
//           Memory[3] = 12'b001100111111;
//           Memory[4] = 12'b001100000011;
//           Memory[5] = 12'b101100110011;
//           Memory[6] = 12'b111100110011;
//           Memory[7] = 12'b001110110011;                    
//    end
    //----------------------------------
    
    typedef enum logic[3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9} State;
    State currentState, nextState;
    
    always_ff @(posedge CLK) begin
        if(reset) begin
           currentState <= S0;         
        end 
        else begin
            currentState <= nextState;
            case(currentState)
                S0: 
                begin
                    IM_wadd = 0;
                    nextState <= S1;
                    Memory[0] = 12'b111000000001;
                    Memory[1] = 12'b111000000011;
                    Memory[2] = 12'b111000000111;
                    Memory[3] = 12'b111000001111;
                    Memory[4] = 12'b111000011111;
                    Memory[5] = 12'b111000111111;
                    Memory[6] = 12'b111001111111;
                    Memory[7] = 12'b111011111111;   
                end
                S1:
                begin
                    if(loadSwitchesData)
                        case(IM_wadd)
                        0 : nextState <= S2;
                        1 : nextState <= S3;
                        2 : nextState <= S4;
                        3 : nextState <= S5;
                        4 : nextState <= S6;
                        5 : nextState <= S7;
                        6 : nextState <= S8;
                        7 : nextState <= S9;
                        8 : nextState <= S1;
                        endcase 
                    else begin nextState <= S1; IM_rd <= Memory[IM_add]; end
                end   
                S2: 
                begin
                    Memory[0] <= switchesData;
                    IM_wadd = 1;
                    nextState <= S1; 
                end
                S3:
                begin
                    Memory[1] <= switchesData;
                    IM_wadd = 2;
                    nextState <= S1;      
                end
                S4:
                begin
                    Memory[2] <= switchesData;
                    IM_wadd = 3;
                    nextState <= S1;      
                end
                S5:
                begin
                    Memory[3] <= switchesData;
                    IM_wadd = 4;
                    nextState <= S1;      
                end
                S6:
                begin
                    Memory[4] <= switchesData;
                    IM_wadd = 5;
                    nextState <= S1;      
                end
                S7:
                begin
                    Memory[5] <= switchesData;
                    IM_wadd = 6;
                    nextState <= S1;      
                end
                S8:
                begin
                    Memory[6] <= switchesData;
                    IM_wadd = 7;
                    nextState <= S1;      
                end
                S9:
                begin
                    Memory[7] <= switchesData; 
                    IM_wadd = 8;
                    nextState <= S1;      
                end
                   
                default: nextState <= S0;       
            endcase   
        end
    end


        
endmodule

