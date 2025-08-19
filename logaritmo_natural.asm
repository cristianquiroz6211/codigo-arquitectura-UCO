   .data
    # Constantes para la serie de Taylor
    const_1: .float 1.0
    const_2: .float 2.0
    const_3: .float 3.0
    const_4: .float 4.0
    const_5: .float 5.0
    const_6: .float 6.0
    const_7: .float 7.0
    const_8: .float 8.0
    const_neg1: .float -1.0
    zero_float: .float 0.0      # Constante para ln(1) = 0
    epsilon: .float 0.0001
    ln2: .float 0.693147
    
    # Mensajes
    prompt: .asciiz "Ingrese un número positivo: "
    result_msg: .asciiz "ln("
    result_msg2: .asciiz ") = "
    newline: .asciiz "\n"
    error_msg: .asciiz "Error: El número debe ser positivo\n"

.text
.globl main

main:
    # Solicitar número al usuario
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Leer número flotante
    li $v0, 6
    syscall
    mov.s $f12, $f0
    
    # Verificar que sea positivo
    lwc1 $f1, zero_float
    c.le.s $f12, $f1
    bc1t error_input
    
    # Llamar a función logaritmo
    jal ln_function
    
    # Mostrar resultado
    li $v0, 4
    la $a0, result_msg
    syscall
    
    li $v0, 2
    mov.s $f12, $f0
    syscall
    
    li $v0, 4
    la $a0, result_msg2
    syscall
    
    li $v0, 2
    mov.s $f12, $f10
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Terminar programa
    li $v0, 10
    syscall

error_input:
    li $v0, 4
    la $a0, error_msg
    syscall
    j main

# Función logaritmo natural
ln_function:
    # Guardar registros
    addi $sp, $sp, -12
    swc1 $f20, 0($sp)
    swc1 $f22, 4($sp)
    sw $ra, 8($sp)
    
    mov.s $f20, $f12
    
    # Verificación: Si x = 1, retornar 0
    lwc1 $f1, const_1
    c.eq.s $f12, $f1
    bc1t return_zero
    
    # Normalizar x al rango [0.5, 1]
    lwc1 $f2, const_2
    li $t0, 0
    
normalize_loop:
    c.lt.s $f12, $f1
    bc1t normalize_done
    
    div.s $f12, $f12, $f2
    addi $t0, $t0, 1
    j normalize_loop
    
normalize_done:
    # Calcular ln(1 + (x-1))
    sub.s $f12, $f12, $f1
    
    # Serie de Taylor
    mov.s $f10, $f12
    mov.s $f4, $f12
    
    li $t1, 2
    
series_loop:
    mul.s $f4, $f4, $f12
    lwc1 $f6, const_neg1
    mul.s $f4, $f4, $f6
    
    mtc1 $t1, $f6
    cvt.s.w $f6, $f6
    div.s $f4, $f4, $f6
    
    abs.s $f6, $f4
    lwc1 $f8, epsilon
    c.lt.s $f6, $f8
    bc1t series_done
    
    add.s $f10, $f10, $f4
    
    addi $t1, $t1, 1
    
    blt $t1, 50, series_loop
    
series_done:
    beqz $t0, ln_function_done
    
    mtc1 $t0, $f6
    cvt.s.w $f6, $f6
    lwc1 $f8, ln2
    mul.s $f6, $f6, $f8
    add.s $f10, $f10, $f6
    
    j ln_function_done

# Etiqueta corregida para retornar 0
return_zero:
    lwc1 $f10, zero_float       # Cargar 0.0 desde memoria
    
ln_function_done:
    # Restaurar registros
    lwc1 $f20, 0($sp)
    lwc1 $f22, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    
    jr $ra