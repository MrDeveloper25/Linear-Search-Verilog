module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);
    always @(*) begin
        case (alu_control)
            4'b0010: alu_result = a + b;
            4'b0110: alu_result = a - b;
            4'b0000: alu_result = a & b;
            4'b0001: alu_result = a | b;
            4'b0101: alu_result = a ^ b;
            4'b0111: alu_result = ($signed(a) < $signed(b)) ? 1 : 0;
            default: alu_result = 0;
        endcase
    end

    assign zero = (alu_result == 0);
endmodule
