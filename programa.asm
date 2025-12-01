# Linear Search en MIPS
# Busca el valor KEY en un arreglo de memoria

# Inicialización
addi $t0, $zero, 0       # i = 0
addi $t1, $zero, 5       # n = tamaño del arreglo
addi $t2, $zero, 3       # key = valor a buscar

loop:
    beq  $t0, $t1, not_found   # si i == n, no encontrado
    lw   $t3, 0($t0)           # cargar A[i]
    beq  $t3, $t2, found       # si A[i] == key → found
    addi $t0, $t0, 1           # i++
    j loop

found:
    sw $t0, 20($zero)          # guardar índice donde se encontró
    j end

not_found:
    addi $t0, $zero, -1        # -1 si no se encontró
    sw $t0, 20($zero)

end:
    nop

