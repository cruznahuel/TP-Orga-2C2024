turnoSoldados:
    Strcpy nombreJugador, strSoldado
    Printf2 mensajeTurno, soldados

    mov r12b, 'X'
    mov r13, validarPosicionDestinoSoldado
    mov r14b, 1
    sub rsp, 8
    call realizarTurno
    add rsp, 8

    ret


turnoOficiales:
    Strcpy nombreJugador, strOficial
    Printf2 mensajeTurno, oficiales

    mov r12b, 'O'
    mov r13, validarPosicionDestinoOficial
    mov r14b, 0
    sub rsp, 8
    call realizarTurno
    add rsp, 8

    ret

realizarTurno:
    mov byte[caracter], r12b
    sub rsp, 8
    call pedirPosicionOrigen
    add rsp, 8

    mov qword[direccionFuncion], r13
    sub rsp, 8
    call pedirPosicionDestino
    add rsp, 8

    mov byte[caracter], r12b
    sub rsp, 8
    call realizarMovimiento
    add rsp, 8

    mov byte[turnoJugador], r14b
    sub rsp, 8
    call actualizarEstadoJuego
    add rsp, 8
    ret

actualizarEstadoJuego:


    mov byte[juegoTerminado], 'N'
    ret