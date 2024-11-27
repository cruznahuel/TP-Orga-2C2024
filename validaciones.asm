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
    movzx rax, byte[inputFila]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoOficial

    movzx rax, byte[inputColumna]
    movzx rbx, byte[columnaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoOficial

    movimientoValidoOficial:
    mov rax, 0
    ret

    movimientoInvalidoOficial:
    mov rax, 1

    ret