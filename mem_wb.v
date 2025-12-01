// mem_wb.v
module mem_wb(
    input clk,
    input reset,
    input MemToReg_in, input RegWrite_in,
    input [31:0] read_data_in,
    input [31:0] alu_result_in,
    input [4:0] write_reg_in,
    output reg MemToReg, output reg RegWrite,
    output reg [31:0] read_data,
    output reg [31:0] alu_result,
    output reg [4:0] write_reg
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemToReg <= 0; RegWrite <= 0; read_data <= 32'd0; alu_result <= 32'd0; write_reg <= 5'd0;
        end else begin
            MemToReg <= MemToReg_in; RegWrite <= RegWrite_in;
            read_data <= read_data_in; alu_result <= alu_result_in; write_reg <= write_reg_in;
        end
    end
endmodule
