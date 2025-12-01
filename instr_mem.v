// instr_mem.v
module instr_mem #(
    parameter AW = 10, // address width (words)
    parameter DW = 32
)(
    input [AW-1:0] addr_word,
    output [DW-1:0] instr
);
    reg [DW-1:0] mem [0:(1<<AW)-1];

    initial begin
        // file with 8-hex-digit words, one per line
        $readmemh("instructions.mem", mem);
    end

    assign instr = mem[addr_word];
endmodule
