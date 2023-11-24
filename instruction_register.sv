module instruction_register(in, load, instruction, clk);

  parameter n = 16;  // width
  input clk, load ;
  input  [n-1:0] in ;
  output [n-1:0] instruction ;
  reg    [n-1:0] instruction ;
  wire   [n-1:0] next_out ;

  assign next_out = load ? in : instruction;

  always @(posedge clk) begin
    instruction = next_out;  
  end
endmodule

