`timescale 1ns/1ps

module fsm_controller_tb;

reg clk, s, reset;
reg [2:0] opcode;
reg [1:0] op;
wire [1:0] vsel;
wire [2:0] nsel;
wire w;
wire loada, loadb, loadc, loads, asel, bsel, write;

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
    .write(write)
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
    // // Example test sequence
    // s=1;
    // opcode = 3'b110; // Set opcode to MOV_Write
    // op = 2'b10; // Set op to an arbitrary value  
    // #85;
    // s=0;
    // #20;
    // s=1;
    // opcode = 3'b110; // Set opcode to MOV Rd
    // op = 2'b00; // Set op to an arbitrary value 

    // #85;
    // s=0;
    // #20; 
    // s=1;
    // opcode = 3'b101; // Set opcode to ADD
    // op = 2'b00; // Set op to an arbitrary value 
    // #85
    // s=0;
    #20; 
    s=1;
    opcode = 3'b101; // Set opcode to AND
    op = 2'b01; // Set op to an arbitrary value 
    #85
    $stop;
end


always @(posedge clk) begin
$display("Time=%t: clk=%b s=%b opcode=%b op=%b vsel=%b nsel=%b w=%b loada=%b loadb=%b loadc=%b loads=%b asel=%b bsel=%b write=%b",
              $time, clk, s, opcode, op, vsel, nsel, w, loada, loadb, loadc, loads, asel, bsel, write);
end

endmodule
