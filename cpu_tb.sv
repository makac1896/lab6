`timescale 1ns/1ps

module cpu_tb;

parameter TIME_RESOLUTION = 1ns;

reg err = 1'b0;
reg clk, reset, s, load;
reg [15:0] in;
wire [15:0] out;
wire N, V, Z, w;

cpu DUT(
    .clk(clk),
    .reset(reset),
    .s(s),
    .load(load),
    .in(in),
    .out(out),
    .N(N),
    .V(V),
    .Z(Z),
    .w(w)
);

task mychecker;
    input [15:0] expected_datapath_out;

    if (DUT.out !== expected_datapath_out) begin
        $display("Error. Expected %h. Output was %h", expected_datapath_out, DUT.out);
        err = 1;
    end

endtask

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1'b1;
    s = 1'b0;
    load = 1'b0; 
    #10;

    in = 16'b1101000000000111; // MOV R0, #7;
    load = 1'b1; 
    reset=1'b0;
    s=1'b1;
    #50;
    in = 16'b1101000100000010; // MOV R1, #2;
    load = 1'b1; 
    reset=1'b0;
    s=1'b1;
    #50;
    in = 16'b1010000101001000; // ADD R2, R1, R0, LSL#1
    load = 1'b1; 
    reset=1'b0;
    s=1'b1;
    #50;
    
    mychecker(16'd1); // Expected output for MOV R1, #1 is 1
    $stop;
end


always @(posedge clk) begin
  $display("Time = %t | clk=%d | reset=%d | s=%d | load=%d | in=%b | out=%b | N=%d | V=%d | Z=%d, w=%d, err=%d, ALUop=%b, out=%d",
            $time, clk, reset, s, load, in, out, N, V, Z, w, err, DUT.ALUop, DUT.out);
end



endmodule
