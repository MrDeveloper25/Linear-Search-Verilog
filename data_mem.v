// data_mem.v
module data_mem #(
    parameter AW = 10
)(
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] addr, // byte address
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] mem [0:(1<<AW)-1];

    initial begin
        mem[0] = 32'h00000000;
        mem[1] = 32'h00000001;
        mem[2] = 32'h00000002;
        mem[3] = 32'h00000003;
        mem[4] = 32'h00000004;
    end

    // write on rising edge
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[AW+1:2]] <= write_data;
        end
    end

    // combinational read
    always @(*) begin
        if (MemRead) read_data = mem[addr[AW+1:2]];
        else read_data = 32'b0;
    end
endmodule
