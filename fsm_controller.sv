module fsm_controller(reset,w,loads, s,op, opcode,clk,loada,loadb,loadc,asel,bsel,vsel,write,nsel);
input reset, s,clk;
input [1:0] op;
input [2:0] opcode;
output reg w, loada,loadb,loadc,asel,bsel,write,loads;
output reg [2:0] nsel;
output reg [1:0] vsel;

//define the states
`define waitState 4'b0000
`define decodeState 4'b0001
`define getLoadA 4'b0010
`define getLoadB 4'b0011 
`define WriteReg 4'b0101 
`define sximm8Write 4'b0110
`define getLoadC 4'b0111
`define Add 4'b0100
`define MVN 4'b1000
`define ADD 4'b1001
`define CMP 4'b1010
`define AND 4'b1011

//wires to drive states
wire [3:0]  next_state_reset; 
reg [3:0] current_state;
reg [3:0] next_state;

//Flip-flop module to change states
always @(posedge clk) begin
	current_state = next_state_reset;
end

//state transition logic w/ reset
assign next_state_reset = reset ? `waitState : next_state;

//cpu state transitions 
always @(*) begin     
    casex({current_state,s,opcode,op})
        //initial states
        {`waitState,6'b1xxxxx}     : next_state = `decodeState;
        {`waitState,6'bxxxxxx}     : next_state = `waitState;
        {`decodeState,6'bx11010}   : next_state = `sximm8Write;
        {`decodeState,6'bx11000}   : next_state = `getLoadB;
        {`sximm8Write,6'bxxxxxx} : next_state = `waitState;
        {`decodeState,6'bxxxxxx}   : next_state = `getLoadB;
        //Load Registers
        {`getLoadB,6'bx11000}     : next_state = `getLoadC;
        {`getLoadC,6'bxxxxx}      : next_state = `WriteReg;
        {`getLoadB,6'bx10111}     : next_state = `MVN;
        {`getLoadB,6'bx101xx}     : next_state = `getLoadA;
        {`getLoadA,6'bxxxx00}     : next_state = `ADD;
        {`getLoadA,6'bxxxx01}     : next_state = `CMP;
        {`getLoadA,6'bxxxx10}     : next_state = `AND;
        //Instructions
        {`MVN,6'bxxxxxx}      : next_state = `WriteReg;
        {`ADD, 6'bxxxxxx}     : next_state = `getLoadC;
        {`AND, 6'bxxxxxx}     : next_state = `getLoadC;
        {`CMP, 6'bxxxxxx}     : next_state = `waitState;
        default: next_state = `waitState;
    endcase
end

always @(*) begin
    case(current_state) //concat FSM outputs for conciseness and improved readability
        `waitState       : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b1_0_0_0_00_0_0_000_0_0; //underscores help with the code readability
        `decodeState     : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_0_00_0_0_000_0_0;
        `sximm8Write   : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_0_10_0_0_100_0_1;
        `getLoadA       : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_1_0_0_00_0_0_100_0_0;
        `getLoadB       : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_1_0_00_0_0_001_0_0;
        `ADD        : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_1_00_0_0_000_0_0;
        `WriteReg   : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_0_00_0_0_010_0_1;
        `getLoadC          : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_1_00_0_0_000_0_0;
        `MVN        : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_1_00_1_0_000_0_0; 
        `CMP        : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_0_00_0_0_000_1_0;
        `AND        : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b0_0_0_1_00_0_0_000_0_0;
        default     : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'bxxxxxxxxxxxxxxx;
    endcase
end

endmodule