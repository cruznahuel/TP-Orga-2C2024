global main

%include "imports.asm"
%include "movimientos.asm"
%include "validaciones.asm"
%include "oficiales.asm"
%include "tablero.asm"
%include "data.asm"


section .text
main:
    Puts mensajeInicial
    
    callAndAdjustStack verificarTableroGuardado
    
    callAndAdjustStack leerTablero        ; devuelve 0 si se pudo leer el archivo
 
    cmp rax, 0
    jne finPrograma

    callAndAdjustStack leerArchivoOficiales ; devuelve 0 si se pudo leer el archivo
    cmp rax, 0
    jne finPrograma

iniciarTurno:

    callAndAdjustStack imprimirTablero

    mov r12, filaOrigen      
    mov r13, columnaOrigen   
    callAndAdjustStack ingresarDatos

    cmp byte [inputValido], 'S'
    je validarTurno

    Puts mensajeErrorInput
    jmp iniciarTurno


turnoSoldadoValidar:
    Puts mensajeTurnoSoldado
       
    mov rdi, 'X'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je soldadoValido       

    Puts mensajeErrorSoldado
    jmp iniciarTurno               

soldadoValido:
    
    mov r12, filaDestino      
    mov r13, columnaDestino   
    callAndAdjustStack ingresarDatos
    
    cmp byte [inputValido], 'S'
    je inputSoldadoValido

    inputSoldadoValido:
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

    mov byte [caracter], 'X'
    callAndAdjustStack realizarMovimiento

    callAndAdjustStack imprimirTablero

    callAndAdjustStack siguienteTurno

    ret

turnoOficialValidar:

    Puts mensajeTurnoOficial

    mov rdi, 'O'
    callAndAdjustStack validarLugar

    cmp rax, 1
    je oficialValido       

    Puts mensajeErrorOficial
    jmp ingresarDatos  

oficialValido:
    Puts mensajeOficialValido

    callAndAdjustStack determinarOficial

    mov r12, filaDestino      ; Se debería poder remover, ya definido en soldado
    mov r13, columnaDestino   ; Se debería poder remover, ya definido en soldado
    callAndAdjustStack ingresarDatos
    
    cmp byte [inputValido], 'S'
    je inputOficialValido

    inputOficialValido:
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

    callAndAdjustStack registrarDesplazamiento
    
    mov byte [caracter], 'O'

    callAndAdjustStack realizarMovimiento

    callAndAdjustStack imprimirTablero

    jmp finPrograma
    callAndAdjustStack siguienteTurno

    ret

finPrograma:
    ;asi se deberia llamar para mostrar la informacion de los oficiales
    Puts mensajeOficial1
    Strcpy datosOficialActual,datosOficial1
    callAndAdjustStack imprimirDatosOficiales

    Puts mensajeOficial2
    Strcpy datosOficialActual, datosOficial2
    callAndAdjustStack imprimirDatosOficiales

    ret















