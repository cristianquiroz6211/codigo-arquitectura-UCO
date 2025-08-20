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

### 3. Método de Newton-Raphson (`newton_raphson.asm`)

Implementación del método iterativo de Newton-Raphson para encontrar raíces de ecuaciones no lineales.

**Ecuación objetivo:** f(x) = x³ - 5x + 1

**Características:**
- Encuentra las tres raíces reales de la ecuación cúbica
- Valores iniciales predefinidos para convergencia óptima
- Opción de ingresar valor inicial personalizado
- Control de convergencia con epsilon = 0.0001
- Límite de 100 iteraciones para evitar bucles infinitos
- Muestra el número de iteraciones necesarias

**Opciones del menú:**
1. Buscar raíz cerca de x = 0.2
2. Buscar raíz cerca de x = 2.0  
3. Buscar raíz cerca de x = -2.5
4. Ingresar valor inicial personalizado
5. Salir

### 4. Sistemas de Ecuaciones 2x2 (`sistemas_2x2.asm`)

Resolución de sistemas de ecuaciones lineales 2x2 usando la regla de Cramer.

**Forma del sistema:**
```
a11*x + a12*y = b1
a21*x + a22*y = b2
```

**Características:**
- Implementa la regla de Cramer completa
- Calcula determinantes automáticamente
- Verificación de solución única (det ≠ 0)
- Entrada manual de coeficientes
- Tres sistemas predefinidos para pruebas
- Visualización clara del sistema y resultados

**Sistemas predefinidos:**
1. 2x + 3y = 7, x - y = 1 → Solución: x = 2, y = 1
2. 3x + 2y = 12, x + 4y = 10 → Solución: x = 2.8, y = 1.8
3. 5x - 2y = 13, 3x + y = 8 → Solución: x = 3, y = 1

## Requisitos

- **MARS (MIPS Assembler and Runtime Simulator)**
- Arquitectura MIPS con soporte para operaciones de punto flotante

## Características Técnicas

### Operaciones Utilizadas
- Suma, resta, multiplicación y división (operaciones básicas)
- Operaciones de punto flotante MIPS
- Gestión de pila para preservar registros
- Saltos condicionales y bucles

### Algoritmos Implementados
- **Series de Taylor**: Para logaritmo natural y tangente hiperbólica
- **Método de Newton-Raphson**: Para encontrar raíces de ecuaciones no lineales
- **Regla de Cramer**: Para resolver sistemas de ecuaciones lineales
- **Normalización**: Mejora la convergencia en funciones matemáticas
- **Control de precisión**: Uso de epsilon para determinar convergencia

### Registros de Punto Flotante
- `$f0-$f31`: Registros de punto flotante MIPS
- Preservación de registros en funciones
- Manejo correcto de la pila

### Manejo de Errores
- Validación de entrada de datos
- Detección de casos especiales (determinante = 0, división por cero)
- Límites de iteración para evitar bucles infinitos
- Mensajes informativos para el usuario

## Instrucciones de Ejecución

1. **Instalar MARS**: Descargar desde el sitio oficial
2. **Abrir archivo**: File → Open → Seleccionar el archivo .asm deseado
3. **Ensamblar**: Run → Assemble (o F3)
4. **Ejecutar**: Run → Go (o F5)
5. **Interactuar**: Seguir las instrucciones del menú en pantalla

## Estructura de los Archivos

Cada programa sigue la estructura estándar MIPS:

```assembly
.data          # Sección de datos (constantes y mensajes)
.text          # Sección de código
.globl main    # Punto de entrada del programa
```

## Casos de Uso Académico

Estos programas son ideales para:
- **Aprendizaje de ensamblador MIPS**
- **Comprensión de algoritmos numéricos**
- **Práctica con operaciones de punto flotante**
- **Estudio de métodos iterativos**
- **Implementación de funciones matemáticas**

## Notas Importantes

- Los programas están optimizados para MARS
- Se utilizan únicamente operaciones aritméticas básicas
- La precisión depende del número de términos calculados en las series
- Los programas incluyen validación de entrada y manejo de errores
- Todos los menús son interactivos y fáciles de usar

## Autor

Desarrollado para la materia de Arquitectura de Computadores - UCO

## Licencia

Este código es de uso académico y educativo.