// ex_mem.v
module ex_mem(
    input clk,
    input reset,
    input MemToReg_in, input RegWrite_in, input MemRead_in, input MemWrite_in, input Branch_in,
    input [31:0] branch_target_in,
    input zero_in,
    input [31:0] alu_result_in,
    input [31:0] rt_data_in,
    input [4:0] write_reg_in,
    output reg MemToReg, output reg RegWrite, output reg MemRead, output reg MemWrite, output reg Branch,
    output reg [31:0] branch_target,
    output reg zero,
    output reg [31:0] alu_result,
    output reg [31:0] rt_data,
    output reg [4:0] write_reg
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemToReg <= 0; RegWrite <= 0; MemRead <= 0; MemWrite <= 0; Branch <= 0;
            branch_target <= 32'd0; zero <= 1'b0; alu_result <= 32'd0; rt_data <= 32'd0; write_reg <= 5'd0;
        end else begin
            MemToReg <= MemToReg_in; RegWrite <= RegWrite_in; MemRead <= MemRead_in; MemWrite <= MemWrite_in; Branch <= Branch_in;
            branch_target <= branch_target_in; zero <= zero_in; alu_result <= alu_result_in; rt_data <= rt_data_in; write_reg <= write_reg_in;
        end
    end
endmodule
