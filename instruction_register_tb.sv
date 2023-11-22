`timescale 1ns/1ps

module instruction_register_tb;

parameter TIME_RESOLUTION = 1ns;

reg err = 1'b0;
reg clk, load;
reg [15:0] in;
wire [15:0] out;
wire N, V, Z, W;

instruction_register DUT(
    .clk(clk),
    .in(in),
    .load(load),
    .instruction(out)
);

task mychecker;
    input [15:0] expected_datapath_out;

    if (DUT.instruction !== expected_datapath_out) begin
        $display("Error. Expected %h. Output was %h", expected_datapath_out, DUT.instruction);
        err = 1;
    end

endtask

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    load = 1'b0; 
    #10;
    in = 16'b1101000100000001; // MOV R1, #1;
    load = 1'b1; 
    #10;
    in = 16'b1101000100000011; // MOV R1, #3;
    load = 1'b1; 
    #10;
    
    mychecker(16'b1101000100000011); // Expected output
    $stop;
end

endmodule
