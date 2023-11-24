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

    // Test MOV R7, #-3 
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b110_10_111_1111_1101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R7 !== 16'b1111111111111101) begin
      err = 1;
      $display("FAILED: MOV R7, #-3");
      $stop;
    end

    // Test MOV R3, R1, LSL #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b110_00_000_011_01_001;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'd4) begin
      err = 1;
      $display("FAILED: MOV R3, R1, LSL #1");
      $stop;
    end

    // Test MOV R1, R3, LSR #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b110_00_000_001_10_011;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd2) begin
      err = 1;
      $display("FAILED: MOV R1, R3, LSR #1");
      $stop;
    end

    // Test MOV R1, R3
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b110_00_000_001_00_011;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd4) begin
      err = 1;
      $display("FAILED: MOV R1, R3");
      $stop;
    end

    // // Test MVN instruction
    // @(negedge clk);
    // in = 16'b1000000101001000;
    // load = 1;
    // #10;
    // load = 0;
    // s = 1;
    // #10
    // s = 0;
    // @(posedge w);
    // #10;
    // if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'hEF) begin
    //   err = 1;
    //   $display("FAILED: MVN R3, R1, LSL#1");
    //   $stop;
    // end

    // // Test CMP instruction
    // @(negedge clk);
    // in = 16'b1010000101001000;
    // load = 1;
    // #10;
    // load = 0;
    // s = 1;
    // #10
    // s = 0;
    // @(posedge w);
    // #10;
    // if (~Z) begin
    //   err = 1;
    //   $display("FAILED: CMP R2, R1, R0, LSL#1");
    //   $stop;
    // end

    // // Test AND instruction
    // @(negedge clk);
    // in = 16'b1011000101001000;
    // load = 1;
    // #10;
    // load = 0;
    // s = 1;
    // #10
    // s = 0;
    // @(posedge w);
    // #10;
    // if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'h10) begin
    //   err = 1;
    //   $display("FAILED: AND R4, R1, R0, LSL#1");
    //   $stop;
    // end

    if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule

