# Código Arquitectura UCO

Este repositorio contiene implementaciones en ensamblador MIPS de funciones matemáticas desarrolladas para la materia de Arquitectura de Computadores de la Universidad Católica de Oriente (UCO).

## Programas Incluidos

### 1. Logaritmo Natural (`logaritmo_natural.asm`)

Implementación del logaritmo natural (ln) usando series de Taylor.

**Características:**
- Calcula ln(x) para números positivos
- Utiliza series de Taylor para la aproximación
- Normalización automática para mejorar convergencia
- Validación de entrada (solo números positivos)
- Manejo del caso especial ln(1) = 0

**Uso:**
1. Cargar el archivo en MARS
2. Ensamblar y ejecutar
3. Ingresar un número positivo cuando se solicite
4. El programa mostrará ln(número) = resultado

### 2. Tangente Hiperbólica (`tangente_hiperbolica.asm`)

Implementación de la función tangente hiperbólica (tanh) usando series de Taylor.

**Características:**
- Calcula tanh(x) para cualquier número real
- Utiliza series de Taylor: tanh(x) = x - x³/3 + 2x⁵/15 - 17x⁷/315 + ...
- Manejo de saturación para valores grandes (tanh(x) ≈ ±1)
- Advertencia automática para valores que pueden tener menor precisión
- Manejo del caso especial tanh(0) = 0

**Uso:**
1. Cargar el archivo en MARS
2. Ensamblar y ejecutar
3. Ingresar cualquier número cuando se solicite
4. El programa mostrará tanh(número) = resultado

## Requisitos

- **MARS (MIPS Assembler and Runtime Simulator)**
- Arquitectura MIPS con soporte para operaciones de punto flotante

## Características Técnicas

### Operaciones Utilizadas
- Suma, resta, multiplicación y división (operaciones básicas)
- Operaciones de punto flotante MIPS
- Gestión de pila para preservar registros
- Saltos condicionales y bucles

### Algoritmos
- **Series de Taylor**: Ambos programas utilizan expansiones en series de potencias
- **Normalización**: El logaritmo natural incluye normalización para mejorar convergencia
- **Control de precisión**: Uso de epsilon para determinar convergencia

### Registros de Punto Flotante
- `$f0-$f31`: Registros de punto flotante MIPS
- Preservación de registros en funciones
- Manejo correcto de la pila

## Instrucciones de Ejecución

1. **Instalar MARS**: Descargar desde el sitio oficial
2. **Abrir archivo**: File → Open → Seleccionar el archivo .asm
3. **Ensamblar**: Run → Assemble (o F3)
4. **Ejecutar**: Run → Go (o F5)
5. **Interactuar**: Seguir las instrucciones en pantalla

## Estructura de los Archivos

Cada programa sigue la estructura estándar MIPS:

```assembly
.data          # Sección de datos (constantes y mensajes)
.text          # Sección de código
.globl main    # Punto de entrada del programa
```

## Notas Importantes

- Los programas están optimizados para MARS
- Se utilizan únicamente operaciones aritméticas básicas
- La precisión depende del número de términos calculados en las series
- Los programas incluyen validación de entrada y manejo de errores

## Autor

Desarrollado para la materia de Arquitectura de Computadores - UCO

## Licencia

Este código es de uso académico y educativo.