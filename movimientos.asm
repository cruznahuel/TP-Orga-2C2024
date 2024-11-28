pedirPosicion:
    Gets inputFilCol
    Sscanf4 inputFilCol, formatoInputFilCol, inputFila, inputColumna
    cmp rax, 2
    jne pedirPosicion_FormatoIncorrecto

    sub rsp, 8
    call validarFilCol
    add rsp, 8
    cmp byte[inputValido], 'S'
    je pedirPosicionFin
    
    Puts mensajeFilColFueraTablero
    jmp pedirPosicion

    pedirPosicion_FormatoIncorrecto:
    Puts mensajeFormatoIncorrecto
    jmp pedirPosicion

    pedirPosicionFin:
    ret

pedirPosicionOrigen:
    Puts mensajeIngFilColOrigen
    pedirPosOrigen:
    sub rsp, 8
    call pedirPosicion
    add rsp, 8

    sub rsp, 8
    call validarLugar
    add rsp, 8
    cmp rax, 0
    je finPedirPosicionOrigen

    Printf2 mensajeNoHayJugador, nombreJugador
    jmp pedirPosOrigen

    finPedirPosicionOrigen:
    mov al, byte[inputFila]
    mov byte[filaOrigen], al
    mov al, byte[inputColumna]
    mov byte[columnaOrigen], al

    movzx rax, byte[filaOrigen]
    movzx rbx, byte[columnaOrigen]
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8
    mov byte[posicionOrigen], al

    ret

pedirPosicionDestino:
    Puts mensajeIngFilColDestino
    pedirPosDestino:
    sub rsp, 8
    call pedirPosicion
    add rsp, 8

    sub rsp, 8
    call qword[direccionFuncion]
    add rsp, 8
    cmp rax, 0
    je finPedirPosicionDestino

    Puts mensajeErrorMovimiento
    jmp pedirPosDestino

    finPedirPosicionDestino:
    mov al, byte[inputFila]
    mov byte[filaDestino], al
    mov al, byte[inputColumna]
    mov byte[columnaDestino], al

    ret


calcularDesplazamiento:
    imul rax, 7          ; Multiplicar por nro de filas                
    add rax, rbx         ; Sumar nro de columnas
    ret     


realizarMovimiento:

    cmp byte[turnoJugador], 0
    je moverJugador
    
    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[soldadoCaptura], 'S'
    sete bl
    and al, bl
    cmp al, 1
    je removerSoldadoCapturado

    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[soldadoCaptura], 'N'
    sete bl
    and al, bl
    cmp al, 1
    je removerOficial

    cmp byte[hayObligacionDeCapturar], 'N'
    jmp moverJugador

    removerOficial:
    movzx rax, byte[posicionOrigen]
    mov byte[tablero + rax], '_'
    dec byte[cantidadOficiales]
    jmp finMovimiento

    removerSoldadoCapturado:
    movzx rax, byte[posicionSoldadoCapturado]
    mov byte[tablero + rax], '_'
    dec byte[cantidadSoldados]

    moverJugador:
    movzx rax, byte [filaOrigen]
    movzx rbx, byte [columnaOrigen]
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8
    mov byte[tablero + rax], '_'
                  
    movzx rax, byte [filaDestino]
    movzx rbx, byte [columnaDestino]
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8
    mov bl, byte[caracter]
    mov byte[tablero + rax], bl    

    finMovimiento:
    ret