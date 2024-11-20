validarTurno:
    mov al, [turnoSoldado]  ; Cargamos el valor de turnoSoldado (1 para soldados, 0 para oficiales)
    
    cmp al, 1
    je turnoSoldadoValidar   
    cmp al, 0
    je turnoOficialValidar   

    jmp finPrograma


validarFilCol:
    mov byte[inputValido], 'N'      ; Inicializar inputValido como 'N' (no válido)
    
    mov rsi, formatoInputFilCol    

    push rdx
    push rcx

    callAndAdjustStack sscanf

    cmp rax, 2                     
    jl OrigenInvalido
    
    pop rdx
    pop rcx
    
    cmp word[rdx], 0         
    jl OrigenInvalido
    cmp word[rdx], 6
    jg OrigenInvalido

    cmp word[rcx], 0      
    jl OrigenInvalido
    cmp word[rcx], 6
    jg OrigenInvalido

    mov byte[inputValido], 'S'      

    OrigenInvalido:
    ret


validarLugar:
    movzx rax, byte[rsi]               
    imul rax, 7                
    movzx rbx, byte[rdx]                 
    add rax, rbx                

    mov cl, byte[tablero + rax] 

    cmp cl, dil                 
    jne lugarInvalido           

    mov rax, 1                  
    ret

    lugarInvalido:
    xor rax, rax                
    ret


validarMovimientoSoldado:
    movzx rax, byte[filaDestino]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jne movimientoInvalidoSoldado

    movzx rax, byte[columnaDestino]
    movzx rbx, byte[columnaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoSoldado

    ; Validar que filaDestino > filaOrigen
    movzx rax, byte[filaDestino]
    movzx rbx, byte[filaOrigen]
    cmp rax, rbx
    jg movimientoValidoSoldado

    movimientoInvalidoSoldado:
    xor rax, rax
    ret

    movimientoValidoSoldado:
    mov rax, 1
    ret


validarMovimientoOficial:
    movzx rax, byte[filaDestino]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoOficial

    movzx rax, byte[columnaDestino]
    movzx rbx, byte[columnaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalidoOficial

    movimientoValidoOficial:
    mov rax, 1
    ret

    movimientoInvalidoOficial:
    xor rax, rax
    ret