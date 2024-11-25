validarFilCol:
    mov byte[inputValido], 'N'

    cmp byte[fila], 0               
    jl filColInvalido
    cmp byte[fila], 6
    jg filColInvalido

    cmp byte[columna], 0               
    jl filColInvalido
    cmp byte[columna], 6  
    jg filColInvalido

    xor rax, rax
    xor rbx, rbx
    mov al, byte[fila]
    imul rax, 7
    mov bl, byte[columna]                 
    add rax, rbx

    cmp byte[tablero + rax], ' '
    je filColInvalido

    mov byte[inputValido], 'S'      

    filColInvalido:
    ret

validarLugar:
    xor rax, rax
    xor rbx, rbx
    mov al, byte[fila]               
    imul rax, 7                
    mov bl, byte[columna]                 
    add rax, rbx                

    mov cl, byte[tablero + rax]

    cmp cl, r15b               
    jne lugarInvalido           

    mov rax, 0                  
    ret

    lugarInvalido:
    mov rax, 1
    ret


validarPosicionDestinoSoldado:
    movzx rax, byte[fila]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jne movimientoInvalidoSoldado

    movzx rax, byte[columna]
    movzx rbx, byte[columnaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoSoldado

    ; Validar que filaDestino > filaOrigen
    movzx rax, byte[fila]
    movzx rbx, byte[filaOrigen]
    cmp rax, rbx
    jg movimientoValidoSoldado

    movimientoValidoSoldado:
    mov rax, 0
    ret

    movimientoInvalidoSoldado:
    mov rax, 1
    ret


validarPosicionDestinoOficial:
    movzx rax, byte[fila]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoOficial

    movzx rax, byte[columna]
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