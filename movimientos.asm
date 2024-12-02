pedirPosicion:
    Gets inputFilCol
    Sscanf4 inputFilCol, formatoInputFilCol, inputFila, inputColumna
    cmp rax, 2
    jne pedirPosicion_FormatoIncorrecto

    cmp byte[inputFila], 0
    sete al
    cmp byte[inputColumna], 0
    sete bl
    and al, bl
    cmp al, 1
    je menuSalida

    cmp byte[inputFila], 1
    sete al
    cmp byte[inputColumna], 1
    sete bl
    and al, bl
    cmp al, 1
    je pedirOrigenDeNuevo
    
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

    pedirOrigenDeNuevo:
    mov byte[pedirInputOrigenDeNuevo], 'S'

    pedirPosicionFin:
    ret

pedirPosicionOrigen:
    mov byte[pedirInputOrigenDeNuevo], 'N'
    Puts mensajeIngFilColOrigen
    pedirPosOrigen:
    sub rsp, 8
    call pedirPosicion
    add rsp, 8

    cmp byte[pedirInputOrigenDeNuevo], 'S'
    je pedirPosicionOrigen

    sub rsp, 8
    call validarLugar
    add rsp, 8
    cmp rax, 0
    je verificarBloqueoEtiqueta

    Printf2 mensajeNoHayJugador, nombreJugador
    jmp pedirPosOrigen

    verificarBloqueoEtiqueta:
    sub rsp, 8
    call verificarBloqueo
    add rsp, 8
    cmp rax, 1
    je pedirPosOrigen

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
    mov byte[pedirInputOrigenDeNuevo], 'N'
    Puts mensajeIngFilColDestino
    pedirPosDestino:
    sub rsp, 8
    call pedirPosicion
    add rsp, 8

    cmp byte[inputFila], 1
    sete al
    cmp byte[inputColumna], 1
    sete bl
    and al, bl
    cmp al, 1
    je pedirPosOrigenDeNuevo

    sub rsp, 8
    call qword[direccionFuncion]
    add rsp, 8
    cmp rax, 0
    je finPedirPosicionDestino

    Puts mensajeErrorMovimiento
    jmp pedirPosDestino

    pedirPosOrigenDeNuevo:
    mov byte[pedirInputOrigenDeNuevo], 'S'
    jmp f

    finPedirPosicionDestino:
    mov al, byte[inputFila]
    mov byte[filaDestino], al
    mov al, byte[inputColumna]
    mov byte[columnaDestino], al

    f:
    ret


calcularDesplazamiento:
    imul rax, 7          ; Multiplicar por nro de filas                
    add rax, rbx         ; Sumar nro de columnas
    ret     


realizarMovimiento:

    cmp byte[turnoJugador], 1
    je moverJugador
    
    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[oficialCaptura], 'S'
    sete bl
    and al, bl
    cmp al, 1
    je removerSoldadoCapturado

    cmp byte[hayObligacionDeCapturar], 'S'
    sete al
    cmp byte[oficialCaptura], 'N'
    sete bl
    and al, bl
    cmp al, 1
    je removerOficial

    jmp actualizarPosicionOficial

    removerOficial:
    movzx rax, byte[posicionOrigen]
    mov byte[tablero + rax], '_'
    dec byte[cantidadOficiales]
    
    ;Guardo qué numero de oficial se removió
    mov al, byte[posicionOficial1]
    cmp byte[posicionOrigen], al
    je guardarNumeroOficial1Removido

    mov byte[numeroOficialRemovido], 2
    jmp finMovimiento

    guardarNumeroOficial1Removido:
    mov byte[numeroOficialRemovido], 1    
    jmp finMovimiento

    removerSoldadoCapturado:
    movzx rax, byte[posicionSoldadoCapturado]
    mov byte[tablero + rax], '_'
    dec byte[cantidadSoldados]

    actualizarPosicionOficial:
    mov al, byte[posicionDestino]
    
    mov bl, byte[posicionOficial1]
    cmp byte[posicionOrigen], bl
    je actualizarPosicionOficial1

    mov byte[posicionOficial2],al
    jmp moverJugador

    actualizarPosicionOficial1:
    mov byte[posicionOficial1], al

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