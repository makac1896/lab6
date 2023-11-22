`timescale 1ns/1ps
module datapath_tb;
reg err=0;
parameter TIME_RESOLUTION = 1ns;


//inputs
  reg [2:0] writenum;
  reg write;
  reg [2:0] readnum;
  reg clk;
  reg [15:0] datapath_in;
  reg [2:0] vsel;
  reg [2:0] asel;
  reg [2:0] bsel;
  reg loada;
  reg loadb;
  reg loadc;
  reg loads;
  reg [1:0]shift;
  reg [1:0] ALUop;

  //outputs
  wire Z_out;
  wire [15:0] datapath_out;



 datapath DUT ( .clk         (clk), // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),

                // outputs
                .Z_out       (Z_out),
                .datapath_out(datapath_out)

             );

task  mychecker;
 input expected_Z_out;
 input [15:0] expected_datapath_out;


 if(DUT.datapath_out !== expected_datapath_out) begin
    $display("Error. Expected %b. Output was %b", expected_datapath_out, datapath_tb.datapath_out);
    err=1;
 end

 if(DUT.Z_out !== expected_Z_out) begin
    $display("Error. Expected %b. Output was %b", expected_Z_out, datapath_tb.Z_out);
    err=1;
 end

endtask


initial begin
    clk = 0;
    forever #((TIME_RESOLUTION / 2)) clk = ~clk;
  end

 
 
initial begin
    //Instruction 1: MOV R0, #7

vsel = 1; #5
write =1; #5
writenum = 3'd0; #5
datapath_in = 16'd7; #5

readnum = 3'd0; #5

#5 loada =1; #5
#5  loadb =1; #5
#5 shift = 2'b00; #5
#5  asel =0; #5
#5  bsel= 0; #5
#5  ALUop = 2'b00; #5
#5 loadc =1; #5
#5  loads =1; #5

# 10

   

     //Instruction 2: MOV R1, #2 (and make datapath_out == 2*R1(not used))
 
 vsel = 1; #5
write =1; #5
writenum = 3'd1; #5
datapath_in = 16'd2; #5

readnum = 3'd1; #5

#5 loada =1; #5
#5  loadb =1; #5
#5 shift = 2'b00; #5
#5  asel =0; #5
#5  bsel= 0; #5
#5  ALUop = 2'b00; #5
#5 loadc =1; #5
#5  loads =1; #5

# 10
   

//Instruction 3: (R1 + R0(LSL #2))
 
vsel = 1;
write =0;
shift = 2'b01;
#5
loada =0;
#5
//writenum = 3'd1; #5
//datapath_in = 16'd2; #5
 readnum = 3'd0;
 loadb =1;
#1
bsel= 0;
asel =0;  
ALUop = 2'b00;
 loadc =1;
loads =0;


# 10



//Instruction 3: R2 =(R1 + R0(LSL #2))
    vsel = 0; #5
write =1; #5
writenum = 3'd2; #5


# 10








   
    // $display("Checking RISC Instruction");
    // mychecker(16'b000100000, 1'b1);




// //Instruction 3: LSL R0, #1 and ADD
    // loada=0;
    // readnum=3'b000;
    // loadb=1;
    // #50;
    // loadb=0;
    // shift=2'b01;

    // bsel=0;
    // asel=0;
    // ALUop=2'b00;
    // loadc=1;
    // loads=1;
    // #50;



    $stop;
end


always @(posedge clk) begin
  $display("Time = %t | writenum=%d | write=%d | readnum=%d | datapath_in=%d | vsel=%d | asel=%d | bsel=%d | loada=%d | loadb=%d | loadc=%d | loads=%d | shift=%d | ALUop=%d | Z_out=%d | datapath_out=%d",
            $time, writenum, write, readnum, datapath_in, vsel, asel, bsel, loada, loadb, loadc, loads, shift, ALUop, Z_out, datapath_out);
end

endmodule
