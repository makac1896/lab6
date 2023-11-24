// `timescale 1ns/1ps

// module cpu_tb;

// parameter TIME_RESOLUTION = 1ns;

// reg err = 1'b0;
// reg clk, reset, s, load;
// reg [15:0] in;
// wire [15:0] out;
// wire N, V, Z, w;

// cpu DUT(
//     .clk(clk),
//     .reset(reset),
//     .s(s),
//     .load(load),
//     .in(in),
//     .out(out),
//     .N(N),
//     .V(V),
//     .Z(Z),
//     .w(w)
// );

// task mychecker;
//     input [15:0] expected_datapath_out;

//     if (DUT.out !== expected_datapath_out) begin
//         $display("Error. Expected %h. Output was %h", expected_datapath_out, DUT.out);
//         err = 1;
//     end

// endtask

// // Clock generation
// initial begin
//     clk = 0;
//     forever #5 clk = ~clk;
// end

// initial begin
//     reset = 1'b1;
//     s = 1'b0;
//     load = 1'b0; 
//     #10;

//     in = 16'b110_10_000_00000100; // MOV R0, #4;
//     load = 1'b1; 
//     reset=1'b0;
//     s=1'b1;#50; 
//     #200;

//     in = 16'b110_10_001_00000010; // MOV R1, #2;
//     load = 1'b1; 
//     reset=1'b0;
//     s=1'b1;#50; 
//     #200;

//     in = 16'b110_00_000_010_01_001; // MOV R2, R1, LSL #1;
//     load = 1'b1; 
//     reset=1'b0;
//     s=1'b1;#50; 
//     #200;

//     in = 16'b101_10_010_011_00_000; // AND R3, R2, R1;
//     load = 1'b1; 
//     reset=1'b0;
//     s=1'b1;#50; 
//     #200;

//     in = 16'b101_11_000_011_00_000; // MVN R3, R3;
//     load = 1'b1; 
//     reset=1'b0;
//     s=1'b1;#100;
//     $stop; 
//     #200;

//     // in = 16'b1010000101001000; // ADD R2, R1, R0, LSL#1
//     // in = 16'b101_01_001_000_00_000; // CMP R1, R0
//     // in = 16'b101_10_001_010_01_000; // AND R2, R1, R0
//     // load = 1'b1; 
//     // reset=1'b0;
//     // s=1'b1;
//     #150; 
//     mychecker(16'd4); // Expected output for MOV R1, #1 is 1
//     #50;
//     $stop;
// end


// always @(posedge clk) begin
//   $display("Time = %t | clk=%d | reset=%d | s=%d | load=%d | in=%b | out=%b | N=%d | V=%d | Z=%d, w=%d, err=%d, ALUop=%b, out=%d",
//             $time, clk, reset, s, load, in, out, N, V, Z, w, err, DUT.ALUop, DUT.out);
// end



// endmodule

module cpu_tb;
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N,V,Z,w;

  reg err;

  cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0; 
    #10;

	 
	 
	 
    // Test MOV instruction
    in = 16'b1101000000000111;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
      $stop;
    end

	 
	 
	
    // Test MOV instruction with a different value
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1101000100000010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R1, #2");
      $stop;
    end

	 
	 
	 
	 
	 
    // Test ADD instruction
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010000101001000;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'h10) begin
      err = 1;
      $display("FAILED: ADD R2, R1, R0, LSL#1");
      $stop;
    end

	 
	 
	 
	 
	 
    // Test MVN instruction
    @(negedge clk);

    in = 16'b101_11_000_011_01_001;
    load = 1;
    #50;
    load = 0;
	 #10
    s = 1;
    #10
    s = 0;
    @(posedge w);
    #200;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'b1111111111111100) begin
      err = 1;
      $display("FAILED: MVN R3, R1, LSL#1");
      $stop;
    end

	 
	 
	 
	 
	 
    // Test CMP instruction
    @(negedge clk);
    in = 16'b1010000101001000;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w);
    #10;
    if (~Z) begin
      err = 1;
      $display("FAILED: CMP R2, R1, R0, LSL#1");
      $stop;
    end

	 
	 
	 
	 
	 
	 
    // Test AND instruction
    @(negedge clk);
    in = 16'b101_10_001_100_01_000;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w);
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd2) begin
      err = 1;
      $display("FAILED: AND R4, R1, R0, LSL#1");
      $stop;
    end

    if (~err) $display("INTERFACE OK");
    $stop;
  end


  always @(posedge clk) begin
  $display("Time = %t | clk=%d | reset=%d | s=%d | load=%d | in=%b | datapath_out=%d | N=%d | V=%d | Z=%d, w=%d, err=%d, ALUop=%b, reg_out=%d, asel=%d, write=%d, shift=%b, R3=%b",
            $time, clk, reset, s, load, in, $signed(out), N, V, Z, w, err, DUT.ALUop, $signed(DUT.out), DUT.asel,DUT.write, DUT.shift, DUT.DP.REGFILE.R3);
end

endmodule

