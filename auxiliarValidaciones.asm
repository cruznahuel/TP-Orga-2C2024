calcularDistanciaOrigenDestino: 
    movzx rax, byte[inputFila]
    movzx rbx, byte[inputColumna]
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8
    mov byte[posicionDestino], al

    mov al, byte[posicionDestino]
    mov bl, byte[posicionOrigen]
    sub al, bl
    mov byte[diff], al


hallarSoldadosCercanos:
    ;Recorro las posiciones cercanas al oficial y guardo las posiciones donde haya soldados
    mov rbx, 0
    mov byte[cantidadDeSoldadosCerca], 0
    recorrerDiffPosCercanas:
    cmp rbx, 8
    je verificarCapturaSoldadosCercanos
    mov al, byte[diffPosCercanas + rbx]
    cbw
    cwde
    cdqe
    movzx r10, byte[posicionOrigen]
    cmp byte[tablero + r10 + rax], 'X'
    je agregarDiffPosicionSoldadoCercana
    inc rbx
    jmp recorrerDiffPosCercanas

    agregarDiffPosicionSoldadoCercana:
    movzx r10, byte[cantidadDeSoldadosCerca]
    mov byte[diffPosicionesSoldadosCerca + r10], al
    inc rbx
    inc byte[cantidadDeSoldadosCerca]
    jmp recorrerDiffPosCercanas

    ret


guardarPosiblesPosicionesParaCapturar:
    verificarCapturaSoldadosCercanos:
    mov rbx, 0
    mov byte[cantidadPosicionesDestinoParaCapturar], 0
    recorrerDiffPosicionesSoldadosCercanos:
    movzx r10, byte[cantidadDeSoldadosCerca]
    cmp rbx, r10
    je finVerificacionDePosiblesCapturas
    mov al, byte[diffPosicionesSoldadosCerca + rbx]
    cbw
    cwde
    cdqe
    imul rax, 2
    movzx r10, byte[posicionOrigen]
    cmp byte[tablero + r10 + rax], '_'
    je agregarPosicionesDestinoParaCapturar
    inc rbx
    jmp recorrerDiffPosicionesSoldadosCercanos
    

    agregarPosicionesDestinoParaCapturar:
    add r10, rax
    movzx r11, byte[cantidadPosicionesDestinoParaCapturar]
    mov byte[posicionesDestinoParaCapturar + r11], r10b
    inc rbx
    inc byte[cantidadPosicionesDestinoParaCapturar]
    jmp recorrerDiffPosicionesSoldadosCercanos

    ret

verificarDesentendimientoOficial: 
    mov rbx, 0
    verificarSiElMovimientoElegidoEsCercano:
    cmp rbx, 8
    je verificarSiElMovimientoElegidoEsLejano
    mov al, byte[diff]
    cmp byte[diffPosCercanas + rbx], al
    je soldadoEligeNoCapturar
    inc rbx
    jmp verificarSiElMovimientoElegidoEsCercano

    soldadoEligeNoCapturar:
    mov byte[oficialCaptura], 'N'
    jmp movimientoValidoOficialAuxiliar


    verificarSiElMovimientoElegidoEsLejano:
    mov rbx, -1
    iterarDiffPosicionesLejanas:
    inc rbx
    cmp rbx, 8
    je movimientoInvalidoOficialAuxiliar
    mov al, byte[diff]
    cmp byte[diffPosLejanas + rbx], al
    jne iterarDiffPosicionesLejanas

    ;Si llego acá, es porque hay obligacion de capturar y posicionDestino debe coincidir con uno del array de las posiciones posibles para capturar
    mov al, byte[posicionDestino]
    mov rbx, -1
    iterarDiffPosicionesLejanasParaVerificarCaptura:
    inc rbx
    movzx r10, byte[cantidadPosicionesDestinoParaCapturar]
    cmp rbx, r10 
    je movimientoInvalidoOficialAuxiliar
    cmp byte[posicionesDestinoParaCapturar + rbx], al
    jne iterarDiffPosicionesLejanasParaVerificarCaptura

    mov byte[oficialCaptura], 'S'
    ;Necesito guardar la posicion del soldado capturado
    mov al, byte[diff]
    cbw
    mov bl, 2
    idiv bl     ;-> cociente en al
    mov cl, byte[posicionOrigen]
    add cl, al
    mov byte[posicionSoldadoCapturado], cl
    
    jmp movimientoValidoOficialAuxiliar
    
    ;--------------------------------------------------
    ;A este punto tengo el array de posicionesDestinoParaCapturar en donde posicionDestino debe ser igual a alguno de los elementos, para que el oficial no sea removido
    noHayObligacionDeCapturar:
    mov byte[hayObligacionDeCapturar], 'N'

    mov rbx, 0
    verificarQueElMovimientoSeaCercano:
    cmp rbx, 8
    je movimientoInvalidoOficialAuxiliar
    mov al, byte[diff]
    cmp byte[diffPosCercanas + rbx], al
    je movimientoValidoOficial
    inc rbx
    jmp verificarQueElMovimientoSeaCercano
    ret

    movimientoValidoOficialAuxiliar:
    mov rax, 0
    ret

    movimientoInvalidoOficialAuxiliar:
    mov rax, 1