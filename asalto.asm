global main
%include "imports.asm"
%include "movimientos.asm"
%include "validaciones.asm"
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
                   
    mov rdx, filaOrigen           
    mov rcx, columnaOrigen 
    
    callAndAdjustStack validarFilCol
    
    cmp byte [inputValido], 'S'
    je validarTurno

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

    mov rdx, filaDestino           
    mov rcx, columnaDestino

    callAndAdjustStack validarFilCol

    cmp byte [inputValido], 'S'
    jne inputDestinoSoldadoInvalido
    
    mov rdi, '_'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je lugarLibreValidoSoldado  

    Puts mensajeErrorLugarLibre
    jmp soldadoValido

    inputDestinoSoldadoInvalido:
    Puts mensajeErrorInput
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

    mov byte [caracter], 'X'
    callAndAdjustStack realizarMovimiento

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

    mov rdx, filaDestino           
    mov rcx, columnaDestino

    callAndAdjustStack validarFilCol

    cmp byte [inputValido], 'S'
    jne inputDestinoOficialInvalido

    mov rdi, '_'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je lugarLibreValidoOficial       

    Puts mensajeErrorLugarLibre
    jmp oficialValido  

    inputDestinoOficialInvalido:
    Puts mensajeErrorInput
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

    mov byte [caracter], 'O'
    callAndAdjustStack realizarMovimiento

    callAndAdjustStack imprimirTablero

    callAndAdjustStack siguienteTurno

    ret

finPrograma:
    ret















