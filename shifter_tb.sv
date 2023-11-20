module shifter_tb;

wire [15:0] sout;
reg [15:0] in;
reg [1:0] shift;
reg clk;
reg err = 0;

shifter DUT (in, shift, sout);

task  mychecker;
 input [15:0] expected_out;

 if(shifter_tb.sout !== expected_out) begin
    $display("Error. Expected %b. Output was %b", expected_out, shifter_tb.sout);
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
    //Assert input for tests
    in = 16'b1111000011001111;

    //Test 1: Unchanged
    shift = 2'b0; #10;
    $display("Checking ShiftOp: 00");
    mychecker(16'b1111000011001111); 

    //Test 2: LSL #01
    shift = 2'b01; #10;
    $display("Checking ShiftOp: 01");
    mychecker(16'b1110000110011110);

    //Test 3: LSR #10
    shift = 2'b10; #10;
    $display("Checking ShiftOp: 10");
    mychecker(16'b0111100001100111);

    //Test 4: Right Shift MSB B[15]
    shift = 2'b11; #10;
    $display("Checking ShiftOp: 11");
    mychecker(16'b1111100001100111);

    //Test 5: LSL #1
    in = 16'b0000000000000001;
    shift = 2'b01; #10;
    $display("Checking ShiftOp: 01");
    mychecker(16'b0000000000000010);
end

endmodule