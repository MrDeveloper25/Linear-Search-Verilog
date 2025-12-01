// if_id.v
module if_id(
    input clk,
    input reset,
    input [31:0] pc_plus4_in,
    input [31:0] instr_in,
    output reg [31:0] pc_plus4,
    output reg [31:0] instr
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_plus4 <= 32'b0;
            instr <= 32'b0;
        end else begin
            pc_plus4 <= pc_plus4_in;
            instr <= instr_in;
        end
    end
endmodule
