module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N, V, Z, w;

wire [15:0] instruction, sximm5, sximm8, mdata, PC; //what is mdata??
wire [2:0] opcode, writenum, readnum, nsel;
wire [1:0] op, vsel, shift, ALUop;
wire loada, loadb, loadc, loads, asel, bsel, write;

instruction_register instructionRegister(
    .in(in),
    .load(load),
    .instruction(instruction),
    .clk(clk)
);

Instruction_Decoder instructionDecoder(
  .instruction(instruction),
  .nsel(nsel), //from fsm
  .opcode(opcode), //connect to fsm
  .op(op), //connect to fsm
  .writenum(writenum), //to dp
  .readnum(readnum), //to dp
  .shift(shift), //to dp
  .sximm8(sximm8), //to dp
  .sximm5(sximm5), //to dp
  .ALUop(ALUop) //to dp
);

fsm_controller FSM(
    .clk(clk),
    .s(s),
    .reset(reset),
    .opcode(opcode),
    .op(op),
    .vsel(vsel),
    .nsel(nsel),
    .w(w),
    .loada(loada),
    .loadb(loadb),
    .loadc(loadc),
    .loads(loads),
    .asel(asel),
    .bsel(bsel),
    .write(write)
);

datapath dp(
    .writenum(writenum),
    .readnum(readnum),
    .write(write),
    .clk(clk),
    .datapath_out(out),
    .vsel(vsel),
    .asel(asel),
    .bsel(bsel),
    .loada(loada),
    .loadb(loadb),
    .loadc(loadc),
    .loads(loads),
    .sximm5(sximm5),
    .sximm8(sximm8),
    .mdata(mdata),
    .PC(PC), //idk where this value is assigned or used 
    .shift(shift),
    .ALUop(AlUop),
    .Z_out(Z) // add N and V
);

endmodule