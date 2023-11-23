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
  input [7:0] PC,
  input [1:0] shift,
  input [1:0] ALUop,
  output N,
  output V,
  output Z
);

//inputs to modules
wire [15:0] data_in;
wire [15:0] data_out;
reg [15:0] in;
reg [15:0] sout;
reg [15:0] Ain;
reg [15:0] Bin;
reg [15:0] out;
reg [15:0] A3out;

wire [2:0]status;
reg [2:0]statusout;


// WritebackMultiplexer
// edit due to datapath_in***


assign data_in = (vsel == 2'b00) ? datapath_out:
					  (vsel == 2'b01) ? {8'b0, PC}:
					  (vsel == 2'b10) ? sximm8:
					  (vsel == 2'b11) ? mdata: {16{1'bx}};

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
    .status(status)
);

// status register
always_ff @ (posedge clk) begin

	if(loads)
	 statusout <= status;
	 
	else
	statusout <= statusout;

	
	end
	
assign N = statusout[2];
assign V = statusout[1];
assign Z = statusout[0];


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


