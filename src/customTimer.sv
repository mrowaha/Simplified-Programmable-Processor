`timescale 1ns / 1ps

//this time should only be used for testing registers on FPGA implementation
module customTimer(
        input logic CLK,
        output logic tick
    );
    
    localparam int maxcount = 100000000;
    int unsigned counter = 0;
    always @(posedge CLK) begin
        //pulse length
        if(counter == 1) begin
            tick = 0;
        end
        counter  = counter + 1;
        if(counter == maxcount) begin
            tick = 1;
            counter = 0;
        end         
    end
endmodule


