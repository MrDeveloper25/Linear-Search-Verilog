// regfile.v
module regfile(
    input clk,
    input RegWrite,
    input [4:0] rs_addr,
    input [4:0] rt_addr,
    input [4:0] rd_addr,
    input [31:0] write_data,
    output [31:0] rs_data,
    output [31:0] rt_data
);
    reg [31:0] regs [0:31];
    integer i;
    initial begin
        for (i=0;i<32;i=i+1) regs[i]=32'b0;
    end

    assign rs_data = regs[rs_addr];
    assign rt_data = regs[rt_addr];

    always @(posedge clk) begin
        if (RegWrite && (rd_addr != 5'b00000)) begin
            regs[rd_addr] <= write_data;
        end
    end
endmodule
