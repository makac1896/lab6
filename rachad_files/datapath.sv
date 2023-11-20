module datapath(
    input wire clk,
    input wire reset,
    input wire [2:0] readnum,
    input wire [2:0] writenum,
    input wire write,
    input wire loada,
    input wire loadb,
    input wire loadc,
    input wire vsel,
    input wire loads,
    input wire asel,
    input wire bsel,
    input wire [1:0] ALUop,
    input wire [1:0] shift,
    input wire [15:0] datapath_in,
    output wire [15:0] datapath_out,
    output wire Z_out 
);

    // Declarations at the module level
    wire [15:0] data_out;
    wire [15:0] ALU_out, sout;
    reg [15:0] Ain, Bin;
    wire [15:0] A_out, B_out, C_out; // Make sure these are declared only once at the module level
    wire Z;
    reg [15:0] data_in; // Changed to 'reg' since it's driven by always_comb

    // Mux for data_in
    always_comb begin
        case (vsel)
            1'b0: data_in = datapath_out; // Changed to a constant to avoid combinational loop
            1'b1: data_in = datapath_in;
            default: data_in = 16'bx;
        endcase
    end

    // Register File instantiation
    regfile REGFILE (.data_in(data_in), .writenum(writenum), .readnum(readnum), .write(write), .clk(clk), .data_out(data_out));

    // Instantiation of vDFFE for registers A, B, and C
vDFFE #(16) A( clk, loada, data_out, A_out );

vDFFE #(16) B( clk, loadb, data_out, B_out );

vDFFE #(16) C( clk, loadc, ALU_out, C_out );


    // Shifter instantiation
    shifter U1 (.in(B_out), .shift(shift), .sout(sout)); // Use B directly

    // ALU instantiation
    ALU U2 ( .Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(ALU_out), .Z(Z) );

    // Ain Mux
always_comb begin
    case (asel)
        1'b0: Ain = A_out;   // Assuming 'A' is properly declared and accessible
        1'b1: Ain = 16'b0;
        default: Ain = 16'bx;
    endcase
end

    // Bin Mux
always_comb begin
    case (bsel)
        1'b0: Bin = sout; // Assuming 'sout' is properly declared and accessible
        1'b1: Bin = {11'b0, datapath_in[4:0]}; // Adjust according to your logic
        default: Bin = 16'bx;
    endcase
end

    // Output assignments
    assign datapath_out = C_out;

    // Status register instantiation for Z_out
    vDFFE #(1) status( clk, loads, Z, Z_out );

    
endmodule
