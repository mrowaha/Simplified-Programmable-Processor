`timescale 1ns / 1ps

module RegisterFile(
    input logic CLK, reset,
    input logic RF_we,
    input logic[2:0] RF_ad1, RF_ad2, RF_wa,
    input logic[3:0] RF_wd,
    output logic[3:0] RF_d1, RF_d2,
    input logic write_user_data,
    input logic[6:0] user_data,
    output logic[3:0] Memory[7:0],
    input logic[1:0] rf_op,
    output logic[11:0] LED,
    input logic[2:0] from_address, to_address, upto        
);

logic[3:0] key;
int i ,j;
//logic[2:0] i, j;

logic[3:0] Temp_Mem[7:0];

initial LED = 12'b000_000_000_000;
typedef enum logic[3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9} State;
State currentState, nextState;
State des_currentState, des_nextState;

always_ff @(posedge CLK) begin
    if(reset) begin
        LED[1] = 1;
    
        Memory[0] <= 4'b0000;
        Memory[1] <= 4'b0000;
        Memory[2] <= 4'b0000;
        Memory[3] <= 4'b0000;
        Memory[4] <= 4'b0000;
        Memory[5] <= 4'b0000;
        Memory[6] <= 4'b0000;
        Memory[7] <= 4'b0000;
        
        currentState <= S0;  
        des_currentState <= S0;                   
    end else begin
        case(rf_op)
        0:
        begin
            nextState <= S0;
            if(write_user_data) begin
                LED[0] = 1;
                Memory[user_data[2:0]] <= user_data[6:3];
            end else begin
                if(RF_we) begin
                    // if enable == 1, write
                    Memory[RF_wa] <= RF_wd;
                end 
                RF_d1 <= Memory[RF_ad1];
                RF_d2 <= Memory[RF_ad2];       
            end
        end
        1:
        begin
            for(i = 1; i < upto; i++) begin
                key = Memory[from_address + i];
                j = i - 1;
                while(j >= 0 && Memory[from_address + j] > key) begin
                    Memory[from_address + j + 1] = Memory[from_address + j];
                    j = j - 1;
                end
                Memory[from_address + j + 1] = key;
                end
        end
        2:
        begin
            for(i = 1; i < upto; i++) begin
                key = Memory[from_address + i];
                j = i - 1;
                while(j >= 0 && Memory[from_address + j] < key) begin
                    Memory[from_address + j + 1] = Memory[from_address + j];
                    j = j - 1;
                end
                Memory[from_address + j + 1] = key;
                
            end
        end
        endcase           
    end                  
end
    

endmodule