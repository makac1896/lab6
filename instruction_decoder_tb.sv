module instruction_decoder_tb;

reg [15:0] instruction, sximm5, sximm8;
reg [2:0] nsel, opcode, writenum, readnum;
reg[1:0] op, shift, ALUop;
reg err, clk;

Instruction_Decoder DUT(
    .instruction(instruction),
    .nsel(nsel),
    .opcode(opcode),
    .op(op),
    .writenum(writenum),
    .readnum(readnum),
    .shift(shift),
    .sximm5(sximm5),
    .sximm8(sximm8),
    .ALUop(AlUop)
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
    #10;
    instruction = 16'b1101000111111101; // MOV R1, #1;
    nsel=3'b100;
    #50;

    mychecker(16'b1101000111111101); // Expected output
    $stop;
end


endmodule