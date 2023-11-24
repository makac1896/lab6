module regfile(data_in, writenum, write, readnum, clk, data_out);
  input [15:0] data_in;
  input [2:0] writenum, readnum;
  input write, clk;
  output signed [15:0] data_out;
  
  wire [7:0] onehotWrite;
  wire [7:0] onehotRead;
  wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

  assign onehotWrite = 8'd1 << writenum;
  assign onehotRead = 8'd1 << readnum;
  
  

//load registers
regfile_load #(16) load0(
   .clk(clk),
   .en(onehotWrite[0] & write),
   .in(data_in),
   .out(R0)
);

regfile_load #(16) load1(
   .clk(clk),
   .en(onehotWrite[1] & write),
   .in(data_in),
   .out(R1)
);

regfile_load #(16) load2(
   .clk(clk),
   .en(onehotWrite[2] & write),
   .in(data_in),
   .out(R2)
);

regfile_load #(16) load3(
   .clk(clk),
   .en(onehotWrite[3] & write),
   .in(data_in),
   .out(R3)
);

regfile_load #(16) load4(
   .clk(clk),
   .en(onehotWrite[4] & write),
   .in(data_in),
   .out(R4)
);

regfile_load #(16) load5(
   .clk(clk),
   .en(onehotWrite[5] & write),
   .in(data_in),
   .out(R5)
);

regfile_load #(16) load6(
   .clk(clk),
   .en(onehotWrite[6] & write),
   .in(data_in),
   .out(R6)
);

regfile_load #(16) load7(
   .clk(clk),
   .en(onehotWrite[7] & write),
   .in(data_in),
   .out(R7)
);
  
  // implement multiplexer for reading

//   always @(*)begin //multiplexer for 8 registers
//         case(onehotRead) 
//         8'b00000001: data_out = R0;
//         8'b00000010: data_out = R1;
//         8'b00000100: data_out = R2;
//         8'b00001000: data_out = R3;
//         8'b00010000: data_out = R4;
//         8'b00100000: data_out = R5;
//         8'b01000000: data_out = R6;
//         8'b10000000: data_out = R7;
//         default : data_out = 16'bxxxxxxxxxxxxxxxx;
//         endcase
//  end

assign data_out = (onehotRead == 8'b00000001) ? R0 :
                  (onehotRead == 8'b00000010) ? R1 :
                  (onehotRead == 8'b00000100) ? R2 :
                  (onehotRead == 8'b00001000) ? R3 :
                  (onehotRead == 8'b00010000) ? R4 :
                  (onehotRead == 8'b00100000) ? R5 :
                  (onehotRead == 8'b01000000) ? R6 :
                  (onehotRead == 8'b10000000) ? R7 :
                  16'bxxxxxxxxxxxxxxxx;


endmodule: regfile

module regfile_load(clk,en,in, out);
parameter n=16; //width of register
input clk, en;
input [n-1:0] in;
output reg [n-1:0] out;
wire [n-1:0] next_out;

assign next_out = (en) ? in : out;

always @(posedge clk) begin
    out = next_out;
end
endmodule





