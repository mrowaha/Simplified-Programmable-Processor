`timescale 1ns / 1ps

//-----------------------Debouncer FSM-----------------------------
module Debouncer(
    input logic CLK,
    input logic in,
    output logic debounced,
    input logic reset
    );
    
    typedef enum logic[2:0] {S0, S1, S2} State;
    State currentState, nextState;
    
    always_ff @(posedge CLK)
        if(reset) currentState <= S0;
        else currentState <= nextState;
    
    always_comb
        case(currentState)
        S0: if(in) nextState <= S1;
            else nextState <= currentState;
        S1: if(in) nextState <= S2;
            else nextState <= S0;
        S2: if(in) nextState <= currentState;
            else nextState <= S0;
        default nextState <= S0;       
        endcase
    
    assign debounced = currentState == S1? 1 : 0;
      
endmodule
//--------------------------------------------------------------------

//----------------------------Controller FSM--------------------------
module Controller (
    input logic CLK, reset,
    input logic[11:0] Ext_Instruction,
    output logic M_re, M_we, 
    output logic[3:0] M_add,
    output logic RF_we,  
    output logic[2:0] RF_wa, RF_ad1, RF_ad2,
    output logic[2:0] ALU_op,
    output logic[1:0] display_op,
    output logic[8:0] instruction_operands,
    output logic select_src,
    output logic[1:0] rf_op,
    output logic[2:0] from_address , to_address ,upto
);

   typedef enum logic[3:0] {S0, S1, S2, S3, S4, S5, S6, S7} State;
   State currentState, nextState;
   
   logic[11:0] Instruction;
   
    always_ff @(posedge CLK) begin
        if(reset) 
        begin
            currentState <= S0;
            display_op = 0; // nothing is displayed upon reset
        end
        else begin
            currentState <= nextState;
            
            case(currentState)
                S0:
                begin
                    if(Instruction == Ext_Instruction) nextState <= S0;
                    else begin
                        Instruction = Ext_Instruction;
                        case(Instruction[11:9])
                        0 : nextState <= S1; //load 
                        1 : nextState <= S2; // store
                        2 : nextState <= S3; // subtract
                        3 : nextState <= S4; // add
                        4: nextState <= S6; // asc
                        5: nextState <= S7; //desc
                        6: nextState <= S5; //disp
                        7 : nextState <= S0; //111 is a wait/idle instruction
                        endcase
                    end
                end
                S1:
                begin
                    // load from data memory
                    M_re = 1;
                    M_we = 0;
                    M_add = Instruction[3:0];
                    select_src = 1;
                    RF_we = 1;
                    rf_op = 0;
                    RF_wa = Instruction[6:4];
                    display_op = 0;
                    nextState <= S0;                   
                end
                S2:
                begin
                    //store to data memory
                    M_re = 0;
                    M_we = 1;
                    M_add = Instruction[3:0];
                    RF_we = 0;
                    rf_op = 0;
                    RF_ad1 = Instruction[6:4];
                    display_op = 0;
                    nextState  <= S0;
                end
                S3: 
                begin
                    //subtract
                    M_re = 0;
                    M_we = 0;
                    RF_we = 1;
                    RF_wa = Instruction[8:6];
                    RF_ad1 = Instruction[5:3];
                    RF_ad2 = Instruction[2:0];
                    ALU_op = 1;
                    display_op = 2;
                    instruction_operands = Instruction[8:0];
                    select_src = 0;
                    rf_op = 0;
                    nextState <= S0;
                end
                S4:
                begin
                   //add
                    M_re = 0;
                    M_we = 0;
                    RF_we = 1;
                    RF_wa = Instruction[8:6];
                    RF_ad1 = Instruction[5:3];
                    RF_ad2 = Instruction[2:0];
                    ALU_op = 0;
                    display_op = 1;
                    instruction_operands = Instruction[8:0];
                    select_src = 0;
                    rf_op = 0;
                    nextState <= S0;
                end
                S5:
                begin
                    //display
                    display_op = 3;
                    instruction_operands = Instruction[8:0];
                    rf_op = 0;
                    nextState <= S0;
                end
                S6:
                begin
                    //ascending
                    display_op = 0;
                    RF_we = 0;
                    from_address = Instruction[5:3];
                    to_address = Instruction[8:6];
                    upto = Instruction[2:0];
                    rf_op = 1;
                    nextState <= S0;
                end
                S7:
                begin
                    //descending
                    display_op = 0;
                    RF_we = 0;
                    from_address = Instruction[5:3];
                    to_address = Instruction[8:6];
                    upto = Instruction[2:0];
                    rf_op = 2;
                    nextState <= S0;
                end
                default: nextState <= S0;
            endcase
        
        end
    end

endmodule
//---------------------------------------------------------------------------

//---------------------------ALU Module--------------------------------------
module ALU(
    input logic[3:0] RF_d1, RF_d2,
    output logic[3:0] ALU_out,
    input logic[2:0] ALU_operation
);

always_comb
    case(ALU_operation)
    0: //add
    begin
        ALU_out = RF_d1 + RF_d2;
    end
    1: //subtract
    begin
        ALU_out = RF_d1 - RF_d2;
    end
    
    default : ALU_out = ALU_out;
    endcase

endmodule
//----------------------------------------------------

module Processor(
    input logic CLK100MHZ,
    input logic reset,
    input logic leftBtn, rightBtn, middleBtn, upperBtn,
    input logic[15:0] sw,
    output logic[11:0] LED,
    output logic[6:0] seg,
    output logic dp,
    output logic[3:0] an
//    output logic pulse
);

    //----------------------use only for testing purposes-----------------------
//    customTimer timer(.CLK(CLK100MHZ), .tick(pulse));

    assign dp = 1;

    logic[11:0] switches_instruction;
    assign switches_instruction = sw[11:0];
    logic[6:0] switches_data;
    assign switches_data = sw[15:9];

    logic debounced_left, debounced_right, debounced_middle, debounced_reset, debounced_upper;
    Debouncer d0(CLK100MHZ, reset, debounced_reset, 0);
    Debouncer d1(CLK100MHZ, leftBtn, debounced_left, debounced_reset);
    Debouncer d2(CLK100MHZ, rightBtn, debounced_right, debounced_reset);
    Debouncer d3(CLK100MHZ, middleBtn, debounced_middle, debounced_reset);
    Debouncer d4(CLK100MHZ, upperBtn, debounced_upper, debounced_reset );

    logic isExternal;
    assign isExternal = debounced_right;

    logic[2:0] nextAddress;
    ProgramCounter_3bit pc(.CLK(CLK100MHZ), .clear(debounced_middle | debounced_reset ), .enable(~isExternal), .out(nextAddress), .increment(debounced_left));
    
    logic[11:0] instructionFromMem;
    InstructionMemory_Loader im(.CLK(CLK100MHZ), .switchesData(switches_instruction), .loadSwitchesData(debounced_middle), .reset(debounced_reset),  .IM_add(nextAddress), .IM_rd(instructionFromMem)); 
    
    logic[11:0] nextInstruction;
    InstructionRegister_12bit ir(CLK100MHZ, debounced_reset , 1, isExternal, debounced_left, switches_instruction, instructionFromMem, nextInstruction);
    
/*
    Controller ports:
        input logic CLK, reset,
        input logic[11:0] Instruction,
        output logic M_re, M_we, 
        output logic[2:0] M_add,
        output logic RF_we, RF_re
        output logic[2:0] RF_wa, RF_ad1, RF_ad2
*/
   
    logic M_re, M_we, RF_we;
    logic[3:0] M_add; 
    logic[2:0] RF_wa, RF_ad1, RF_ad2;
    logic[2:0] ALU_op;
    logic[1:0] display_op, rf_op;
    logic[8:0] instruction_operands; 
    logic select_src;
    logic[2:0] from_address, to_address, upto; //for asc and des
    Controller controller(CLK100MHZ, debounced_reset, nextInstruction, M_re, M_we, M_add, RF_we, RF_wa, RF_ad1, RF_ad2, ALU_op, display_op, instruction_operands, select_src, rf_op, from_address, to_address , upto);

    logic[3:0] Memory[7:0];
/*
    Register File ports:
        input logic CLK, reset
        input logic RF_we,
        input logic[2:0] RF_ad1, RF_ad2, RF_wa,
        input logic[3:0] RF_wd,
        output logic[3:0] RF_d1, RF_d2,
        input logic write_user_data,
        input logic[6:0] user_data
*/

/*
    Data memory ports:
        input logic CLK,
        input logic M_we, M_re,
        input logic[3:0] M_add,
        input logic[3:0] M_wd,
        output logic[3:0] M_rd
*/    
    logic[3:0] RF_wd, RF_d1, RF_d2;
    logic[3:0] RfMem[7:0];

    RegisterFile rf(CLK100MHZ, debounced_reset, RF_we, RF_ad1, RF_ad2, RF_wa, RF_wd, RF_d1, RF_d2, debounced_upper, switches_data, Memory, rf_op, LED, from_address,to_address , upto);    
  
    logic[3:0] M_rd;
    DataMemory dataMem(CLK100MHZ, M_we, M_re, M_add, RF_d1, M_rd);
    
    logic[3:0] ALU_out;
    ALU alu(RF_d1, RF_d2, ALU_out, ALU_op);
    assign RF_wd = select_src? M_rd : ALU_out; //a simple two to one multiplexer         
/*
    Seven Segment Display Ports
        input logic CLK,
        input logic reset,
        input logic one_second_pulse,
        input logic display_op,
        input logic[8:0] instruction_operands,
        input logic[3:0] Memory[7:0],
        output logic[6:0] seg,
        output logic dp,
        output logic[3:0] an  
*/    

    Display display(CLK100MHZ, debounced_reset, display_op, instruction_operands, Memory, seg, an);
    
endmodule

