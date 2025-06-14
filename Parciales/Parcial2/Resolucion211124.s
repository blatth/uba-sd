/*
Para este tipo de ejercicios siempre es mejor comenzar por la función más "simple"
para luego ir pensando en las funciones que realizan más operaciones o son más extensas.
De esta forma siento que tengo un mayor control sobre cómo debería comportarse cada implementación
de acuerdo al orden de llamada.
Siempre las versiones recursivas de las funciones son más extensas. No sé si son las ideales o
si *siempre* es mejor trabajar con funciones más directas (verificar esto último).
Rec: por convención siempre se reservan (y luego se restauran) 16 bytes en el stack. Esto es en la
materia, hay otras resoluciones donde la convesión es diferente. Recordar, siempre, hacer addi/sw 
al comenzar y lw/addi al finalizar. 
*/


# --- Ejercicio 1


# es_primo(k) -> va a recibir k en a0
es_primo:
    addi sp, sp, -16            # se reservan 16 bytes en el stack, por convención
    sw ra, 12(sp)               # se guarda el valor de ra en el stack por si se necesita llamarlo
    sw a0, 8(sp)                # se guarda el valor de k por si necesito usarlo después

    jal cantidad_divisores      # se llama a cantidad_divisores con el valor original de k = a0

    li t0, 1                    # asigno t0 := 1, valor con el que voy a comparar
    beq a0, t0, es_primo_true   # si res(cantidad_divisores) = 1 salto a es_primo_true

    li a0, 0                    # asigno a0 := 0, porque si t0 != 1 entonces es_primo debe devolver 0
    j es_primo_end              # salta al final del ciclo

es_primo_true:
    li a0, 1                    # asigno a0 := 1 porque es primo

es_primo_end:
    lw ra, 12(sp)               # restauro ra
    addi sp, sp, 16             # restauro el espacio del stack
    ret                         # llamo nuevamente la función


# cantidad_divisores(k) - versión no-recursiva -> va a recibir k en a0
cantidad_divisores:
    addi sp, sp, -16            # se reservan 16 bytes en el stack, por convención
    sw ra, 12(sp)               # se guarda el valor de ra en el stack por si se necesita llamarlo
    sw a0, 8(sp)                # se guarda el valor de k por si necesito usarlo después

    li t0, 1                    # asigno t0 := 1, valor con el que voy a comparar
    ble a0, t0, menor_igual_uno # si k <= 1, devuelve 1

    addi a1, a0, -1             # asigno a1 := k (a0) - 1
    jal cantidad_divisores_rec  # llamo a la función recursiva, que voy a tener que implementar con a0 = k y a1 = k - 1
    j cantidad_divisores_end

menor_igual_uno:
    li a0, 1                    # asigno a0 := 1 en el caso k <= 1

cantidad_divisores_end:
    lw ra, 12(sp)               # restauro ra
    addi sp, sp, 16             # restauro el espacio del stack
    ret                         # llamo nuevamente la función


# cantidad_divisores_rec(k, n) - versión recursiva -> va a recibir k en a0 y n en a1
cantidad_divisores_rec:
    addi sp, sp, -16            # se reservan 16 bytes en el stack, por convención
    sw ra, 12(sp)               # se guarda el valor de ra en el stack por si se necesita llamarlo
    sw a0, 8(sp)                # se guarda el valor de k por si necesito usarlo después
    sw a1, 4(sp)                # se guarda el valor de n por si necesito usarlo después

    li t0, 1                    # asigno t0 := 1, valor con el que voy a comparar
    beq a1, t0, caso_base       # n == 1 => caso base = 1

    addi a1, a1, -1             # a1 := n := n -1
    jal cantidad_divisores_rec  # llamada recursiva (k, n-1)

    mv t1, a0                   # guardo el resultado de la llamada recursiva en un reg temporal, en este caso t1
    lw a0, 8(sp)                # recupero el valor original de k
    lw a1, 4(sp)                # recupero el valor anterior de n

                                # una vez que se recuperan los valores originales ahora sí se puede hacer el if siguiente
    
    rem t2, a0, a1              # asigno t2 := a0 % a1 := k % n
    li t3, 0                    # asigno t3 := 0, valor con el que voy a comparar
    beq t2, t3, divisible       # si k % n == 0 => es divisible, entonces sumo 1

    mv a0, t1                   # si k % n != 0 => no es divisible, se deja el contador como está sin sumar 1, asignándole el valor temporal (t1) que guardé en la línea 71
    j cdRec_end

divisible:
    addi a0, t1, 1              # cantidad := cantidad + 1
    j cdRec_end

caso_base:
    li a0, 1                    # si n == 1 => hay un solo divisor => se devuelve 1

cdRec_end:
    lw ra, 12(sp)               # restauro ra
    addi sp, sp, 16             # restauro el espacio del stack
    ret                         # llamo nuevamente la función


# --- Ejercicio 2


# es_par(x) -> va a recibir x en a0
es_par:
    rem a0, a0, 2               # asigno a0 := a0 % 2
    reqz a0, a0                 # asigno a0 := 1 si a0 es par (si su resto dio 0), sino asigno a0 := 0
    ret

# arreglo_par(array, largo) -> va a recibir las direcciones del array en a0 y largo en a1

arreglo_par:
    addi sp, sp, -16            # se reservan 16 bytes en el stack, por convención
    sw ra, 12(sp)               # se guarda el valor de ra en el stack por si se necesita llamarlo
    sw s0, 8(sp)                # guardo s0, sería el puntero del array
    sw s1, 4(sp)                # guardo s1, sería el largo

    mv s0, a0                   # asigno s0 := a0 := puntero del array
    mv s1, a1                   # asigno s1 := a1 := largo
    li t0, 0                    # t0 := i := 0 lo uso como índice para iterar

bucle:
    bge t0, s1, bucle_end       # si t0 (i) >= s1 (largo) => termina el bucle

    slli t1, t0, 2              # t1 := t0 (i) * 4 porque cada int ocupa 4 bytes, calculo el offset para acceder a arr[i]
    add t2, s0, t1              # t2 := s0 (puntero del array) + t1 (offset) := dirección de memoria de arr[i]
    lw a0, 0(t2)                # a0 := t2, cargo en a0 el valor que está en t2 (o sea, la dirección de memoria de arr[i]) para usar después a0 en es_par
    jal es_par                  # llamo a es_par con a0 := t2, me va a devolver 0 (si no es par) ó 1 (si es par)
    sw a0, 0(t2)                # t2 := a0, porque es_par guarda en a0 el 0 ó 1 según sea par.

    addi t0, t0, 1              # t0 := t0 + 1 := i++, aumento en 1 el i
    j bucle

bucle_end:
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret