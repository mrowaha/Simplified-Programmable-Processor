`timescale 1ns / 1ps

module InstructionRegister_12bit(
    input logic CLK,
    input logic clear,
    input logic enable,
    input logic isExternal,
    input logic leftPush,
    input logic[11:0] switches_data,
    input logic[11:0] memory_data,
    output logic[11:0] out
);
    
    typedef enum logic[2:0] {S0, S1, S2, S3} State;
    State currentState, nextState;

    always_ff @(posedge CLK) begin
        if(clear) begin
            currentState <= S0;
        end
        else begin
            currentState <= nextState;
            case (currentState)
            S0:
            begin
                out = 12'b111111111111;
                nextState <= S1;
            end
            S1:
            begin
                if(~(leftPush ^ isExternal)) nextState <= S1; //wait
                else if(leftPush & ~isExternal) nextState <= S2; // fetch from IM
                else if(~leftPush & isExternal) nextState <= S3; //fetch from user defined switches
            end
            S2:
            begin
                out = memory_data;
                nextState <= S1;
            end
            S3:
            begin
                out = switches_data;
                nextState <= S1;
            end
            default: nextState <= S0;
            endcase 
        end    
    end
    
endmodule
