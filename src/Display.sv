`timescale 1ns / 1ps

module Display(
    input logic CLK,
    input logic reset,
    input logic[1:0] display_op,
    input logic[8:0] instruction_operands,
    input logic[3:0] Memory[7:0],
    output logic[6:0] seg,
    output logic[3:0] an  
);

    localparam ZERO = 7'b100_0000; // 0
    localparam ONE = 7'b111_1001; // 1
    localparam TWO = 7'b010_0100; // 2
    localparam THREE = 7'b011_0000; // 3
    localparam FOUR = 7'b001_1001; //4
    localparam FIVE = 7'b001_0010; // 5
    localparam SIX = 7'b000_0010; // 6
    localparam SEVEN = 7'b111_1000; // 7
    localparam EIGHT = 7'b000_0000; // 8
    localparam NINE = 7'b001_0000; // 9
    localparam TEN = 7'b000_1000;// A
    localparam ELEVEN = 7'b000_0011; // B -> represented as small b
    localparam TWELVE = 7'b100_0110 ; // C
    localparam THIRTEEN = 7'b010_0001 ; // D -> represented as small d
    localparam FOURTEEN = 7'b000_0110 ; // E
    localparam FIFTEEN = 7'b000_1110 ; // F 
    
    localparam one_second_count = 100_000_000;
    int unsigned counter;
    logic one_second_pulse;
    
    reg [1:0] anode_select;
    reg [16:0] anode_timer;
    logic[2:0] disp_count;
    logic[3:0] disp_address;
    
    initial begin
        counter = 0;
        disp_count = 0;
    end
    
    always_ff @(posedge CLK) begin
        if(reset) begin
            counter = 0;
            anode_select <= 0;
            anode_timer <= 0;
            disp_count = 0;
        end
        else begin
            if(anode_timer == 99_999) begin
                //4ms refresh rate
                anode_timer <= 0;
                anode_select <= anode_select + 1;
            end
            else
                anode_timer <= anode_timer + 1;
                
            //one second logic
            if(one_second_pulse) begin
                if(display_op == 3) begin
                    disp_address = instruction_operands[5:3] + disp_count;
                    disp_count = disp_count + 1; 
                    if(disp_address >= 8) begin
                        disp_address = instruction_operands[5:3];
                        disp_count = 0;
                    end  
                    else if(disp_count > instruction_operands[2:0]) disp_count = 3'b000; 
                end
                one_second_pulse  <= 0;
            end
            counter  = counter + 1;
            if(counter == one_second_count) begin
                one_second_pulse <= 1;
                counter = 0;
            end
            
            //reset the disp_count is display_op was not 3
            if(display_op != 3) disp_count = 0;
        end           
    end
    
    always @(anode_select) begin
        case(anode_select)
        2'b00: an = 4'b1110;
        2'b01: an = 4'b1101;
        2'b10: an = 4'b1011; 
        2'b11: an = 4'b0111;
        endcase    
    end
    
    always @* begin
        case(display_op)
        1: //for add
        begin
            case(anode_select)
            2'b11: 
            begin
                 case(Memory[instruction_operands[5:3]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase           
            end
            2'b10: 
            begin
                case(Memory[instruction_operands[2:0]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase
            end
            2'b01: 
            begin
                seg = 7'b111_1111;
            end
            2'b00: 
            begin
                case(Memory[instruction_operands[8:6]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase            
            end
            endcase
        end
        2: // for subtract
        begin
            case(anode_select)
            2'b11: 
            begin
                 case(Memory[instruction_operands[5:3]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase           
            end
            2'b10: 
            begin
                case(Memory[instruction_operands[2:0]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase
            end
            2'b01: 
            begin
                seg = 7'b111_1111;
            end
            2'b00:
            begin
                case(Memory[instruction_operands[8:6]])
                    0: seg = ZERO;
                    1: seg = ONE;
                    2: seg = TWO;
                    3: seg = THREE;
                    4: seg = FOUR;
                    5: seg = FIVE;
                    6: seg = SIX;
                    7: seg = SEVEN;
                    8: seg = EIGHT;
                    9: seg = NINE;
                    10: seg = TEN;
                    11: seg = ELEVEN;
                    12: seg = TWELVE;
                    13: seg = THIRTEEN;
                    14: seg = FOURTEEN;
                    15: seg = FIFTEEN;
                endcase            
            end
            endcase        
        end
        3: // display content of the register files
        begin
            case(anode_select)
            2'b11: 
            begin
                case(instruction_operands[2:0])
                0: seg = ZERO;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                endcase
            end
            2'b01: seg = 7'b111_1111;
            2'b10: seg = 7'b111_1111;
            2'b00:
            begin
                case(Memory[disp_address])
                0: seg = ZERO;
                1: seg = ONE;
                2: seg = TWO;
                3: seg = THREE;
                4: seg = FOUR;
                5: seg = FIVE;
                6: seg = SIX;
                7: seg = SEVEN;
                8: seg = EIGHT;
                9: seg = NINE;
                10: seg = TEN;
                11: seg = ELEVEN;
                12: seg = TWELVE;
                13: seg = THIRTEEN;
                14: seg = FOURTEEN;
                15: seg = FIFTEEN;
                endcase
            end
            endcase  
        end
        default: 
        begin
//            disp_count = 0;
//            counter = 0;
            seg = 7'b111_1111;
        end     
        endcase
    end

       
endmodule