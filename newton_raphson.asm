   .data
    # Constantes para el método de Newton-Raphson
    # f(x) = x³ - 5x + 1
    # f'(x) = 3x² - 5
    const_1: .float 1.0
    const_3: .float 3.0
    const_5: .float 5.0
    const_neg5: .float -5.0
    const_neg1: .float -1.0
    zero_float: .float 0.0
    epsilon: .float 0.0001          # Tolerancia para convergencia
    max_iterations: .word 100       # Máximo número de iteraciones
    
    # Valores iniciales para las tres raíces aproximadas
    initial_guess1: .float 0.2      # Primera raíz aproximada
    initial_guess2: .float 2.0      # Segunda raíz aproximada  
    initial_guess3: .float -2.5     # Tercera raíz aproximada
    
    # Mensajes
    title: .asciiz "=== MÉTODO DE NEWTON-RAPHSON ===\n"
    subtitle: .asciiz "Encontrando raíces de f(x) = x³ - 5x + 1\n\n"
    menu: .asciiz "Seleccione una opción:\n"
    option1: .asciiz "1. Buscar raíz cerca de x = 0.2\n"
    option2: .asciiz "2. Buscar raíz cerca de x = 2.0\n"
    option3: .asciiz "3. Buscar raíz cerca de x = -2.5\n"
    option4: .asciiz "4. Ingresar valor inicial personalizado\n"
    option5: .asciiz "5. Salir\n"
    prompt_option: .asciiz "Opción: "
    prompt_custom: .asciiz "Ingrese valor inicial: "
    result_msg: .asciiz "Raíz encontrada: x = "
    iterations_msg: .asciiz "Iteraciones: "
    error_msg: .asciiz "Error: No se encontró convergencia\n"
    invalid_option: .asciiz "Opción inválida\n"
    newline: .asciiz "\n"
    separator: .asciiz "--------------------------------\n"

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
    beq $t0, 1, option_1
    beq $t0, 2, option_2
    beq $t0, 3, option_3
    beq $t0, 4, option_4
    beq $t0, 5, exit_program
    
    # Opción inválida
    li $v0, 4
    la $a0, invalid_option
    syscall
    j menu_loop

option_1:
    lwc1 $f12, initial_guess1
    j newton_raphson_call

option_2:
    lwc1 $f12, initial_guess2
    j newton_raphson_call

option_3:
    lwc1 $f12, initial_guess3
    j newton_raphson_call

option_4:
    li $v0, 4
    la $a0, prompt_custom
    syscall
    
    li $v0, 6
    syscall
    mov.s $f12, $f0
    j newton_raphson_call

newton_raphson_call:
    jal newton_raphson
    
    li $v0, 4
    la $a0, separator
    syscall
    
    j menu_loop

exit_program:
    li $v0, 10
    syscall

# Función Newton-Raphson
# Entrada: $f12 = valor inicial
# Salida: $f10 = raíz encontrada, $v0 = número de iteraciones
newton_raphson:
    # Guardar registros
    addi $sp, $sp, -20
    swc1 $f20, 0($sp)
    swc1 $f22, 4($sp)
    swc1 $f24, 8($sp)
    sw $t0, 12($sp)
    sw $ra, 16($sp)
    
    mov.s $f20, $f12    # x actual
    li $t0, 0           # contador de iteraciones
    
newton_loop:
    # Verificar máximo de iteraciones
    lw $t1, max_iterations
    bge $t0, $t1, newton_error
    
    # Calcular f(x) = x³ - 5x + 1
    jal calculate_f
    mov.s $f22, $f10    # f(x)
    
    # Verificar si ya encontramos la raíz
    abs.s $f24, $f22
    lwc1 $f1, epsilon
    c.lt.s $f24, $f1
    bc1t newton_found
    
    # Calcular f'(x) = 3x² - 5
    mov.s $f12, $f20
    jal calculate_df
    mov.s $f24, $f10    # f'(x)
    
    # Verificar que f'(x) != 0
    lwc1 $f1, zero_float
    c.eq.s $f24, $f1
    bc1t newton_error
    
    # x_nuevo = x_actual - f(x)/f'(x)
    div.s $f1, $f22, $f24
    sub.s $f20, $f20, $f1
    
    addi $t0, $t0, 1
    j newton_loop

newton_found:
    # Mostrar resultado
    li $v0, 4
    la $a0, result_msg
    syscall
    
    li $v0, 2
    mov.s $f12, $f20
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, iterations_msg
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    mov.s $f10, $f20
    move $v0, $t0
    j newton_done

newton_error:
    li $v0, 4
    la $a0, error_msg
    syscall
    
    lwc1 $f10, zero_float
    li $v0, -1

newton_done:
    # Restaurar registros
    lwc1 $f20, 0($sp)
    lwc1 $f22, 4($sp)
    lwc1 $f24, 8($sp)
    lw $t0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    
    jr $ra

# Función para calcular f(x) = x³ - 5x + 1
# Entrada: $f12 = x
# Salida: $f10 = f(x)
calculate_f:
    # f(x) = x³ - 5x + 1
    mul.s $f1, $f12, $f12   # x²
    mul.s $f1, $f1, $f12    # x³
    
    lwc1 $f2, const_neg5
    mul.s $f2, $f2, $f12    # -5x
    
    add.s $f10, $f1, $f2    # x³ - 5x
    lwc1 $f1, const_1
    add.s $f10, $f10, $f1   # x³ - 5x + 1
    
    jr $ra

# Función para calcular f'(x) = 3x² - 5
# Entrada: $f12 = x
# Salida: $f10 = f'(x)
calculate_df:
    # f'(x) = 3x² - 5
    mul.s $f1, $f12, $f12   # x²
    lwc1 $f2, const_3
    mul.s $f1, $f1, $f2     # 3x²
    
    lwc1 $f2, const_neg5
    add.s $f10, $f1, $f2    # 3x² - 5
    
    jr $ra