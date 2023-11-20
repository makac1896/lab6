module datapath(
  input [2:0] writenum,
  input write,
  input [2:0] readnum,
  input clk,
  input [15:0] datapath_in,
  output [15:0] datapath_out,
  input vsel,
  input asel,
  input bsel,
  input loada,
  input loadb,
  input loadc,
  input loads,
  input [1:0] shift,
  input [1:0] ALUop,
  output reg Z_out
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
reg Z;


// WritebackMultiplexer
assign data_in = (vsel) ? datapath_in : datapath_out;
	


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
  .data_input({11'b0, datapath_in[4:0]}),
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


