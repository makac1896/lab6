module fsm_controller(clk, s, reset, opcode, op, nsel, w, loada, loadb,loadc, loads, asel, bsel, shift,vsel, write,writenum, readnum);
input clk, s, reset;
input [2:0] opcode;
input [1:0] op; 
output reg [1:0] vsel;
output reg [2:0] nsel; //tbd and might change
output reg w;
output reg loada, loadb, loadc, loads, asel, bsel, write;
output reg [2:0] writenum, readnum;
output reg [1:0]shift;
output reg write;

//define all the states here
`define waitState 5'b00000 

//MOV Rn, #<im8> 5
`define MOV_Write 5'b00101
//MOV Rd, Rm {, <sh_op>} //sh_op is included in the instruction
//ADD Rd,Rn,Rm{,<sh_op>} 1-4
`define addGetA 5'b00001
`define addGetB 5'b00010
`define addADD 5'b00011
`define addWriteReg 5'b00100


//CMP Rn,Rm{,<sh_op>}
//AND Rd,Rn,Rm{,<sh_op>}
//MVN Rd,Rm{,<sh_op>}

reg [4:0] current_state, next_state;

always_ff @(clk) begin 
  current_state <= (reset) ? `waitState : next_state;
end

always_comb begin
    case(current_state)
    `waitState: next_state = `waitState; 
    `addGetA: next_state = `addGetB;
    `addGetB: next_state = `addADD;
    `addADD: next_state = `addWriteReg;
    `addWriteReg: next_state = `waitState;
    `MOV_Write: next_state = `waitState;
    default: next_state = 5'bxxxxx;
    endcase
end

always_comb begin
    case (current_state)
        `waitState:
            begin
                w = 1'b1;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b000;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
        `addGetA:
            begin
                w = 1'b0;
                loada = 1'b1;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
          `addGetB:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b1;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b001;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
          `addADD:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b1;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
          `addWriteReg:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b010;
                vsel = 2'b00;
                write = 1'b1;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
          `MOV_Write:
          begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b10;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
                shift = 2'b00;
            end
          default:
          begin
                w = 1'bx;
                loada = 1'bx;
                loadb = 1'bx;
                loadc = 1'bx;
                loads = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                nsel = 3'bxxx;
                vsel = 1'bx;
                write = 1'bx;
                writenum = 3'bxxx;
                readnum = 3'bxxx;
                shift = 2'bxx;  
          end 
    endcase
end

endmodule