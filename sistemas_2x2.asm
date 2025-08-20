   .data
    # Constantes
    zero_float: .float 0.0
    const_1: .float 1.0
    const_neg1: .float -1.0
    epsilon: .float 0.0001      # Para verificar determinante != 0
    
    # Constantes para sistemas predefinidos
    const_2: .float 2.0
    const_3: .float 3.0
    const_4: .float 4.0
    const_5: .float 5.0
    const_7: .float 7.0
    const_8: .float 8.0
    const_10: .float 10.0
    const_12: .float 12.0
    const_13: .float 13.0
    const_neg2: .float -2.0
    
    # Coeficientes del sistema 2x2
    # a11*x + a12*y = b1
    # a21*x + a22*y = b2
    a11: .float 0.0
    a12: .float 0.0
    a21: .float 0.0
    a22: .float 0.0
    b1: .float 0.0
    b2: .float 0.0
    
    # Variables para resultados
    det_main: .float 0.0        # Determinante principal
    det_x: .float 0.0           # Determinante para x
    det_y: .float 0.0           # Determinante para y
    
    # Mensajes
    title: .asciiz "=== RESOLUCIÓN DE SISTEMAS 2x2 ===\n"
    subtitle: .asciiz "Sistema: a11*x + a12*y = b1\n"
    subtitle2: .asciiz "         a21*x + a22*y = b2\n\n"
    
    menu: .asciiz "Seleccione una opción:\n"
    option1: .asciiz "1. Ingresar sistema manualmente\n"
    option2: .asciiz "2. Usar sistema predefinido 1: 2x + 3y = 7, x - y = 1\n"
    option3: .asciiz "3. Usar sistema predefinido 2: 3x + 2y = 12, x + 4y = 10\n"
    option4: .asciiz "4. Usar sistema predefinido 3: 5x - 2y = 13, 3x + y = 8\n"
    option5: .asciiz "5. Salir\n"
    prompt_option: .asciiz "Opción: "
    
    # Prompts para entrada manual
    prompt_a11: .asciiz "Ingrese a11 (coeficiente de x en ecuación 1): "
    prompt_a12: .asciiz "Ingrese a12 (coeficiente de y en ecuación 1): "
    prompt_b1: .asciiz "Ingrese b1 (término independiente ecuación 1): "
    prompt_a21: .asciiz "Ingrese a21 (coeficiente de x en ecuación 2): "
    prompt_a22: .asciiz "Ingrese a22 (coeficiente de y en ecuación 2): "
    prompt_b2: .asciiz "Ingrese b2 (término independiente ecuación 2): "
    
    # Mensajes de resultado
    system_msg: .asciiz "\nSistema a resolver:\n"
    eq1_msg: .asciiz "Ecuación 1: "
    eq2_msg: .asciiz "Ecuación 2: "
    x_msg: .asciiz "x + "
    y_msg: .asciiz "y = "
    y_neg_msg: .asciiz "y = "
    result_title: .asciiz "\n=== RESULTADOS ===\n"
    det_msg: .asciiz "Determinante principal: "
    solution_msg: .asciiz "Solución del sistema:\n"
    x_result: .asciiz "x = "
    y_result: .asciiz "y = "
    
    # Mensajes de error
    no_solution: .asciiz "Error: El sistema no tiene solución única (determinante = 0)\n"
    invalid_option: .asciiz "Opción inválida\n"
    newline: .asciiz "\n"
    separator: .asciiz "----------------------------------------\n"

.text
.globl main

main:
    # Mostrar título
    li $v0, 4
    la $a0, title
    syscall
    
    li $v0, 4
    la $a0, subtitle
    syscall
    
    li $v0, 4
    la $a0, subtitle2
    syscall

menu_loop:
    # Mostrar menú
    li $v0, 4
    la $a0, menu
    syscall
    
    li $v0, 4
    la $a0, option1
    syscall
    
    li $v0, 4
    la $a0, option2
    syscall
    
    li $v0, 4
    la $a0, option3
    syscall
    
    li $v0, 4
    la $a0, option4
    syscall
    
    li $v0, 4
    la $a0, option5
    syscall
    
    # Solicitar opción
    li $v0, 4
    la $a0, prompt_option
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Procesar opción
    beq $t0, 1, manual_input
    beq $t0, 2, predefined_1
    beq $t0, 3, predefined_2
    beq $t0, 4, predefined_3
    beq $t0, 5, exit_program
    
    # Opción inválida
    li $v0, 4
    la $a0, invalid_option
    syscall
    j menu_loop

manual_input:
    # Solicitar coeficientes manualmente
    li $v0, 4
    la $a0, prompt_a11
    syscall
    li $v0, 6
    syscall
    swc1 $f0, a11
    
    li $v0, 4
    la $a0, prompt_a12
    syscall
    li $v0, 6
    syscall
    swc1 $f0, a12
    
    li $v0, 4
    la $a0, prompt_b1
    syscall
    li $v0, 6
    syscall
    swc1 $f0, b1
    
    li $v0, 4
    la $a0, prompt_a21
    syscall
    li $v0, 6
    syscall
    swc1 $f0, a21
    
    li $v0, 4
    la $a0, prompt_a22
    syscall
    li $v0, 6
    syscall
    swc1 $f0, a22
    
    li $v0, 4
    la $a0, prompt_b2
    syscall
    li $v0, 6
    syscall
    swc1 $f0, b2
    
    j solve_system

predefined_1:
    # Sistema: 2x + 3y = 7, x - y = 1
    lwc1 $f0, const_2
    swc1 $f0, a11
    lwc1 $f0, const_3
    swc1 $f0, a12
    lwc1 $f0, const_7
    swc1 $f0, b1
    lwc1 $f0, const_1
    swc1 $f0, a21
    lwc1 $f0, const_neg1
    swc1 $f0, a22
    lwc1 $f0, const_1
    swc1 $f0, b2
    j solve_system

predefined_2:
    # Sistema: 3x + 2y = 12, x + 4y = 10
    lwc1 $f0, const_3
    swc1 $f0, a11
    lwc1 $f0, const_2
    swc1 $f0, a12
    lwc1 $f0, const_12
    swc1 $f0, b1
    lwc1 $f0, const_1
    swc1 $f0, a21
    lwc1 $f0, const_4
    swc1 $f0, a22
    lwc1 $f0, const_10
    swc1 $f0, b2
    j solve_system

predefined_3:
    # Sistema: 5x - 2y = 13, 3x + y = 8
    lwc1 $f0, const_5
    swc1 $f0, a11
    lwc1 $f0, const_neg2
    swc1 $f0, a12
    lwc1 $f0, const_13
    swc1 $f0, b1
    lwc1 $f0, const_3
    swc1 $f0, a21
    lwc1 $f0, const_1
    swc1 $f0, a22
    lwc1 $f0, const_8
    swc1 $f0, b2
    j solve_system

solve_system:
    # Mostrar el sistema
    jal display_system
    
    # Resolver usando regla de Cramer
    jal solve_cramer
    
    li $v0, 4
    la $a0, separator
    syscall
    
    j menu_loop

exit_program:
    li $v0, 10
    syscall

# Función para mostrar el sistema
display_system:
    li $v0, 4
    la $a0, system_msg
    syscall
    
    # Ecuación 1
    li $v0, 4
    la $a0, eq1_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, a11
    syscall
    
    li $v0, 4
    la $a0, x_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, a12
    syscall
    
    li $v0, 4
    la $a0, y_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, b1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Ecuación 2
    li $v0, 4
    la $a0, eq2_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, a21
    syscall
    
    li $v0, 4
    la $a0, x_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, a22
    syscall
    
    li $v0, 4
    la $a0, y_msg
    syscall
    
    li $v0, 2
    lwc1 $f12, b2
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    jr $ra

# Función para resolver usando regla de Cramer
solve_cramer:
    # Guardar registros
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Calcular determinante principal: det = a11*a22 - a12*a21
    lwc1 $f1, a11
    lwc1 $f2, a22
    mul.s $f3, $f1, $f2     # a11 * a22
    
    lwc1 $f1, a12
    lwc1 $f2, a21
    mul.s $f4, $f1, $f2     # a12 * a21
    
    sub.s $f5, $f3, $f4     # det = a11*a22 - a12*a21
    swc1 $f5, det_main
    
    # Verificar si el determinante es cero
    abs.s $f6, $f5
    lwc1 $f7, epsilon
    c.lt.s $f6, $f7
    bc1t no_unique_solution
    
    # Mostrar determinante
    li $v0, 4
    la $a0, result_title
    syscall
    
    li $v0, 4
    la $a0, det_msg
    syscall
    
    li $v0, 2
    mov.s $f12, $f5
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Calcular det_x: b1*a22 - a12*b2
    lwc1 $f1, b1
    lwc1 $f2, a22
    mul.s $f3, $f1, $f2     # b1 * a22
    
    lwc1 $f1, a12
    lwc1 $f2, b2
    mul.s $f4, $f1, $f2     # a12 * b2
    
    sub.s $f6, $f3, $f4     # det_x = b1*a22 - a12*b2
    swc1 $f6, det_x
    
    # Calcular det_y: a11*b2 - b1*a21
    lwc1 $f1, a11
    lwc1 $f2, b2
    mul.s $f3, $f1, $f2     # a11 * b2
    
    lwc1 $f1, b1
    lwc1 $f2, a21
    mul.s $f4, $f1, $f2     # b1 * a21
    
    sub.s $f7, $f3, $f4     # det_y = a11*b2 - b1*a21
    swc1 $f7, det_y
    
    # Calcular soluciones: x = det_x/det, y = det_y/det
    div.s $f8, $f6, $f5     # x = det_x / det_main
    div.s $f9, $f7, $f5     # y = det_y / det_main
    
    # Mostrar resultados
    li $v0, 4
    la $a0, solution_msg
    syscall
    
    li $v0, 4
    la $a0, x_result
    syscall
    
    li $v0, 2
    mov.s $f12, $f8
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, y_result
    syscall
    
    li $v0, 2
    mov.s $f12, $f9
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    j cramer_done

no_unique_solution:
    li $v0, 4
    la $a0, no_solution
    syscall

cramer_done:
    # Restaurar registros
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra