global main
%include "imports.asm"
%include "movimientos.asm"
%include "validaciones.asm"
%include "oficiales.asm"
%include "tablero.asm"
%include "turnos.asm"
%include "salida.asm"
%include "data.asm"


section .text
main:
    limpiarTerminal

    Puts mensajeInicial
    Puts reglasSoldados
    Puts reglasOficiales

    callAndAdjustStack verificarTableroGuardado

    callAndAdjustStack leerTablero        ; devuelve 0 si se pudo leer el archivo
    cmp rax, 0
    jne finPrograma

    callAndAdjustStack leerArchivoOficiales ; devuelve 0 si se pudo leer el archivo
    cmp rax, 0
    jne finPrograma

    Puts informacion

    sub rsp, 8
    call imprimirTablero
    add rsp, 8
    
    cmp byte[turnoJugador], 2
    je primerTurnoOficial

    sub rsp, 8
    call turnoSoldados     
    add rsp, 8
    jmp loopJuego

    primerTurnoOficial:
    sub rsp, 8
    call turnoOficiales     
    add rsp, 8

    
    loopJuego:
    limpiarTerminal

    sub rsp, 8
    call comentarioJugada
    add rsp, 8

    Puts informacion

    sub rsp, 8
    call imprimirTablero
    add rsp, 8

    cmp byte[juegoTerminado], 'S'
    je mensajeGanador

    cmp byte[turnoJugador], 2
    je turnoOficialEtiqueta

    sub rsp, 8
    call turnoSoldados    
    add rsp, 8
    jmp loopJuego

    turnoOficialEtiqueta:
    sub rsp, 8
    call turnoOficiales
    add rsp, 8
    jmp loopJuego


    mensajeGanador:
        mov rdi, mensajeDelGanador
        mov rsi, ganador
        sub rsp, 8
        call printf
        add rsp, 8
        Puts motivoGanador

    mensajeDatosOficiales:
        Puts mensajeOficial1
        Strcpy datosOficialActual,datosOficial1
        callAndAdjustStack imprimirDatosOficiales

        Puts mensajeOficial2
        Strcpy datosOficialActual, datosOficial2
        callAndAdjustStack imprimirDatosOficiales
    
    finPrograma:
    ret
