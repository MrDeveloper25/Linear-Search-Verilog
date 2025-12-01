# generacion.py

# Lista de instrucciones MIPS en hexadecimal
instrucciones_reales = [
    "20080005",  # addi $t0, $zero, 5
    "20090003",  # addi $t1, $zero, 3
    "01095020",  # add $t2, $t0, $t1
    "ac0a0000",  # sw $t2, 0($zero)
    "8c0b0000",  # lw $t3, 0($zero)
    "016a5822",  # sub $t3, $t3, $t2
    "11090001",  # beq $t0, $t1, etiqueta
    "08000002",  # j 0x2
    "00000000",  # NOP
    "00000000"   # NOP
]

total_lineas = 1024

with open("instructions.mem", "w") as f:
    # Escribir instrucciones reales primero
    for instr in instrucciones_reales:
        f.write(instr + "\n")
    # Rellenar el resto con NOPs
    for _ in range(total_lineas - len(instrucciones_reales)):
        f.write("00000000\n")

print("Archivo instructions.mem generado con éxito.")
