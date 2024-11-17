global main
%include "imports.asm"
%include "movimientos.asm"
%include "tablero.asm"
%include "data.asm"

section .text
main:
    mov byte [turnoSoldado], 1

    Puts mensajeInicial
    
    sub rsp, 8
    call verificarTableroGuardado
    add rsp, 8

    sub rsp, 8
    call leerTablero        ; devuelve 0 si se pudo leer el archivo
    add rsp, 8
    cmp rax, 0
    jne finPrograma

    sub rsp, 8
    call imprimirTablero
    add rsp, 8

ingresarDatos:
    Puts mensajeIngFilColOrigen
    Gets inputFilColOrigen

    lea rdi, [inputFilColOrigen]
    sub rsp, 8
    call validarFilColOrigen
    add rsp, 8

    cmp byte [inputValido], 'S'
    je chequearTurno

    Puts mensajeErrorInput
    jmp main

turnoSoldadoValidar:
    xor rax, rax  
    sub rsp, 8
    mov rsi, filaOrigen
    mov rdx, columnaOrigen
    
    call validarLugarSoldado
    add rsp, 8

    cmp rax, 1
    je soldadoValido       

    Puts mensajeErrorSoldado
    jmp main               

soldadoValido:
    Puts mensajeSoldadoValido

    Puts mensajeIngFilColDestino
    Gets inputFilColDestino

    lea rdi, [inputFilColDestino]
    sub rsp, 8
    call validarFilColDestino
    add rsp, 8

    sub rsp, 8
    mov rsi, filaDestino
    mov rdx, columnaDestino
    
    call validarLugarLibre
    add rsp, 8

    cmp rax, 1
    je lugarLibreValido       

    Puts mensajeErrorLugarLibre
    jmp soldadoValido               

lugarLibreValido:
    Puts mensajeLugarLibreValido
    sub rsp, 8
    call validarMovimientoSoldado
    add rsp, 8

    cmp rax, 1
    je movimientoSoldadoValido

    Puts mensajeErrorMovimiento
    jmp soldadoValido

movimientoSoldadoValido:
    Puts mensajeMovimientoValido

    sub rsp, 8
    call realizarMovimientoSoldado
    add rsp, 8

    sub rsp, 8
    call imprimirTablero
    add rsp, 8

    sub rsp, 8
    call siguienteTurno
    add rsp, 8

    ret

turnoOficialValidar:
    Puts mensajeMovimientoValido

                
finPrograma:
    ret















