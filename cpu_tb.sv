`timescale 1ns/1ps

module cpu_tb;

parameter TIME_RESOLUTION = 1ns;

reg err = 1'b0;
reg clk, reset, s, load;
reg [15:0] in;
wire [15:0] out;
wire N, V, Z, W;

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
    .w(W)
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

    in = 16'b1101000100000001; // MOV R1, #1;
    load = 1'b1; 
    reset=1'b0;
    s=1'b1;
    #10;
    load = 1'b0;
    #50;
    
    mychecker(16'd1); // Expected output for MOV R1, #1 is 1
    $stop;
end

endmodule
