// top_pipeline.v
`timescale 1ns/1ps
module top_pipeline(
    input clk,
    input reset
);
    // IF stage wires
    wire [31:0] pc_curr, pc_next, pc_plus4, instr;
    wire [9:0] pc_index;

    // instantiate PC and IM
    pc u_pc(.clk(clk), .reset(reset), .next_pc(pc_next), .pc_out(pc_curr));
    assign pc_index = pc_curr[11:2]; // word address
    instr_mem #(.AW(10)) u_im(.addr_word(pc_index), .instr(instr));
    assign pc_plus4 = pc_curr + 4;

    // IF/ID
    wire [31:0] ifid_pcplus4, ifid_instr;
    if_id u_ifid(.clk(clk), .reset(reset), .pc_plus4_in(pc_plus4), .instr_in(instr),
                 .pc_plus4(ifid_pcplus4), .instr(ifid_instr));

    // ID stage: decode fields
    wire [5:0] id_opcode = ifid_instr[31:26];
    wire [4:0] id_rs = ifid_instr[25:21];
    wire [4:0] id_rt = ifid_instr[20:16];
    wire [4:0] id_rd = ifid_instr[15:11];
    wire [5:0] id_funct = ifid_instr[5:0];
    wire [15:0] id_imm = ifid_instr[15:0];
    wire [25:0] id_jaddr = ifid_instr[25:0];

    // control signals from control unit
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [1:0] ALUOp;
    control_unit u_ctrl(.opcode(id_opcode), .RegDst(RegDst), .ALUSrc(ALUSrc),
                        .MemToReg(MemToReg), .RegWrite(RegWrite), .MemRead(MemRead),
                        .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump), .ALUOp(ALUOp));

    // register file (writeback comes from MEM/WB register)
    wire [31:0] id_rs_data, id_rt_data;
    wire [31:0] memwb_write_data;
    wire [4:0] memwb_write_reg;
    wire memwb_RegWrite;
    regfile u_rf(.clk(clk), .RegWrite(memwb_RegWrite), .rs_addr(id_rs), .rt_addr(id_rt),
                 .rd_addr(memwb_write_reg), .write_data(memwb_write_data),
                 .rs_data(id_rs_data), .rt_data(id_rt_data));

    // sign extend imm
    wire [31:0] id_sign_ext;
    sign_extend u_signext(.in(id_imm), .out(id_sign_ext));

    // ID/EX registers (carry funct and opcode)
    wire idex_RegDst, idex_ALUSrc, idex_MemToReg, idex_RegWrite, idex_MemRead, idex_MemWrite, idex_Branch;
    wire [1:0] idex_ALUOp;
    wire [31:0] idex_pcplus4, idex_rs_data, idex_rt_data, idex_sign_ext;
    wire [4:0] idex_rs, idex_rt, idex_rd;
    wire [5:0] idex_funct, idex_opcode;
    id_ex u_idex(.clk(clk), .reset(reset),
                 .RegDst_in(RegDst), .ALUSrc_in(ALUSrc), .MemToReg_in(MemToReg),
                 .RegWrite_in(RegWrite), .MemRead_in(MemRead), .MemWrite_in(MemWrite),
                 .Branch_in(Branch), .ALUOp_in(ALUOp),
                 .pc_plus4_in(ifid_pcplus4), .rs_data_in(id_rs_data), .rt_data_in(id_rt_data),
                 .sign_ext_in(id_sign_ext),
                 .rs_in(id_rs), .rt_in(id_rt), .rd_in(id_rd),
                 .funct_in(id_funct), .opcode_in(id_opcode),
                 .RegDst(idex_RegDst), .ALUSrc(idex_ALUSrc), .MemToReg(idex_MemToReg),
                 .RegWrite(idex_RegWrite), .MemRead(idex_MemRead), .MemWrite(idex_MemWrite),
                 .Branch(idex_Branch), .ALUOp(idex_ALUOp),
                 .pc_plus4(idex_pcplus4), .rs_data(idex_rs_data), .rt_data(idex_rt_data),
                 .sign_ext(idex_sign_ext), .rs(idex_rs), .rt(idex_rt), .rd(idex_rd),
                 .funct(idex_funct), .opcode(idex_opcode));

    // EX stage
    wire [31:0] alu_src_b;
    wire [4:0] write_reg;
    wire [31:0] alu_result;
    wire zero_flag;
    wire [3:0] alu_ctrl;
    alu_control u_aluctrl(.ALUOp(idex_ALUOp), .funct(idex_funct), .opcode(idex_opcode), .alu_control(alu_ctrl));

    // alu b input select
    mux2 #(.WIDTH(32)) u_mux_alu(.a(idex_rt_data), .b(idex_sign_ext), .sel(idex_ALUSrc), .y(alu_src_b));

    // ALU
    alu u_alu(.a(idex_rs_data), .b(alu_src_b), .alu_control(alu_ctrl), .alu_result(alu_result), .zero(zero_flag));

    // write register select
    assign write_reg = idex_RegDst ? idex_rd : idex_rt;

    // branch target calc
    wire [31:0] shifted = {idex_sign_ext[29:0], 2'b00};
    wire [31:0] branch_target = idex_pcplus4 + shifted;

    // EX/MEM
    wire exmem_MemToReg, exmem_RegWrite, exmem_MemRead, exmem_MemWrite, exmem_Branch;
    wire [31:0] exmem_branch_target, exmem_alu_result, exmem_rt_data;
    wire exmem_zero;
    wire [4:0] exmem_write_reg;
    ex_mem u_exmem(.clk(clk), .reset(reset),
                   .MemToReg_in(idex_MemToReg), .RegWrite_in(idex_RegWrite),
                   .MemRead_in(idex_MemRead), .MemWrite_in(idex_MemWrite),
                   .Branch_in(idex_Branch),
                   .branch_target_in(branch_target),
                   .zero_in(zero_flag),
                   .alu_result_in(alu_result),
                   .rt_data_in(idex_rt_data),
                   .write_reg_in(write_reg),
                   .MemToReg(exmem_MemToReg), .RegWrite(exmem_RegWrite),
                   .MemRead(exmem_MemRead), .MemWrite(exmem_MemWrite), .Branch(exmem_Branch),
                   .branch_target(exmem_branch_target), .zero(exmem_zero),
                   .alu_result(exmem_alu_result), .rt_data(exmem_rt_data), .write_reg(exmem_write_reg));

    // MEM stage: data memory
    wire [31:0] mem_read_data;
    data_mem #(.AW(10)) u_dm(.clk(clk), .MemWrite(exmem_MemWrite), .MemRead(exmem_MemRead),
                             .addr(exmem_alu_result), .write_data(exmem_rt_data), .read_data(mem_read_data));

    // MEM/WB
    wire memwb_MemToReg;
    wire [31:0] memwb_read_data, memwb_alu_result;
    wire [4:0] memwb_write_reg_wire;
    mem_wb u_memwb(.clk(clk), .reset(reset),
                   .MemToReg_in(exmem_MemToReg), .RegWrite_in(exmem_RegWrite),
                   .read_data_in(mem_read_data), .alu_result_in(exmem_alu_result),
                   .write_reg_in(exmem_write_reg),
                   .MemToReg(memwb_MemToReg), .RegWrite(memwb_RegWrite),
                   .read_data(memwb_read_data), .alu_result(memwb_alu_result), .write_reg(memwb_write_reg_wire));

    // WB stage: select writeback data
    assign memwb_write_data = memwb_MemToReg ? memwb_read_data : memwb_alu_result;
    assign memwb_write_reg = memwb_write_reg_wire;
    // memwb_RegWrite is already assigned from memwb_RegWrite

    // PC update logic (branch/jump)
    wire pc_src = exmem_Branch & exmem_zero;
    wire [31:0] jump_target = {ifid_pcplus4[31:28], id_jaddr, 2'b00};
    assign pc_next = (Jump) ? jump_target : (pc_src ? exmem_branch_target : pc_plus4);

endmodule
