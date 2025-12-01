// id_ex.v
module id_ex(
    input clk,
    input reset,
    // control inputs
    input RegDst_in, input ALUSrc_in, input MemToReg_in, input RegWrite_in,
    input MemRead_in, input MemWrite_in, input Branch_in,
    input [1:0] ALUOp_in,
    // data inputs
    input [31:0] pc_plus4_in,
    input [31:0] rs_data_in,
    input [31:0] rt_data_in,
    input [31:0] sign_ext_in,
    input [4:0] rs_in, input [4:0] rt_in, input [4:0] rd_in,
    input [5:0] funct_in,
    input [5:0] opcode_in,
    // outputs
    output reg RegDst, output reg ALUSrc, output reg MemToReg, output reg RegWrite,
    output reg MemRead, output reg MemWrite, output reg Branch,
    output reg [1:0] ALUOp,
    output reg [31:0] pc_plus4,
    output reg [31:0] rs_data, output reg [31:0] rt_data,
    output reg [31:0] sign_ext,
    output reg [4:0] rs, output reg [4:0] rt, output reg [4:0] rd,
    output reg [5:0] funct,
    output reg [5:0] opcode
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegDst <= 0; ALUSrc <= 0; MemToReg <= 0; RegWrite <= 0;
            MemRead <= 0; MemWrite <= 0; Branch <= 0; ALUOp <= 2'b00;
            pc_plus4 <= 32'd0; rs_data <= 32'd0; rt_data <= 32'd0; sign_ext <= 32'd0;
            rs <= 5'd0; rt <= 5'd0; rd <= 5'd0; funct <= 6'd0; opcode <= 6'd0;
        end else begin
            RegDst <= RegDst_in; ALUSrc <= ALUSrc_in; MemToReg <= MemToReg_in; RegWrite <= RegWrite_in;
            MemRead <= MemRead_in; MemWrite <= MemWrite_in; Branch <= Branch_in; ALUOp <= ALUOp_in;
            pc_plus4 <= pc_plus4_in; rs_data <= rs_data_in; rt_data <= rt_data_in; sign_ext <= sign_ext_in;
            rs <= rs_in; rt <= rt_in; rd <= rd_in; funct <= funct_in; opcode <= opcode_in;
        end
    end
endmodule
