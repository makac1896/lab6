module fsm_controller(clk, s, reset, opcode, op, nsel, w, loada, loadb,loadc, loads, asel, bsel, shift,vsel, write,writenum, readnum);
input clk, s, reset;
input [2:0] opcode;
input [1:0] op; 
input [2:0] nsel; //tbd and might change
output reg w;
output reg loada, loadb, loadc, loads, asel, bsel, vsel, write;
output reg [2:0] writenum, readnum;
output reg shift, write;

//define all the states here
`define waitState 4'b0000 

//MOV Rn, #<im8>
//MOV Rd, Rm {, <sh_op>}
//ADD Rd,Rn,Rm{,<sh_op>} 1-4
`define addGetA 4'b0001
`define addGetB 4'b0010
`define addADD 4'b0011
`define addWriteReg 4'b0100


//CMP Rn,Rm{,<sh_op>}
//AND Rd,Rn,Rm{,<sh_op>}
//MVN Rd,Rm{,<sh_op>}

reg [3:0] current_state, next_state;


always_ff @(clk) begin 
  current_state <= (reset) ? waitState : next_state;
end

always_comb begin
    case(current_state)
    waitState: 
    addGetA: next_state = addGetB
    addGetB: next_state = addADD
    addADD: next_state = addWriteReg
    addWriteReg: next_state = waitState
    default: 
    endcase
end

always_comb begin
    case(current_state)

end

endmodule