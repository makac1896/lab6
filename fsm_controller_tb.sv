`timescale 1ns/1ps

module fsm_controller_tb;

reg clk, s, reset;
reg [2:0] opcode;
reg [1:0] op;
wire [1:0] vsel;
wire [2:0] nsel;
wire w;
wire loada, loadb, loadc, loads, asel, bsel, write;
wire [2:0] writenum, readnum;
wire [1:0] shift;

// Instantiate the FSM controller
fsm_controller uut (
    .clk(clk),
    .s(s),
    .reset(reset),
    .opcode(opcode),
    .op(op),
    .vsel(vsel),
    .nsel(nsel),
    .w(w),
    .loada(loada),
    .loadb(loadb),
    .loadc(loadc),
    .loads(loads),
    .asel(asel),
    .bsel(bsel),
    .write(write),
    .writenum(writenum),
    .readnum(readnum),
    .shift(shift)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Testbench stimulus
initial begin
    // Initialize inputs
    reset = 1;
    s = 0;
    opcode = 3'b000; // Set to an initial opcode value
    op = 2'b00; // Set to an initial op value

    // Apply reset
    #10 reset = 0; s=1;

    // Wait for a few clock cycles
    #50;

    // Example test sequence
    opcode = 3'b101; // Set opcode to MOV_Write
    op = 2'b01; // Set op to an arbitrary value

    #20;

    opcode = 3'b001; // Set opcode to addGetA
    op = 2'b10; // Set op to an arbitrary value

    #20;

    // End simulation after some time
    #1000; $stop;
end

endmodule
