   .data
    # Constantes para la serie de Taylor de tanh(x)
    const_1: .float 1.0
    const_2: .float 2.0
    const_3: .float 3.0
    const_5: .float 5.0
    const_7: .float 7.0
    const_9: .float 9.0
    const_11: .float 11.0
    const_15: .float 15.0
    const_315: .float 315.0
    const_2835: .float 2835.0
    const_14175: .float 14175.0
    const_155925: .float 155925.0
    const_neg1: .float -1.0
    zero_float: .float 0.0
    epsilon: .float 0.0001
    max_input: .float 5.0      # Límite para convergencia
    
    # Coeficientes de Bernoulli para tanh(x)
    # tanh(x) = x - x³/3 + 2x⁵/15 - 17x⁷/315 + 62x⁹/2835 - ...
    coef_1: .float 1.0         # x
    coef_3: .float -0.333333   # -x³/3
    coef_5: .float 0.133333    # 2x⁵/15
    coef_7: .float -0.053968   # -17x⁷/315
    coef_9: .float 0.021869    # 62x⁹/2835
    coef_11: .float -0.008863  # -1382x¹¹/155925
    
    # Mensajes
    prompt: .asciiz "Ingrese un número para calcular tanh(x): "
    result_msg: .asciiz "tanh("
    result_msg2: .asciiz ") = "
    newline: .asciiz "\n"
    warning_msg: .asciiz "Advertencia: Para valores grandes, el resultado puede ser impreciso\n"

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
    
    # Verificar si el valor es muy grande
    abs.s $f1, $f12
    lwc1 $f2, max_input
    c.lt.s $f2, $f1
    bc1t warning_large
    
continue_calculation:
    # Guardar el valor original para mostrar
    mov.s $f20, $f12
    
    # Llamar a función tangente hiperbólica
    jal tanh_function
    
    # Mostrar resultado
    li $v0, 4
    la $a0, result_msg
    syscall
    
    li $v0, 2
    mov.s $f12, $f20
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

warning_large:
    li $v0, 4
    la $a0, warning_msg
    syscall
    j continue_calculation

# Función tangente hiperbólica usando serie de Taylor
tanh_function:
    # Guardar registros
    addi $sp, $sp, -16
    swc1 $f20, 0($sp)
    swc1 $f22, 4($sp)
    swc1 $f24, 8($sp)
    sw $ra, 12($sp)
    
    mov.s $f20, $f12        # x original
    
    # Verificar si x = 0
    lwc1 $f1, zero_float
    c.eq.s $f12, $f1
    bc1t return_zero_tanh
    
    # Calcular x²
    mul.s $f22, $f12, $f12  # x²
    
    # Inicializar resultado con x (primer término)
    mov.s $f10, $f12        # resultado = x
    
    # Calcular términos de la serie
    # Término 2: -x³/3
    mul.s $f4, $f12, $f22   # x³
    lwc1 $f6, coef_3
    mul.s $f4, $f4, $f6     # -x³/3
    add.s $f10, $f10, $f4   # resultado += término
    
    # Término 3: 2x⁵/15
    mul.s $f4, $f4, $f22    # x⁵ (reutilizando x³ * x²)
    mul.s $f4, $f4, $f12    # x⁵
    lwc1 $f6, coef_5
    mul.s $f4, $f4, $f6     # 2x⁵/15
    add.s $f10, $f10, $f4   # resultado += término
    
    # Término 4: -17x⁷/315
    mul.s $f4, $f4, $f22    # x⁷ (reutilizando x⁵ * x²)
    mul.s $f4, $f4, $f12    # x⁷
    lwc1 $f6, coef_7
    mul.s $f4, $f4, $f6     # -17x⁷/315
    add.s $f10, $f10, $f4   # resultado += término
    
    # Término 5: 62x⁹/2835
    mul.s $f4, $f4, $f22    # x⁹ (reutilizando x⁷ * x²)
    mul.s $f4, $f4, $f12    # x⁹
    lwc1 $f6, coef_9
    mul.s $f4, $f4, $f6     # 62x⁹/2835
    add.s $f10, $f10, $f4   # resultado += término
    
    # Término 6: -1382x¹¹/155925
    mul.s $f4, $f4, $f22    # x¹¹ (reutilizando x⁹ * x²)
    mul.s $f4, $f4, $f12    # x¹¹
    lwc1 $f6, coef_11
    mul.s $f4, $f4, $f6     # -1382x¹¹/155925
    add.s $f10, $f10, $f4   # resultado += término
    
    # Verificar convergencia usando método alternativo para valores grandes
    abs.s $f1, $f20
    lwc1 $f2, max_input
    c.lt.s $f2, $f1
    bc1t use_saturation
    
    j tanh_function_done

use_saturation:
    # Para valores grandes, tanh(x) ≈ ±1
    lwc1 $f1, zero_float
    c.lt.s $f20, $f1
    bc1t negative_saturation
    
    # Positivo: resultado ≈ 1
    lwc1 $f10, const_1
    j tanh_function_done
    
negative_saturation:
    # Negativo: resultado ≈ -1
    lwc1 $f10, const_1
    lwc1 $f1, const_neg1
    mul.s $f10, $f10, $f1
    j tanh_function_done

return_zero_tanh:
    lwc1 $f10, zero_float

tanh_function_done:
    # Restaurar registros
    lwc1 $f20, 0($sp)
    lwc1 $f22, 4($sp)
    lwc1 $f24, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    
    jr $ra