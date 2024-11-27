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
    movzx rax, byte [filaOrigen]
    movzx rbx, byte [columnaOrigen]
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8

    lea r8, [tablero + rax]              
    movzx rax, byte [filaDestino]
    movzx rbx, byte [columnaDestino]

    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8
    
    lea r9, [tablero + rax]

    ; Colocar 'O' en la posición de destino
    mov al, byte [caracter]              
    mov byte [r9], al   

    ; Liberar la posición de origen escribiendo '_'
    mov byte [r8], '_'

    ret