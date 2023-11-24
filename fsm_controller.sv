// module fsm_controller(clk, s, reset, opcode, op, nsel, w, loada, loadb,loadc, loads, asel, bsel,vsel, write);
// input clk, s, reset;
// input [2:0] opcode;
// input [1:0] op; 
// output reg [1:0] vsel;
// output reg [2:0] nsel; //tbd and might change
// output reg w;
// output reg loada, loadb, loadc, loads, asel, bsel, write;

// //define all the states here | 0 and 31
// `define waitState 5'b00000 
// `define decode 5'b11111

// //MOV Rn, #<im8> 5
// `define MOV_Write 5'b00101

// //ADD Rd,Rn,Rm{,<sh_op>}  | 1-4
// `define addgetLoadA 5'b00001
// `define addGetB 5'b00010
// `define addADD 5'b00011
// `define addWriteReg 5'b00100

// //AND Rd,Rn,Rm{,<sh_op>}  | 5-8
// // `define AND_GetA 5'b00101
// `define AND_GetA 5'b10101 //MOV_Write uses 5 already
// `define AND_GetB 5'b00110 
// `define AND_AND 5'b00111
// `define AND_WriteReg 5'b01000 

// //MOV Rd,Rm{,<sh_op>} | 9 - 11
// `define MOV_Rd_GetB 5'b01001
// `define MOV_Rd_Shift 5'b01010 
// `define MOV_Rd_WriteReg 5'b01011 

// //MVN Rd, Rm{,<sh_op>} | 12-14
// `define MVN_GetB 5'b01100
// `define MVN_MVN 5'b01101
// `define MVN_WriteReg 5'b01110 

// //CMP Rn,Rm{,<sh_op>} 15 - 20
// `define CMP_GetA 5'b01111
// `define CMP_GetB 5'b10000
// `define CMP_CMP 5'b10001
// `define CMP_UpdateStatus 5'b10010

// reg [4:0] current_state, next_state;
// wire [4:0] next_state_reset;

// always @(posedge clk) begin
// 	current_state = next_state_reset;
// end

// assign next_state_reset = (reset==1'b1) ? `waitState : next_state; //reset logic

// always @(*) begin
//     case({current_state, s})
//     {`waitState, 1'b0}: next_state = `waitState; 
//     // {`waitState, 1'b1}: next_state = `decode;
//     {`waitState, 1'b1}: next_state = ({opcode, op}==5'b11010) ? `MOV_Write :
//                                   ({opcode, op}==5'b10110) ? `AND_GetA : 
//                                   ({opcode, op}==5'b11000) ? `MOV_Rd_GetB :
//                                   ({opcode, op}==5'b10100) ? `addGetA :
//                                   ({opcode, op}==5'b10101) ? `CMP_GetA : //CMP_GetA instructions not yet added
//                                   ({opcode, op}==5'b10111) ? `MVN_GetB :
//                                   `waitState;
//     //ADD States
//     {`addGetA, 1'b1}: next_state = `addGetB;
//     {`addGetB, 1'b1}: next_state = `addADD;
//     {`addADD, 1'b1}: next_state = `addWriteReg;
//     {`addWriteReg, 1'b1}: next_state = `waitState;
//     //MOV im8 States
//     {`MOV_Write, 1'b1}: next_state = `waitState;
//     //AND States
//     {`AND_GetA, 1'b1}: next_state = `AND_GetB;
//     {`AND_GetB, 1'b1}: next_state = `AND_AND;
//     {`AND_AND, 1'b1}: next_state = `AND_WriteReg;
//     {`AND_WriteReg, 1'b1}: next_state = `waitState;
//     //MOV Rd States
//     {`MOV_Rd_GetB, 1'b1}: next_state = `MOV_Rd_Shift;
//     {`MOV_Rd_Shift, 1'b1}: next_state = `MOV_Rd_WriteReg;
//     {`MOV_Rd_WriteReg, 1'b1}: next_state = `waitState;
//     //MVN States
//     {`MVN_GetB, 1'b1}: next_state = `MVN_MVN;
//     {`MVN_MVN, 1'b1}: next_state = `MVN_WriteReg;
//     {`MVN_WriteReg, 1'b1}: next_state = `waitState;
//     {`CMP_GetA, 1'b1}: next_state = `CMP_GetB;
//     {`CMP_GetB, 1'b1}: next_state = `CMP_CMP;
//     {`CMP_CMP, 1'b1}: next_state = `waitState;
//     // {`CMP_UpdateStatus, 1'b1}: next_state = `CMP_UpdateStatus;
//     default: next_state = 5'bxxxxx;
//     endcase
// end

// always @(*) begin 
//     case (current_state)
//         `waitState:
//             begin
//                 w = 1'b1;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b000;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `decode:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b000;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         //ADD
//         `addGetA:
//             begin
//                 w = 1'b0;
//                 loada = 1'b1;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b100;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `addGetB:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b1;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b001;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `addADD:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b1;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b100;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `addWriteReg:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b010;
//                 vsel = 2'b00;
//                 write = 1'b1;
//             end
//           //MOV im8
//         `MOV_Write:
//           begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b100;
//                 vsel = 2'b10;
//                 write = 1'b1;
//             end
//         //AND
//         `AND_GetB:
//               begin
//                     w = 1'b0;
//                     loada = 1'b0;
//                     loadb = 1'b1;
//                     loadc = 1'b0;
//                     loads = 1'b0;
//                     asel = 1'b0;
//                     bsel = 1'b0;
//                     nsel = 3'b001;
//                     vsel = 2'b11; //idk what this value should be
//                     write = 1'b0;
//                 end
//         `AND_AND:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b0;
//                       loadc = 1'b1;
//                       loads = 1'b0;
//                       asel = 1'b0;
//                       bsel = 1'b0;
//                       nsel = 3'b000;
//                       vsel = 2'b11; //idk what this value should be
//                       write = 1'b0;
//                   end
//         `AND_WriteReg:
//                   begin
//                         w = 1'b0;
//                         loada = 1'b0;
//                         loadb = 1'b0;
//                         loadc = 1'b0;
//                         loads = 1'b0;
//                         asel = 1'b0;
//                         bsel = 1'b0;
//                         nsel = 3'b010;
//                         vsel = 2'b00; //idk what this value should be
//                         write = 1'b1;
//                     end
//         `AND_GetA:
//             begin
//                   w = 1'b0;
//                   loada = 1'b1;
//                   loadb = 1'b0;
//                   loadc = 1'b0;
//                   loads = 1'b0;
//                   asel = 1'b0;
//                   bsel = 1'b0;
//                   nsel = 3'b100;
//                   vsel = 2'b00;
//                   write = 1'b0;
//               end
//                 //MVN
//         `MVN_GetB:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b1;
//                       loadc = 1'b0;
//                       loads = 1'b0;
//                       asel = 1'b0;
//                       bsel = 1'b0;
//                       nsel = 3'b001;
//                       vsel = 2'b11; //idk what this value should be
//                       write = 1'b0;
//                   end
//         `MVN_MVN:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b0;
//                       loadc = 1'b1;
//                       loads = 1'b0;
//                       asel = 1'b1;
//                       bsel = 1'b0;
//                       nsel = 3'b000;
//                       vsel = 2'b11; //idk what this value should be
//                       write = 1'b0;
//                   end
//         `MVN_WriteReg:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b0;
//                       loadc = 1'b0;
//                       loads = 1'b0;
//                       asel = 1'b0;
//                       bsel = 1'b0;
//                       nsel = 3'b010;
//                       vsel = 2'b00; //idk what this value should be
//                       write = 1'b1;
//                   end
//           //MOV rd 
//         `MOV_Rd_GetB:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b1;
//                       loadc = 1'b0;
//                       loads = 1'b0;
//                       asel = 1'b0;
//                       bsel = 1'b0;
//                       nsel = 3'b001;
//                       vsel = 2'b11; //idk what this value should be
//                       write = 1'b0;
//                   end
//         `MOV_Rd_Shift:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b0;
//                       loadc = 1'b1;
//                       loads = 1'b0;
//                       asel = 1'b1;
//                       bsel = 1'b0;
//                       nsel = 3'b000;
//                       vsel = 2'b11; //idk what this value should be
//                       write = 1'b0;
//                   end
//         `MOV_Rd_WriteReg:
//                 begin
//                       w = 1'b0;
//                       loada = 1'b0;
//                       loadb = 1'b0;
//                       loadc = 1'b0;
//                       loads = 1'b0;
//                       asel = 1'b0;
//                       bsel = 1'b0;
//                       nsel = 3'b010;
//                       vsel = 2'b00; //idk what this value should be
//                       write = 1'b1;
//                   end
//         //ADD
//         `CMP_GetA:
//             begin
//                 w = 1'b0;
//                 loada = 1'b1;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b100;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `CMP_GetB:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b1;
//                 loadc = 1'b0;
//                 loads = 1'b0;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b001;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         `CMP_CMP:
//             begin
//                 w = 1'b0;
//                 loada = 1'b0;
//                 loadb = 1'b0;
//                 loadc = 1'b0;
//                 loads = 1'b1;
//                 asel = 1'b0;
//                 bsel = 1'b0;
//                 nsel = 3'b100;
//                 vsel = 2'b00;
//                 write = 1'b0;
//             end
//         default:
//           begin
//                 w = 1'bx;
//                 loada = 1'bx;
//                 loadb = 1'bx;
//                 loadc = 1'bx;
//                 loads = 1'bx;
//                 asel = 1'bx;
//                 bsel = 1'bx;
//                 nsel = 3'bxxx;
//                 vsel = 2'bxx;
//                 write = 1'bx;
//           end 
//     endcase
// end

// endmodule


module fsm_controller(reset,w,loads, s,op, opcode,clk,loada,loadb,loadc,asel,bsel,vsel,write,nsel);
input reset, s,clk;
input [1:0] op;
input [2:0] opcode;
output reg w, loada,loadb,loadc,asel,bsel,write,loads;
output reg [2:0] nsel;
output reg [1:0] vsel;

wire [3:0]  next_state_reset; 
reg [3:0] current_state;
reg [3:0] next_state;

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

// `define waitState    4'b0110
// `define decodeState  4'b0001
// `define getLoadA     4'b1010
// `define getLoadB     4'b0111
// `define WriteReg     4'b0100
// `define sximm8Write  4'b1001
// `define getLoadC     4'b0000
// `define Add          4'b0011
// `define MVN          4'b0101
// `define ADD          4'b1010
// `define CMP          4'b1000
// `define AND          4'b0010

always @(posedge clk) begin
	current_state = next_state_reset;
end

assign next_state_reset = reset ? `waitState : next_state;

always @(*) begin     
    casex({current_state,s,opcode,op})
        //initial states
        {`waitState,6'b1xxxxx}     : next_state = `decodeState;
        {`waitState,6'bxxxxxx}     : next_state = `waitState;
        {`decodeState,6'bx11010}   : next_state = `sximm8Write;
        {`sximm8Write,6'bxxxxxx} : next_state = `waitState;
        {`decodeState,6'bxxxxxx}   : next_state = `getLoadB;
        //Load Registers
        {`getLoadB,6'bx11000}     : next_state = `getLoadC;
        {`getLoadC,6'bxxxxx}         : next_state = `WriteReg;
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
        `waitState       : {w, loada, loadb, loadc, vsel, asel, bsel, nsel, loads, write} = 15'b1_0_0_0_00_0_0_000_0_0;
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