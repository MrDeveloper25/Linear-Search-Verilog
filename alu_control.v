// alu_control.v
module alu_control(
    input [1:0] ALUOp,
    input [5:0] funct,
    input [5:0] opcode,
    output reg [3:0] alu_control
);
    // codes:
    // 0010 add, 0110 sub, 0000 and, 0001 or, 0101 xor, 0111 slt
    always @(*) begin
        if (ALUOp == 2'b00) begin
            alu_control = 4'b0010; // add (lw/sw/addi)
        end else if (ALUOp == 2'b01) begin
            alu_control = 4'b0110; // sub (beq)
        end else if (ALUOp == 2'b10) begin
            // R-type -> use funct
            case (funct)
                6'b100000: alu_control = 4'b0010; // add
                6'b100010: alu_control = 4'b0110; // sub
                6'b100100: alu_control = 4'b0000; // and
                6'b100101: alu_control = 4'b0001; // or
                6'b101010: alu_control = 4'b0111; // slt
                default:   alu_control = 4'b0010;
            endcase
        end else begin // ALUOp == 2'b11 -> immediate logicals
            case (opcode)
                6'b001100: alu_control = 4'b0000; // andi -> and
                6'b001101: alu_control = 4'b0001; // ori -> or
                6'b001110: alu_control = 4'b0101; // xori -> xor
                default:    alu_control = 4'b0010;
            endcase
        end
    end
endmodule
