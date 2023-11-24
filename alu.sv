module ALU (
    Ain, 
    Bin,
    ALUop,
    out,
    status
);

input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg [15:0] out;
output [2:0] status;

wire Z;
wire N;
wire V;




always @(*) begin
    case(ALUop)
    2'b00: out = Ain + Bin;
    2'b01: out = Ain - Bin;
    2'b10: out = Ain & Bin;
    2'b11: out = -Bin;
    default: out = Ain;
    endcase
end



assign Z = (out==16'b0) ? 1'b1 : 1'b0;
assign N = (out==16'b1xxxxxxxxxxxxxxx) ? 1'b1 : 1'b0;
assign V = (Ain[15] == 1 && Bin[15] == 0) ? 1'b0 :
			  (Ain[15] == 0 && Bin[15] == 1) ? 1'b0 :
			  (Ain[15] == 0 && Bin[15] == 0 && out[15] == 0) ? 1'b0 :
			  (Ain[15] == 1 && Bin[15] == 1 && out[15] == 1) ? 1'b0 :
			  (Ain[15] == 0  && Bin[15] == 0 && out[15] == 1) ? 1'b1 :
			  (Ain[15] == 1  && Bin[15] == 1 && out[15] == 0) ? 1'b1 : 1'b0;
			  


assign status = {N,V,Z};



    
endmodule