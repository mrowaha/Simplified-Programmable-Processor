`timescale 1ns / 1ps


module ProgramCounter_3bit(
    input logic CLK,
    input logic clear,
    input logic enable,
    output logic[2:0] out,
    input logic increment
);

    logic[2:0] in;
    logic rollover;
    
    initial in = 3'b111;
    
    always_ff @(posedge CLK) begin
        if(clear || rollover) begin
            in = 3'b111;
            rollover = 0;
        end else begin 
            if (enable && increment) begin
                 in++;
            end else if(in == 3'b111 && increment && enable) begin
                rollover = 1;
            end
        end
    end

    assign out = in;    
endmodule

