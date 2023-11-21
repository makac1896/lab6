module datapath(
  input [2:0] writenum,
  input write,
  input [2:0] readnum,
  input clk,
  output [15:0] datapath_out,
  input [1:0] vsel,
  input asel,
  input bsel,
  input loada,
  input loadb,
  input loadc,
  input loads,
  input [15:0] sximm8,
  input [15:0] sximm5,
  input [15:0] mdata,
  input [15:0] PC,
  input [1:0] shift,
  input [1:0] ALUop,
  output reg Z_out
);

//inputs to modules
reg [15:0] data_in;
wire [15:0] data_out;
reg [15:0] in;
reg [15:0] sout;
reg [15:0] Ain;
reg [15:0] Bin;
reg [15:0] out;
reg [15:0] A3out;
reg Z;


// WritebackMultiplexer
// edit due to datapath_in***

always_comb begin

	case(vsel)
	00: data_in = datapath_out;
	01: data_in = {8'b0, PC};
	10: data_in = sximm8;
	11: data_in = mdata;	
	endcase


end 
	


//instantiate register file
regfile REGFILE (
  .data_in(data_in),
  .writenum(writenum),
  .write(write),
  .readnum(readnum),
  .clk(clk),
  .data_out(data_out)
);

// Load register 3 
reg_load #(16) A3(
   .clk(clk),
   .en(loada),
   .in(data_out),
   .out(A3out)
);

//source operand mux
source_mux_a A6(
  .sel(asel),
  .in(A3out),
  .out(Ain)
);


// Load register 4
reg_load #(16) B4(
   .clk(clk),
   .en(loadb),
   .in(data_out),
   .out(in)
);

//shifter unit
shifter U1_inst (
  .in(in),
  .shift(shift),
  .sout(sout)
);

//source operand mux 
source_mux_b B7(
  .bsel(bsel),
  .data_input(sximm5),  // edit due to datapath_in***
  .shifter_output(sout),
  .data_out(Bin)
);


// ALU
ALU alu_inst (
    .Ain(Ain),
    .Bin(Bin),
    .ALUop(ALUop),
    .out(out),
    .Z(Z)
);

// status register
always_ff @ (posedge clk) begin

	if(loads)
	 Z_out <= Z;
	 
	else
	Z_out <= Z_out;

	
	end


// To get datapath_out
reg_load #(16) C5(
   .clk(clk),
   .en(loadc),
   .in(out),
   .out(datapath_out)
);


endmodule: datapath






module reg_load(clk,en,in, out);
parameter n=16; //width of register
input clk, en;
input [n-1:0] in;
output reg [n-1:0] out;
wire [n-1:0] next_out;

assign next_out = (en) ? in : out;

always @(posedge clk) begin
    out = next_out; //nba?
end
endmodule


module source_mux_a(sel, in, out);
input sel;
input [15:0] in;
output [15:0] out;

assign out = (sel) ? 16'b0 : in;
endmodule

module source_mux_b(bsel, data_input,shifter_output, data_out);
input bsel;
input [15:0] data_input;
input [15:0] shifter_output;
output [15:0] data_out;

assign data_out = (bsel) ? data_input : shifter_output  ;
endmodule 


