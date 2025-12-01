// control_unit.v
module control_unit(
    input [5:0] opcode,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);
    always @(*) begin
        // defaults
        RegDst = 0; ALUSrc = 0; MemToReg = 0; RegWrite = 0;
        MemRead = 0; MemWrite = 0; Branch = 0; Jump = 0; ALUOp = 2'b00;

        case (opcode)
            6'b000000: begin // R-type
                RegDst = 1; ALUSrc = 0; MemToReg = 0; RegWrite = 1; ALUOp = 2'b10;
            end
            6'b100011: begin // lw
                ALUSrc = 1; MemToReg = 1; RegWrite = 1; MemRead = 1; ALUOp = 2'b00;
            end
            6'b101011: begin // sw
                ALUSrc = 1; MemWrite = 1; ALUOp = 2'b00;
            end
            6'b000100: begin // beq
                ALUSrc = 0; Branch = 1; ALUOp = 2'b01;
            end
            6'b001000: begin // addi
                ALUSrc = 1; RegWrite = 1; ALUOp = 2'b00;
            end
            6'b001100, 6'b001101, 6'b001110: begin // andi, ori, xori
                ALUSrc = 1; RegWrite = 1; ALUOp = 2'b11;
            end
            6'b001010: begin // slti
                ALUSrc = 1; RegWrite = 1; ALUOp = 2'b10;
            end
            6'b000010: begin // j
                Jump = 1;
            end
            default: begin
                // NOP defaults
            end
        endcase
    end
endmodule
