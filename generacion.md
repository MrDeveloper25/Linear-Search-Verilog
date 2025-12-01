# generar_instructions_mem.py

# Lista de tus instrucciones MIPS en hexadecimal

instrucciones_reales = [
"20080005", # ejemplo: addi $t0, $zero, 5
"20090003", # ejemplo: addi $t1, $zero, 3
"01095020", # ejemplo: add $t2, $t0, $t1
"ac0a0000", # ejemplo: sw $t2, 0($zero)
"8c0b0000", # ejemplo: lw $t3, 0($zero)
"016a5822", # ejemplo: sub $t3, $t3, $t2
"11090001", # ejemplo: beq $t0, $t1, etiqueta
"08000002", # ejemplo: j 0x2
"00000000", # NOP
"00000000" # NOP
]

total_lineas = 1024

with open("instructions.mem", "w") as f: # escribe tus instrucciones reales primero
for instr in instrucciones*reales:
f.write(instr + "\n") # rellena el resto con NOPs
for * in range(total_lineas - len(instrucciones_reales)):
f.write("00000000\n")

print("Archivo instructions.mem generado con éxito.")
