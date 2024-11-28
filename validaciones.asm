validarFilCol:
    mov byte[inputValido], 'N'

    cmp byte[inputFila], 0               
    jl filColInvalido
    cmp byte[inputFila], 6
    jg filColInvalido

    cmp byte[inputColumna], 0               
    jl filColInvalido
    cmp byte[inputColumna], 6  
    jg filColInvalido

    xor rax, rax
    xor rbx, rbx
    mov al, byte[inputFila]
    imul rax, 7
    mov bl, byte[inputColumna]                 
    add rax, rbx

    cmp byte[tablero + rax], ' '
    je filColInvalido

    mov byte[inputValido], 'S'      

    filColInvalido:
    ret

validarLugar:
    xor rax, rax
    xor rbx, rbx
    mov al, byte[inputFila]               
    imul rax, 7                
    mov bl, byte[inputColumna]                 
    add rax, rbx                

    mov cl, byte[tablero + rax]

    cmp cl, byte[caracter]               
    jne lugarInvalido           

    mov rax, 0                  
    ret

    lugarInvalido:
    mov rax, 1
    ret

validarPosicionDestinoSoldado:
    mov byte[hayObligacionDeCapturar], 'N'
    
    mov byte[caracter], '_'
    sub rsp, 8
    call validarLugar
    add rsp,8
    cmp rax, 1
    je movimientoInvalidoSoldado

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

    ;Chequeo si el soldado está en las columnas 0 y 6 y quiere ir a una posicion que, en el tablero, es contigua en memoria, lo cual no debe suceder.
    cmp byte[inputColumna], 0
    sete al
    cmp byte[diff], -1
    sete bl
    and al, bl
    cmp al, 1
    je movimientoInvalidoSoldado

    cmp byte[inputColumna], 6
    sete al
    cmp byte[diff], 1
    sete bl
    and al, bl
    cmp al, 1
    je movimientoInvalidoSoldado

    ;Chequeo si el soldado esta en las posiciones en rojo, donde solo se pueden mover horizontalmente.
    ;-Primero las posiciones 28 y 29, que son de la izquierda
    ;verificarConPosicion28y29:
    cmp byte[posicionOrigen], 28
    sete al
    cmp byte[posicionOrigen], 29
    sete bl
    or al, bl
    cmp al, 0
    je verificarConPosicion33y34
    cmp byte[diff], 1
    sete cl
    cmp byte[diff], -1          ;el soldado de la posicion 28 no puede hacer este movimiento, ya que lo filtré anteriormente, pero lo dejo solo para el caso de la posicion 29, para que se pueda mover a la izquierda
    sete dl 
    or cl, dl
    cmp cl, 0
    je movimientoInvalidoSoldado
    jne movimientoValidoSoldado

    ;-Ahora para las posiciones 33 y 34
    verificarConPosicion33y34:
    cmp byte[posicionOrigen], 33
    sete al
    cmp byte[posicionOrigen], 34
    sete bl
    or al, bl
    cmp al, 0
    je verificarParaElRestoDePosicionesSoldado
    cmp byte[diff], 1       ;el soldado de la posicion 34 no puede hacer este movimiento, ya que lo filtré anteriormente, pero lo dejo solo para el caso de la posicion 33, para que se pueda mover a la derecha
    sete cl
    cmp byte[diff], -1          
    sete dl 
    or cl, dl
    cmp cl, 0
    je movimientoInvalidoSoldado
    jne movimientoValidoSoldado

    ;Chequeo si para todo otro soldado su movimiento es solo hacia abajo en linea recta o diagonal
    verificarParaElRestoDePosicionesSoldado:
    cmp byte[diff], 6
    sete al
    cmp byte[diff], 7
    sete bl
    cmp byte[diff], 8
    sete cl
    or al, bl
    or al, cl
    cmp al, 0
    je movimientoInvalidoSoldado

    movimientoValidoSoldado:
    mov rax, 0
    ret

    movimientoInvalidoSoldado:
    mov rax, 1
    ret

validarPosicionDestinoOficial:
    mov byte[caracter], '_'
    sub rsp, 8
    call validarLugar
    add rsp,8
    cmp rax, 1
    je movimientoInvalidoOficial

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

    ;Para los soldados cercanos, verifico que se puedan capturar, y guardo las posiciones destino que debería hacer el oficial para no ser removido
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


    finVerificacionDePosiblesCapturas:
    cmp byte[cantidadPosicionesDestinoParaCapturar], 0
    je noHayObligacionDeCapturar

    ;-----------------------------------------------
    mov byte[hayObligacionDeCapturar], 'S'

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
    jmp movimientoValidoOficial


    verificarSiElMovimientoElegidoEsLejano:
    mov rbx, -1
    iterarDiffPosicionesLejanas:
    inc rbx
    cmp rbx, 8
    je movimientoInvalidoOficial
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
    je movimientoInvalidoOficial
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
    
    jmp movimientoValidoOficial

    ;--------------------------------------------------
    ;A este punto tengo el array de posicionesDestinoParaCapturar en donde posicionDestino debe ser igual a alguno de los elementos, para que el oficial no sea removido
    noHayObligacionDeCapturar:
    mov byte[hayObligacionDeCapturar], 'N'

    mov rbx, 0
    verificarQueElMovimientoSeaCercano:
    cmp rbx, 8
    je movimientoInvalidoOficial
    mov al, byte[diff]
    cmp byte[diffPosCercanas + rbx], al
    je movimientoValidoOficial
    inc rbx
    jmp verificarQueElMovimientoSeaCercano

    movimientoValidoOficial:
    mov rax, 0
    ret

    movimientoInvalidoOficial:
    mov rax, 1

    ret