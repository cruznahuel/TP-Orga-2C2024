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
    ;Chequeo si se removieron todos los oficiales
    cmp byte[cantidadOficiales], 0
    je ganadoresSoldados

    ;Chequeo si la cantidad de soldados es menor a la cantidad necesaria para ocupar la fortaleza
    mov al, 9
    sub al, byte[cantidadOficiales]
    cmp byte[cantidadSoldados], al
    jl ganadoresOficiales

    ;Chequeo si la fortaleza esta completamente ocupada
    mov rbx, -1
    iterarPosicionesFortaleza:
    inc rbx
    cmp rbx, 9
    je ganadoresSoldados
    movzx rax, byte[posicionesFortaleza + rbx]
    cmp byte[tablero + rax], '_'
    jne iterarPosicionesFortaleza

    ;-----------
    ;Chequear si los oficiales no se pueden mover, ya que en ese caso los soldados ganan. Si se pueden mover, todavía no hay ningun ganador
    ;-----------
    
    ningunGanador:
    mov byte[juegoTerminado], 'N'
    jmp finActualizarEstadoJuego

    ganadoresOficiales:
    Strcpy ganador, oficiales
    Strcpy motivoGanador, mensajeSoldadosInsuficientes
    mov byte[juegoTerminado], 'S'
    jmp finActualizarEstadoJuego

    ganadoresSoldados:
    Strcpy ganador, soldados
    cmp byte[cantidadOficiales], 0
    je motivoOficialesRetirados
    Strcpy motivoGanador, mensajeFortalezaOcupada
    n:
    mov byte[juegoTerminado], 'S'
    jmp finActualizarEstadoJuego

    motivoOficialesRetirados:
    Strcpy motivoGanador, mensajeOficialesRetirados
    jmp n

    finActualizarEstadoJuego:
    ret

comentarioJugada:
    cmp byte[hayObligacionDeCapturar], 'N'
    je comentarioVacio

    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[oficialCaptura], 'S'
    sete bl
    and al, bl
    cmp al, 1
    je comentarioSoldadoCapturado

    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[oficialCaptura], 'N'
    sete bl
    and al, bl
    cmp al, 1
    je comentarioOficialRetirado

    comentarioVacio:
    Strcpy comentarioJugadaStr, mensajeVacio
    jmp finComentarioJugada

    comentarioOficialRetirado:
    Strcpy comentarioJugadaStr, mensajeOficialRetirado
    jmp finComentarioJugada

    comentarioSoldadoCapturado:
    Strcpy comentarioJugadaStr, mensajeSoldadoCapturado

    finComentarioJugada:
    Printf2 comentario, comentarioJugadaStr
    ret