module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N, V, Z, w;

wire [15:0] instruction, sximm5, sximm8, mdata; //what is mdata?? ** it's for lab 7
wire [7:0] PC;
wire [2:0] opcode, writenum, readnum, nsel;
wire [1:0] op, vsel, shift, ALUop;
wire loada, loadb, loadc, loads, asel, bsel, write;

//not used in this lab, to be added in Lab 7
assign mdata = 16'd0;
assign PC = 8'd0;

//register instantiation
instruction_register #(16) instructionRegister(
    .in(in),
    .load(load),
    .instruction(instruction),
    .clk(clk)
);

//decoder instantiation
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

//controller instantiation
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


//datapath instantiation
datapath DP(
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
    .PC(PC), 			//idk where this value is assigned or used ** It's for lab 7, handout said just make it 0
    .shift(shift),
    .ALUop(ALUop),
    .Z(Z), 			// add N and V
	.N(N),
	.V(V)
);

endmodule