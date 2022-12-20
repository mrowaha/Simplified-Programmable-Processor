`timescale 1ns / 1ps

module DataMemory(
    input logic CLK,
    input logic M_we, M_re,
    input logic[3:0] M_add,
    input logic[3:0] M_wd,
    output logic[3:0] M_rd        
);

logic[3:0] Memory[15:0];

always_ff @(posedge CLK) begin
    if(M_we) begin
        Memory[M_add] = M_wd;
    end
    if (M_re) begin 
        M_rd = Memory[M_add];
    end
end

endmodule