module Instruction_Decoder(
  input [15:0] instruction,
  input [2:0] nsel,
  output [2:0] opcode,
  output [1:0] op,
  output [2:0] writenum,
  output [2:0] readnum,
  output [1:0] shift,
  output [15:0] sximm8,
  output [15:0] sximm5,
  output [1:0] ALUop
);

wire [2:0] Rn, Rd, Rm;
reg [2:0] num;


assign opcode = instruction [15:13];
assign op = instruction [12:11];
assign shift = instruction [4:3];
assign ALUop = instruction [12:11];


assign Rn = instruction [10:8];
assign Rd = instruction [7:5];
assign Rm = instruction [2:0];



Mux #(3) muxInDecoder (
  .Rn(Rn),
  .Rd(Rd),
  .Rm(Rm),
  .nsel(nsel),
  .num(num)
);

assign writenum = num;
assign readnum = num;



signExtend8 extend8 (
	.in(instruction [7:0]), 
	.sximm8(sximm8)
);


signExtend5 extend5 (
	.in(instruction [4:0]), 
	.sximm5(sximm5)
);





endmodule: Instruction_Decoder






module Mux(Rn, Rd, Rm, nsel, num);
  
 parameter n = 3;
  input [n-1:0] Rm, Rd, Rn ;  // inputs
  input [2:0]   nsel ; 
  output[n-1:0] num ;
  reg [n-1:0] num ;

  always_comb begin
    case(nsel) 				// what values can nsel have and how many bits is it?
      3'b100: num = Rn ;
      3'b010: num = Rd ;
      3'b001: num = Rm ;
      default: num =  {n{1'bx}} ;
    endcase
  end
endmodule: Mux






module signExtend8(in, sximm8);

input [7:0] in;
output [16:0] sximm8;
reg [16:0] sximm8;

always_comb begin
	
	 case(in)
	 
	 8'b0xxxxxxx: sximm8 = {8'b00000000, in};
	 8'b1xxxxxxx: sximm8 = {8'b11111111, in};
	 
	 
	 endcase

  end
endmodule





module signExtend5(in, sximm5);

input [4:0] in;
output [16:0] sximm5;
reg [16:0] sximm5;

always_comb begin


	 case(in)
	 
	 5'b0xxxx: sximm5 = {11'b00000000000, in};
	 5'b1xxxx: sximm5 = {11'b11111111111, in};
	 
	 
	 endcase

  end
endmodule



