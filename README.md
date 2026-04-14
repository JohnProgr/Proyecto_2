# Proyecto I: Diseño digital combinacional en dispositivos programables

### 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

### 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] David Medina. Video tutorial para principiantes. Flujo abierto para TangNano 9k. Jul. de 2024. url:
https://www.youtube.com/watch?v=AKO-SaOM7BA.

[2] David Medina. Wiki tutorial sobre el uso de la TangNano 9k y el flujo abierto de herramientas. Mayo de
2024. url: https://github.com/DJosueMM/open_source_fpga_environment/wiki

[4] razavi b. (2013) fundamentals of microelectronics. segunda edición. john wiley & sons

### 3. Desarrollo

## 3.0 Descripción general del sistema

El circuito implementa un sistema digital de transmisión y recepción de datos con detección y corrección de errores, basado en el código Hamming extendido (SECDED: Single Error Correction, Double Error Detection).
El sistema se organiza en 7 grandes bloques:

1) Codificador (palabra correcta)
Entrada: una palabra binaria de 4 bits, seleccionada mediante interruptores de 4 switch [W3, W2, W1, W0].
Procesamiento:
Se calculan tres bits de paridad (P0,P1,P2) utilizando compuertas XOR. Se calcula un bit de paridad global G0
Se forma una palabra de 8 bits en formato: [G0, W3, W2, W1, P2, W0, P1, P0] correspondiente al Hamming (7,4) codificado.  
Salida: una palabra de 4 bits que corresponde al síndrome de la palabra codificada. En formato: [G0, S2, S1, S0]

2) Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [G0, W3, W2, W1, P2, W0, P1, P0] del interruptor de 8 switch.
Procesamiento:
Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [G0] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global.
Salida: Síndrome de la palabra transmitida [G1, C2, C1, C0] (utilizamos este formato para mayor comprensión del código).

3) Comparador:
Entrada: Síndrome de la palabra codificada y transmitida.
Procesamiento: 
Con compuertas XOR se comparan ambos síndromes de modo que se obtienen una coordenada en binario de la posición del error en la palabra recibida.
Casos:
Síndrome = 000 → no hay error detectado en los 7 bits principales, excluye bit global.
Si el síndrome ≠ 000 → indica la posición del bit con error.
Se revisa el bit de paridad global G0:
Si síndrome ≠ 000 y G0 falla → se corrige un error de 1 bit en la posición indicada.
Si síndrome = 000 y G0 falla → se detecta un error de 2 bits (DED) que no puede corregirse.
Salida: la posición de error que corresponde los bits comparados [eG, e2, e1, e0].

4) Corrector
Entrada: posición de error y la palabra recibida
Procesamiento:
Utilizando un mux corrige los bits presentes en la palabra recibida por el switch de 8 puertos, ignorando el bit global, utilizando la posición del error anterior.
Salida: devuelve una palabra de 5 bits que corresponde a los bits de datos que contiene la palabra recibida ya corregida.
Si el error es corregible : [0, W3, W2, W1, W0] 
Si contiene 2 errores: [1, 0, 0, 0, 0]

5) Leds de la FPGA
Recibe la palabra corregida y pinta los leds de la FPGA invirtiendo los bits.

6) Conversor de Binario a Hexadecimal
Entradas: Palabra corregida 
Procedimiento:
Realmente este modulo pasa de binario a otro número en binario que según ese orden pinta los leds del siete segmentos en hexadecimal. 
Salida: leds que pinta el siete segmentos.


## 3.2 Diagramas de bloques de cada subsistema

Subsistema 1; Codficador Hamming extendido

![Codificador Hamming extendido](/diagramas/codificador_hamming.png)

Diagrama de bloques del subsistema de codificación Hamming extendido.
Este subsistema recibe una palabra de entrada de 4 bits y genera una palabra codificada de 8 bits. Para ello calcula los bits de paridad del código Hamming y además la paridad global, lo que permite detectar y corregir errores en etapas posteriores del sistema.

Subsistema 2; Generador de error

![Generador de error](/diagramas/generador_error.png)

Diagrama de bloques del subsistema generador de error.
Este bloque simula el canal de transmisión. Recibe la palabra codificada de 8 bits y, dependiendo de la señal de control de error, genera una máscara para alterar uno o más bits mediante una operación XOR. Así se puede comprobar el funcionamiento del sistema de detección y corrección.

Subsistema 3; Decodificador de síndrome

![Decodificador de síndrome](/diagramas/decodificador_syndrome.png)

Diagrama de bloques del subsistema decodificador de síndrome.
Este subsistema recibe la palabra de 8 bits proveniente del canal y recalcula las paridades para obtener el síndrome de error. Además, verifica la paridad global, lo cual permite identificar si ocurrió un error simple, un error doble o un error en el bit de paridad global.

Subsistema 4; Corrector de error

![Corrector de error](/diagramas/corrector_error.png)

Diagrama de bloques del subsistema corrector de error.
Este bloque utiliza la palabra recibida, el síndrome y la señal de paridad global para determinar el tipo de error presente. Cuando se detecta un error simple, el sistema lo corrige; si se trata de un error doble, lo reporta sin corregirlo. Finalmente, extrae los 4 bits de información original y genera señales indicadoras del estado del error.

Subsistema 5; Visualización

![Visualización](/diagramas/visual.png)

Diagrama de bloques del subsistema de visualización.
Este subsistema toma un dato binario de 4 bits y lo convierte en el patrón correspondiente para un display de 7 segmentos. De esta manera, el valor procesado por el sistema puede observarse visualmente de forma clara.

Interconexion; 

![Interconexión general](/diagramas/interconexion.png)

Diagrama de bloques de la interconexión general del sistema.
El sistema completo inicia con una palabra de entrada de 4 bits, la cual es codificada mediante Hamming extendido para obtener una palabra de 8 bits con redundancia. Luego, el generador de error simula alteraciones en la transmisión. Posteriormente, el decodificador de síndrome analiza la palabra recibida y produce la información necesaria para que el corrector determine y trate el error. Finalmente, los datos recuperados se envían al decodificador de 7 segmentos para su visualización.

### 4. Simplificacion de ecuaciones booleanas 

## 4.1 Ejemplo de la simplificación de las ecuaciones booleanas usadas para el circuito corrector de error.

En el modulo_04 se corrigen los bits usando la información del síndrome.
Por ejemplo, pensemos en la paridad P0.
En la versión original se definía como:

P0 = w0 ⊕ 𝑤1 ⊕ 𝑤 3

Al expresarlo en álgebra booleana tradicional:

P0=( w0 * (w1 * w3)' )+( w0 * ( w1 * w3)' )+( w0 * (w1 * w3)' )+( w0 * (w1 * w3)' )

Al aplicar mapa de Karnaugh de 3 variables (w0, w1, w3), se ve que la expresión se reduce al XOR de las tres entradas:

P0 = w0 ⊕ w1 ⊕ w3

Esto muestra cómo se pasa de una expresión con 4 minterms a una sola operación XOR.

## 4.2 Ejemplo de la simplificación de las ecuaciones booleanas usadas para los leds o de los 7-segmentos

En caso de tener 4 bits de salida corregidos D3D2D1D0 y se pretende encender un LED indicador cuando el número binario es mayor que 9 (para representar A–F en hexadecimal). La tabla de verdad asociada corresponde a;



Ecuación booleana inicial (suma de minterms):
LED= (D3 * D2' * D1 * D0') + (D3 * D2' * D1 * D0) + (D3 * D2 * D1' * D0') + (D3 * D2 * D1' * D0) + (D3 * D2 * D1 * D0') + (D3 * D2 * D1 * D0)

Se puede simplicar a;

LED = D3 * (D2 + D1)


### 5. Testbench 

ara la verificación funcional del proyecto se desarrollaron varios testbenches en SystemVerilog, cada uno orientado a comprobar un bloque específico del diseño. En la carpeta src/sim se incluyeron los siguientes archivos:

tb_hamming_encoder.sv
tb_error_generator_8bit.sv
tb_seven_seg.sv
tb_top.sv
tb_top_receiver.sv
tb_top_system.sv

El objetivo de esta estrategia fue validar por separado el codificador, el generador de error, el decodificador de 7 segmentos, el receptor y el sistema completo.

5.1 Testbench del codificador Hamming

El archivo tb_hamming_encoder.sv verifica el módulo hamming_encoder.
En este testbench se aplican diferentes palabras de 4 bits a la entrada data_in, y se observa la salida code_out de 8 bits.

Los estímulos usados fueron:

0000, 0001, 0010, 0011, 0100, 0101, 0111, 1001, 1010 y 1111

Cada valor permanece activo durante 10 ns antes de pasar al siguiente.
Además, el testbench utiliza $monitor, por lo que durante la simulación se imprime en consola el tiempo, la palabra de entrada y la palabra codificada resultante.

Con este testbench se comprueba que el módulo genera correctamente la palabra codificada con sus bits de paridad y su bit de paridad global.

5.2 Testbench del generador de error

El archivo tb_error_generator_8bit.sv verifica el módulo error_generator_8bit.

En este caso se usan dos patrones de entrada:

10101010
11110000

El testbench evalúa primero el caso sin error y luego recorre las posiciones posibles del bit erróneo usando un ciclo for, activando la inserción de error durante 10 ns en cada posición.

La lógica del testbench busca comprobar que:

si el error está deshabilitado, la salida coincide con la entrada,
y si el error está habilitado, se invierte el bit correspondiente a la posición seleccionada.

Además, este testbench genera un archivo test.vcd para inspección en GTKWave.

5.3 Testbench del decodificador de 7 segmentos

El archivo tb_seven_seg.sv verifica el módulo seven_seg_decoder.

En este testbench se aplican los valores decimales del 0 al 9 a la entrada de 4 bits:

0, 1, 2, 3, 4, 5, 6, 7, 8 y 9

Cada valor se mantiene por 10 ns.
La salida display corresponde al patrón binario que activa los segmentos del display.

Este testbench permite comprobar que el módulo realiza correctamente la conversión desde binario de 4 bits hacia la codificación requerida para el display de 7 segmentos.

5.4 Testbench del transmisor superior

El archivo tb_top.sv está orientado a probar el módulo superior del transmisor.

Las señales estimuladas son:

data_in
error_enable
error_pos

y se observan las salidas:

code_out
display

Los casos aplicados fueron:

data_in = 0000, sin error
data_in = 0001, sin error
data_in = 1010, sin error
data_in = 1010, con error habilitado en posición 000
data_in = 1010, con error habilitado en posición 011
data_in = 1111, con error habilitado en posición 111

Cada caso dura 10 ns.
Además, el testbench utiliza $monitor para imprimir en consola el tiempo, los datos de entrada, la habilitación del error, la posición seleccionada, la palabra de salida y la codificación del display.

Este testbench fue pensado para verificar simultáneamente el funcionamiento del codificador, del generador de error y del decodificador de 7 segmentos dentro del transmisor.

5.5 Testbench del receptor

El archivo tb_top_receiver.sv verifica el bloque receptor aplicando directamente palabras de 8 bits al sistema.

Los patrones evaluados fueron:

8'hD2   -> caso sin error
8'hD6   -> caso con error simple
8'h52   -> caso con error en el bit de paridad global
8'hD7   -> caso con doble error



### 6. Ejercicio 2: Oscilador de anillo
Al realizar la medecion en el osciloscopio se determino una frecuencia de 9.7 MHz


Con esto se puede calcular el tiempo de propagación promedio del inversor TTL;

T = 1/f = 1/9.7 MHz

T = 103.09 nS

T = 2*N*tpd

103.09 nS = 2 * 5 * tpd

tpd = 103.09 ns/ 10

tpd = 10.39 nS


Para un oscilador de 3 inversores, el periodo de oscilacion;

T = 2 * 3 * 10.39 nS

T = 62.34 nS

Cada inversor tiene un tiempo de retatardo asociado, al disminuir la cantidad de inversores disminuye tambien el periodo de oscilacion, al usar una una pieza larga de alambre los factores fisicos no ideales de la misma se hacen mas presente, aumentando asi el periodo de oscilacion. 


### 7. Consumo de recursos 
Number of wires:                266
Number of wire bits:            508
Number of cells:                322

ALU:                            24
DFFR:                           15
DFFRE:                           1
LUT1:                           42
LUT2:                           13
LUT3:                           25
LUT4:                           75
MUX2_LUT5:                      62
MUX2_LUT6:                      24
MUX2_LUT7:                       9
MUX2_LUT8:                       2

## 8. Problemas encontrados durante el proyecto
Error en la corrección de la palabra recibida:
El sistema no corregía correctamente los bits.
Se identificó que el problema estaba en la definición incorrecta de los índices de los pines.
Problemas de conexión en hardware:
Algunas señales presentaban valores indefinidos debido a falta de resistencias pull-down.
