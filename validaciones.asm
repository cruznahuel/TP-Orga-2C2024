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
    mov bl, byte[inputColumna]
    
    sub rsp, 8
    call calcularDesplazamiento
    add rsp, 8

    mov cl, byte[tablero + rax]
    cmp cl, byte[caracter]
    jne lugarInvalido
    
    cmp cl, 'X'
    jne lugarValido

    verificarEncierroCostados: 
        cmp rax, 28
        je verificarLugarLibreDerecha

        cmp rax, 29
        je verificarLugarLibreCostados

        cmp rax, 33 
        je verificarLugarLibreCostados

        cmp rax, 34
        je verificarLugarLibreIzquierda


        verificarLugarLibreDerecha:
            add rax, 1
            mov cl, byte[tablero + rax]     
            cmp cl, '_'
            je lugarValido
            
            jmp soldadoEncerrado

        verificarLugarLibreIzquierda:
            sub rax, 1
            mov cl, byte[tablero + rax]     
            cmp cl, '_'
            je lugarValido

            jmp soldadoEncerrado

        verificarLugarLibreCostados:
            sub rax, 1
            mov cl, byte[tablero + rax]     
            cmp cl, '_'
            je lugarValido

            add rax, 2
            mov cl, byte[tablero + rax]     
            cmp cl, '_'
            je lugarValido
            jmp soldadoEncerrado

    movzx rbx, byte[inputFila]
    inc rbx
    cmp rbx, 6
    jg soldadoEncerrado

    imul rbx, 7
    add bl, byte[inputColumna - 1]
    mov cx, 2

    verificarEncierro:
    mov cl, byte[tablero + rbx]     
    cmp cl, '_'                      
    je lugarValido                   

    add bl, 1                        
    loop verificarEncierro         

    jmp soldadoEncerrado

    lugarValido:
    mov rax, 0
    ret

    soldadoEncerrado:
    Puts mensajeSoldadoEncerrado
    mov rax, 2
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

    sub rsp, 8
    call calcularDistanciaOrigenDestino
    add rsp,8

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

    sub rsp, 8
    call calcularDistanciaOrigenDestino
    add rsp,8

    sub rsp, 8
    call hallarSoldadosCercanos
    add rsp,8

    sub rsp, 8
    call guardarPosiblesPosicionesParaCapturar
    add rsp,8

    cmp byte[hayObligacionDeCapturar], 'N'
    je noHayObligacionDeCapturar

    sub rsp, 8
    call verificarDesentendimientoOficial
    add rsp,8

    movimientoValidoOficial:
    mov rax, 0
    ret

    movimientoInvalidoOficial:
    mov rax, 1

    ret