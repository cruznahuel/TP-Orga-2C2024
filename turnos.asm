turnoSoldados:
    Strcpy nombreJugador, strSoldado
    Printf2 mensajeTurno, soldados

    mov r12b, 'X'
    mov r13, validarPosicionDestinoSoldado
    mov r14b, 2
    sub rsp, 8
    call realizarTurno
    add rsp, 8

    ret


turnoOficiales:
    Strcpy nombreJugador, strOficial
    Printf2 mensajeTurno, oficiales

    mov r12b, 'O'
    mov r13, validarPosicionDestinoOficial
    mov r14b, 1
    sub rsp, 8
    call realizarTurno
    add rsp, 8
    callAndAdjustStack determinarOficial
    callAndAdjustStack registrarDesplazamiento
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

    cmp byte[pedirInputOrigenDeNuevo], 'S'
    je realizarTurno

    mov byte[caracter], r12b
    sub rsp, 8
    call realizarMovimiento
    add rsp, 8

    sub rsp, 8
    call actualizarEstadoJuego
    add rsp, 8

    mov byte[turnoJugador], r14b
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

    ;Chequear si los oficiales no se pueden mover, ya que en ese caso los soldados ganan. Si se pueden mover, todavía no hay ningun ganador
    sub rsp, 8
    call chequearBloqueoOficiales
    add rsp, 8

    cmp byte[oficialesBloqueados], 'S'
    je ganadoresSoldados
    
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
    cmp byte[oficialesBloqueados], 'S'
    je motivoOficialesBloqueados
    Strcpy motivoGanador, mensajeFortalezaOcupada
    n:
    mov byte[juegoTerminado], 'S'
    jmp finActualizarEstadoJuego

    motivoOficialesBloqueados:
    Strcpy motivoGanador, mensajeOficialesBloqueados
    jmp n 

    motivoOficialesRetirados:
    Strcpy motivoGanador, mensajeOficialesRetirados
    jmp n

    finActualizarEstadoJuego:
    ret


chequearBloqueoOficiales:

    cmp byte[numeroOficialRemovido], 0
    je chequearBloqueoAmbosSoldados
    
    cmp byte[numeroOficialRemovido], 1
    je chequearBloqueoOficial2
    cmp byte[numeroOficialRemovido], 2
    je chequearBloqueoOficial1

    chequearBloqueoOficial2:
    mov dil, byte[posicionOficial2]
    sub rsp, 8
    call chequearBloqueo
    add rsp, 8
    jmp finChequeoBloqueo

    chequearBloqueoOficial1:
    mov dil, byte[posicionOficial1]
    sub rsp, 8
    call chequearBloqueo
    add rsp, 8
    jmp finChequeoBloqueo

    chequearBloqueoAmbosSoldados:
    mov dil, byte[posicionOficial1]
    sub rsp, 8
    call chequearBloqueo
    add rsp, 8
    cmp byte[oficialesBloqueados], 'N'
    je finChequeoBloqueo

    mov dil, byte[posicionOficial2]
    sub rsp, 8
    call chequearBloqueo
    add rsp, 8
    
    finChequeoBloqueo:
    ret

chequearBloqueo:
    mov rbx, -1
    i:
    inc rbx
    cmp rbx, 8
    je chequearVacioEnPosicionesLejanasSoldado
    movzx r10, dil
    mov al, byte[diffPosCercanas + rbx]
    cbw
    cwde
    cdqe
    cmp byte[tablero + r10 + rax], '_'
    je noHayBloqueo
    jmp i

    chequearVacioEnPosicionesLejanasSoldado:
    mov rbx, -1
    j:
    inc rbx
    cmp rbx, 8
    je hayBloqueo  
    movzx r10, dil
    mov al, byte[diffPosLejanas + rbx]
    cbw
    cwde
    cdqe
    cmp byte[tablero + r10 + rax], '_'
    je noHayBloqueo
    jmp j

    hayBloqueo:
    mov byte[oficialesBloqueados], 'S'
    jmp finChequeo

    noHayBloqueo:
    mov byte[oficialesBloqueados], 'N'

    finChequeo:
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