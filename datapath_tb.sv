`timescale 1ns/1ps
module datapath_tb;
reg err=0;
parameter TIME_RESOLUTION = 1ns;


//inputs
  reg [2:0] writenum;
  reg write;
  reg [2:0] readnum;
  reg clk;
  reg [15:0] sximm8;
  reg [15:0] sximm5;
  reg [15:0] mdata;
  reg [7:0] PC;
  reg [1:0] vsel;
  reg asel;
  reg bsel;
  reg loada;
  reg loadb;
  reg loadc;
  reg loads;
  reg [1:0]shift;
  reg [1:0] ALUop;

  //outputs
  wire Z;
  wire N;
  wire V;
  wire signed [15:0] datapath_out;



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
					 .sximm8      (sximm8),
					 .sximm5      (sximm5),
					 .mdata       (mdata),
					 .PC       	  (PC),
                

                // outputs
                .Z     (Z),
					 .N     (N),
					 .V     (V),
                .datapath_out(datapath_out)

             );

task  mychecker;
 input expected_Z;
 input [15:0] expected_datapath_out;


 if(DUT.datapath_out !== expected_datapath_out) begin
    $display("Error. Expected %b. Output was %b", expected_datapath_out, datapath_tb.datapath_out);
    err=1;
 end

 if(DUT.Z !== expected_Z) begin
    $display("Error. Expected %b. Output was %b", expected_Z, datapath_tb.Z);
    err=1;
 end

endtask


initial begin
    clk = 0;
    forever #((TIME_RESOLUTION / 2)) clk = ~clk;
  end

 
 
initial begin
    //Instruction 1: MOV R0, #7
sximm5 = 16'd0;	 
mdata = 16'd0;
PC = 8'd0;	 

vsel = 2'b10; #5
write =1; #5
writenum = 3'd0; #5
sximm8 = 16'd7; #5

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
 
 vsel = 2'b10; #5
write =1; #5
writenum = 3'd1; #5
sximm8 = 16'd2; #5

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
 
vsel = 2'b10;
write =0;
shift = 2'b01;
#5
loada =0;
#5
//writenum = 3'd1; #5
//sximm8 = 16'd2; #5
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
    vsel = 2'b00; #5
write =1; #5
writenum = 3'd2; #5


# 90








   
    $display("Checking RISC Instruction");
    mychecker(.expected_Z(1'b0), .expected_datapath_out(16'd16));




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
  $display("Time = %t | writenum=%d | write=%d | readnum=%d | sximm8=%d | sximm5=%d | mdata=%d | PC=%d | vsel=%b | asel=%d | bsel=%d | loada=%d | loadb=%d | loadc=%d | loads=%d | shift=%b | ALUop=%b | Z=%d | N=%d | V=%d | datapath_out=%d, err=%b",
            $time, writenum, write, readnum, sximm8, sximm5, mdata, PC, vsel, asel, bsel, loada, loadb, loadc, loads, shift, ALUop, Z, N, V, datapath_out, err);
end

endmodule
