global main
%include "imports.asm"
%include "movimientos.asm"
%include "tablero.asm"
%include "data.asm"


section .text
main:
    mov byte [turnoSoldado], 1

    Puts mensajeInicial
    
    callAndAdjustStack verificarTableroGuardado
    
    callAndAdjustStack leerTablero        ; devuelve 0 si se pudo leer el archivo
 
    cmp rax, 0
    jne finPrograma

    callAndAdjustStack imprimirTablero

ingresarDatos:
    Puts mensajeIngFilColOrigen
    Gets inputFilColOrigen

    lea rdi, [inputFilColOrigen]

    callAndAdjustStack validarFilColOrigen

    cmp byte [inputValido], 'S'
    je chequearTurno

    Puts mensajeErrorInput
    jmp main

turnoSoldadoValidar:
    Puts mensajeTurnoSoldado
    
    xor rax, rax  
   
    mov rsi, filaOrigen
    mov rdx, columnaOrigen
    
    mov rdi, 'X'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je soldadoValido       

    Puts mensajeErrorSoldado
    jmp main               

soldadoValido:
    Puts mensajeSoldadoValido

    Puts mensajeIngFilColDestino
    Gets inputFilColDestino

    lea rdi, [inputFilColDestino]

    callAndAdjustStack validarFilColDestino

    mov rsi, filaDestino
    mov rdx, columnaDestino
    
    mov rdi, '_'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je lugarLibreValidoSoldado  

    Puts mensajeErrorLugarLibre
    jmp soldadoValido               

lugarLibreValidoSoldado:
    Puts mensajeLugarLibreValido
    callAndAdjustStack validarMovimientoSoldado

    cmp rax, 1
    je movimientoSoldadoValido

    Puts mensajeErrorMovimiento
    jmp soldadoValido

movimientoSoldadoValido:
    Puts mensajeMovimientoValido

    callAndAdjustStack realizarMovimientoSoldado

    callAndAdjustStack imprimirTablero

    callAndAdjustStack siguienteTurno

    ret

turnoOficialValidar:
    Puts mensajeTurnoOficial

    xor rax, rax  
    mov rsi, filaOrigen
    mov rdx, columnaOrigen

    mov rdi, 'O'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je oficialValido       

    Puts mensajeErrorOficial
    jmp ingresarDatos  

oficialValido:
    Puts mensajeOficialValido

    Puts mensajeIngFilColDestino
    Gets inputFilColDestino

    lea rdi, [inputFilColDestino]
    callAndAdjustStack validarFilColDestino
    mov rsi, filaDestino
    mov rdx, columnaDestino

    mov rdi, '_'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je lugarLibreValidoOficial       

    Puts mensajeErrorLugarLibre
    jmp oficialValido  

lugarLibreValidoOficial:
    Puts mensajeLugarLibreValido
    callAndAdjustStack validarMovimientoOficial

    cmp rax, 1
    je movimientoOficialValido

    Puts mensajeErrorMovimiento
    jmp oficialValido

movimientoOficialValido:
    Puts mensajeMovimientoValido

    callAndAdjustStack realizarMovimientoOficial

    callAndAdjustStack imprimirTablero

    callAndAdjustStack siguienteTurno

    ret

finPrograma:
    ret















