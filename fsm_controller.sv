module fsm_controller(clk, s, reset, opcode, op, nsel, w, loada, loadb,loadc, loads, asel, bsel,vsel, write,writenum, readnum);
input clk, s, reset;
input [2:0] opcode;
input [1:0] op; 
output reg [1:0] vsel;
output reg [2:0] nsel; //tbd and might change
output reg w;
output reg loada, loadb, loadc, loads, asel, bsel, write;
output reg [2:0] writenum, readnum;

//define all the states here | 0 and 31
`define waitState 5'b00000 
`define decode 5'b11111

//MOV Rn, #<im8> 5
`define MOV_Write 5'b00101

//ADD Rd,Rn,Rm{,<sh_op>}  | 1-4
`define addGetA 5'b00001
`define addGetB 5'b00010
`define addADD 5'b00011
`define addWriteReg 5'b00100

//AND Rd,Rn,Rm{,<sh_op>}  | 5-8
`define AND_GetA 5'b00101 
`define AND_GetB 5'b00110 
`define AND_AND 5'b00111
`define AND_WriteReg 5'b01000 

//MOV Rd,Rm{,<sh_op>} | 9 - 11
`define MOV_Rd_GetB 5'b01001
`define MOV_Rd_Shift 5'b01010 
`define MOV_Rd_WriteReg 5'b01011 

//MVN Rd, Rm{,<sh_op>} | 12-14
`define MVN_GetB 5'b01100
`define MVN_MVN 5'b01101
`define MVN_WriteReg 5'b01110 

//CMP Rn,Rm{,<sh_op>}

reg [4:0] current_state, next_state;

always_ff @(clk) begin 
  current_state <= (reset) ? `waitState : next_state;
end

always_comb begin
    case({current_state, s})
    {`waitState, 1'b0}: next_state = `waitState; 
    {`waitState, 1'b1}: next_state = `decode;
    {`decode, 1'b1}: next_state = ({opcode, op}==5'b11010) ? `MOV_Write :
                                  ({opcode, op}==5'b11000) ? `MOV_Rd_GetB :
                                  ({opcode, op}==5'b10100) ? `addGetA :
                                  ({opcode, op}==5'b10101) ? `CMP : //cmp instructions not yet added
                                  ({opcode, op}==5'b10110) ? `AND_GetA : 
                                  ({opcode, op}==5'b10111) ? `MVN_GetB :
                                  `decode;
    //ADD States
    {`addGetA, 1'b1}: next_state = `addGetB;
    {`addGetB, 1'b1}: next_state = `addADD;
    {`addADD, 1'b1}: next_state = `addWriteReg;
    {`addWriteReg, 1'b1}: next_state = `waitState;
    //MOV im8 States
    {`MOV_Write, 1'b1}: next_state = `waitState;
    //AND States
    {`AND_GetA, 1'b1}: next_state = `AND_GetB;
    {`AND_GetB, 1'b1}: next_state = `AND_AND;
    {`AND_AND, 1'b1}: next_state = `AND_WriteReg;
    {`AND_WriteReg, 1'b1}: next_state = `waitState;
    //MOV Rd States
    {`MOV_Rd_GetB, 1'b1}: next_state = `MOV_Rd_Shift;
    {`MOV_Rd_Shift, 1'b1}: next_state = `MOV_Rd_WriteReg;
    {`MOV_Rd_WriteReg, 1'b1}: next_state = `waitState;
    //MVN States
    {`MVN_GetB, 1'b1}: next_state = `MVN_MVN;
    {`MVN_MVN, 1'b1}: next_state = `MVN_WriteReg;
    {`MVN_WriteReg, 1'b1}: next_state = `waitState;
    default: next_state = 6'bxxxxxx;
    endcase
end

always_comb begin
    case (current_state)
        `waitState:
            begin
                w = 1'b1;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b000;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
            end
        //ADD
        `addGetA:
            begin
                w = 1'b0;
                loada = 1'b1;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
            end
          `addGetB:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b1;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b001;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
            end
          `addADD:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b1;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b00;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
            end
          `addWriteReg:
            begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b010;
                vsel = 2'b00;
                write = 1'b1;
                writenum = 3'b000;
                readnum = 3'b000;
            end
          //MOV im8
          `MOV_Write:
          begin
                w = 1'b0;
                loada = 1'b0;
                loadb = 1'b0;
                loadc = 1'b0;
                loads = 1'b0;
                asel = 1'b0;
                bsel = 1'b0;
                nsel = 3'b100;
                vsel = 2'b10;
                write = 1'b0;
                writenum = 3'b000;
                readnum = 3'b000;
            end
            //AND
            `AND_GetA:
            begin
                  w = 1'b0;
                  loada = 1'b1;
                  loadb = 1'b0;
                  loadc = 1'b0;
                  loads = 1'b0;
                  asel = 1'b0;
                  bsel = 1'b0;
                  nsel = 3'b100;
                  vsel = 2'b11; //idk what this value should be
                  write = 1'b0;
                  writenum = 3'b000;
                  readnum = 3'b000;
              end
              `AND_GetB:
              begin
                    w = 1'b0;
                    loada = 1'b0;
                    loadb = 1'b1;
                    loadc = 1'b0;
                    loads = 1'b0;
                    asel = 1'b0;
                    bsel = 1'b0;
                    nsel = 3'b001;
                    vsel = 2'b11; //idk what this value should be
                    write = 1'b0;
                    writenum = 3'b000;
                    readnum = 3'b000;
                end
                `AND_AND:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b0;
                      loadc = 1'b1;
                      loads = 1'b0;
                      asel = 1'b0;
                      bsel = 1'b0;
                      nsel = 3'b000;
                      vsel = 2'b11; //idk what this value should be
                      write = 1'b0;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
                  `AND_WriteReg:
                  begin
                        w = 1'b0;
                        loada = 1'b0;
                        loadb = 1'b0;
                        loadc = 1'b0;
                        loads = 1'b0;
                        asel = 1'b0;
                        bsel = 1'b0;
                        nsel = 3'b000;
                        vsel = 2'b00; //idk what this value should be
                        write = 1'b1;
                        writenum = 3'b000;
                        readnum = 3'b000;
                    end
                //MVN
                `MVN_GetB:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b1;
                      loadc = 1'b0;
                      loads = 1'b0;
                      asel = 1'b0;
                      bsel = 1'b0;
                      nsel = 3'b001;
                      vsel = 2'b11; //idk what this value should be
                      write = 1'b0;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
                `MVN_MVN:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b0;
                      loadc = 1'b1;
                      loads = 1'b0;
                      asel = 1'b1;
                      bsel = 1'b0;
                      nsel = 3'b000;
                      vsel = 2'b11; //idk what this value should be
                      write = 1'b0;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
                `MVN_WriteReg:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b0;
                      loadc = 1'b1;
                      loads = 1'b0;
                      asel = 1'b0;
                      bsel = 1'b0;
                      nsel = 3'b010;
                      vsel = 2'b00; //idk what this value should be
                      write = 1'b1;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
          //MOV rd 
          `MOV_Rd_GetB:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b1;
                      loadc = 1'b0;
                      loads = 1'b0;
                      asel = 1'b0;
                      bsel = 1'b0;
                      nsel = 3'b001;
                      vsel = 2'b11; //idk what this value should be
                      write = 1'b0;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
            `MOV_Rd_Shift:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b0;
                      loadc = 1'b1;
                      loads = 1'b0;
                      asel = 1'b1;
                      bsel = 1'b0;
                      nsel = 3'b000;
                      vsel = 2'b11; //idk what this value should be
                      write = 1'b0;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
            `MOV_Rd_WriteReg:
                begin
                      w = 1'b0;
                      loada = 1'b0;
                      loadb = 1'b0;
                      loadc = 1'b0;
                      loads = 1'b0;
                      asel = 1'b0;
                      bsel = 1'b0;
                      nsel = 3'b010;
                      vsel = 2'b10; //idk what this value should be
                      write = 1'b1;
                      writenum = 3'b000;
                      readnum = 3'b000;
                  end
          default:
          begin
                w = 1'bx;
                loada = 1'bx;
                loadb = 1'bx;
                loadc = 1'bx;
                loads = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                nsel = 3'bxxx;
                vsel = 1'bx;
                write = 1'bx;
                writenum = 3'bxxx;
                readnum = 3'bxxx;
          end 
    endcase
end

endmodule