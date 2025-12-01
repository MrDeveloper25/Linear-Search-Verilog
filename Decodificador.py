# -*- coding: utf-8 -*-

reg_map = { "$zero":0, "$t0":8, "$t1":9, "$t2":10, "$t3":11, "$t4":12, "$t5":13,
            "$t6":14, "$t7":15, "$s0":16, "$s1":17, "$s2":18, "$s3":19, "$s4":20,
            "$s5":21, "$s6":22, "$s7":23, "$t8":24, "$t9":25 }

# Ejemplo de programa MIPS
programa = [
    "ADDI $t0, $zero, 0",
    "ADDI $t1, $zero, 5",
    "ADDI $t2, $zero, 10",

    "LW $t3, 0($s0)",
    "BEQ $t3, $t2, 20",
    "ADDI $s0, $s0, 4",
    "ADDI $t0, $t0, 1",
    "SLT $t4, $t0, $t1",
    "BEQ $t4, $zero, 24",
    "J 12",

    "ADDI $t5, $zero, 1",
    "J 28",

    "ADDI $t5, $zero, 0"
]

def instruccion_a_binario(instr):
    parts = instr.replace(',', '').split()
    op = parts[0].upper()
    
    # R-TYPE
    if op in ["ADD","SUB","AND","OR","SLT"]:
        rd = reg_map[parts[1]]
        rs = reg_map[parts[2]]
        rt = reg_map[parts[3]]
        funct = {"ADD":32,"SUB":34,"AND":36,"OR":37,"SLT":42}[op]
        return (0<<26)|(rs<<21)|(rt<<16)|(rd<<11)|funct
    
    # I-TYPE
    elif op in ["ADDI","ANDI","ORI","XORI","SLTI"]:
        rt = reg_map[parts[1]]
        rs = reg_map[parts[2]]
        imm = int(parts[3]) & 0xFFFF
        opcode = {"ADDI":8,"ANDI":12,"ORI":13,"XORI":14,"SLTI":10}[op]
        return (opcode<<26)|(rs<<21)|(rt<<16)|imm
    
    elif op=="BEQ":
        rs = reg_map[parts[1]]
        rt = reg_map[parts[2]]
        imm = int(parts[3])//4
        return (4<<26)|(rs<<21)|(rt<<16)|(imm & 0xFFFF)
    
    elif op=="LW":
        rt = reg_map[parts[1]]
        offset, rs_reg = parts[2].replace(')','').split('(')
        rs = reg_map[rs_reg]
        imm = int(offset) & 0xFFFF
        return (35<<26)|(rs<<21)|(rt<<16)|imm
    
    elif op=="SW":
        rt = reg_map[parts[1]]
        offset, rs_reg = parts[2].replace(')','').split('(')
        rs = reg_map[rs_reg]
        imm = int(offset) & 0xFFFF
        return (43<<26)|(rs<<21)|(rt<<16)|imm
    
    # J-TYPE
    elif op=="J":
        addr = int(parts[1])//4
        return (2<<26)|(addr & 0x3FFFFFF)
    
    else:
        raise ValueError(f"Instrucción no soportada: {instr}")

# Crear archivo instructions.mem de 1024 líneas exactas
with open("instructions.mem", "w") as f:
    # 1. Escribir programa real
    for instr in programa:
        inst_bin = instruccion_a_binario(instr)
        f.write(f"{inst_bin:08x}\n")
    
    # 2. Rellenar con NOPs (00000000)
    restante = 1024 - len(programa)
    for _ in range(restante):
        f.write("00000000\n")
