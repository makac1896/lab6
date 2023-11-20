module ALU_tb;
    wire [15:0] out;
	reg [15:0] Ain, Bin; //Declare inputs and outputs
	reg [1:0] ALUop;
    reg err=0;
	wire Z;
    reg clk;

	ALU DUT(Ain,Bin,ALUop,out,Z);

task mychecker;
   input [15:0] expected_out;
   input expected_z;

    if(ALU_tb.out !== expected_out) begin
    $display("Error. Expected %b. Output was %b", expected_out, ALU_tb.out);
    err=1;
    end

    if(ALU_tb.Z !== expected_z) begin
    $display("Error. Expected %b. Output was %b", expected_z, ALU_tb.Z);
    err=1;
    end
endtask

initial begin
    clk = 0;
    forever begin
      #5; // Wait for 5 time units
      clk = ~clk; // Toggle the clock signal
    end
end

initial begin 
    Ain = {13'b0, 3'b111};
    Bin = {13'b0, 3'b001};

    //Test #1: Addition with no carry out //7+1 = 8
    ALUop = 2'b0;#10;
    $display("Checking: Addition");
    mychecker({12'b0, 4'b1000}, 1'b0);
    

    //Test #2: Subtraction with no carry out //7-1 = 6
    ALUop = 2'b01;#10;
    $display("Checking: Subtract");
    mychecker({12'b0, 4'b0110}, 1'b0);

    //Test #3: Bitwise with no carry out
    ALUop = 2'b10;#10;
    $display("Checking: Bitwise AND");
    mychecker({12'b0, 4'b0001}, 1'b0);

    //Test #4: Negation with no carry out //expected = 11
    ALUop = 2'b11; #10;
    $display("Checking: Negation");
    mychecker(16'b1111111111111110, 1'b0);

    //Stage 2: Carry Out Tests
    Ain = {13'b0, 3'b000};
    Bin = {13'b0, 3'b000};

    //Test #5: Subtract with carry out
    ALUop = 2'b10;#10;
    $display("Checking: Subtract with Carry");
    mychecker({12'b0, 4'b0000}, 1'b1);

    //Test #6: Add with carry out
     ALUop = 2'b10;#10;
    $display("Checking: Addition with Carry");
    mychecker({12'b0, 4'b0000}, 1'b1);
end

endmodule