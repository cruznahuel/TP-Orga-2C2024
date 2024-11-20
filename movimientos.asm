chequearTurno:
    mov al, [turnoSoldado]  ; Cargamos el valor de turnoSoldado (1 para soldados, 0 para oficiales)
    
    cmp al, 1
    je turnoSoldadoValidar   ; Si es el turno de los soldados, llamar a la rutina de validación de soldados

    cmp al, 0
    je turnoOficialValidar   ; Si es el turno de los oficiales, llamar a la rutina de validación de oficiales

    jmp finPrograma


siguienteTurno:    
    mov al, [turnoSoldado]  
    xor al, 1               
    mov [turnoSoldado], al  
            
    sub rsp, 8
    call ingresarDatos
    add rsp, 8

    ret     


validarFilColOrigen:
    mov byte[inputValido], 'N'      ; Inicializar inputValido como 'N' (no válido)

    mov rdi, rdi                  ; rdi contendrá la dirección de inputFilCol
    mov rsi, formatoInputFilCol    
    mov rdx, filaOrigen            
    mov rcx, columnaOrigen         
    sub rsp, 8
    call sscanf                    
    add rsp, 8

    cmp rax, 2                     
    jl OrigenInvalido

    cmp word[filaOrigen], 0         
    jl OrigenInvalido
    cmp word[filaOrigen], 6
    jg OrigenInvalido

    cmp word[columnaOrigen], 0      
    jl OrigenInvalido
    cmp word[columnaOrigen], 6
    jg OrigenInvalido

    mov byte[inputValido], 'S'      

    OrigenInvalido:
    ret

validarFilColDestino:
    mov byte[inputValido], 'N'      ; Inicializar inputValido como 'N' (no válido)

    mov rdi, rdi                  ; rdi contendrá la dirección de inputFilCol
    mov rsi, formatoInputFilCol    
    mov rdx, filaDestino            
    mov rcx, columnaDestino        
    sub rsp, 8
    call sscanf                    
    add rsp, 8

    cmp rax, 2                     
    jl DestinoInvalido

    cmp word[filaDestino], 0         
    jl DestinoInvalido
    cmp word[filaDestino], 6
    jg DestinoInvalido

    cmp word[columnaDestino], 0      
    jl DestinoInvalido
    cmp word[columnaDestino], 6
    jg DestinoInvalido

    mov byte[inputValido], 'S'      

    DestinoInvalido:
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


realizarMovimientoSoldado:
    ; Calcular la posición de origen en el tablero
    movzx rax, byte [filaOrigen]         ; Cargar fila de origen como 8 bits y extender a 64 bits
    imul rax, 7                          ; Multiplicar por el número de columnas (7)
    movzx rbx, byte [columnaOrigen]      ; Cargar columna de origen como 8 bits y extender a 64 bits
    add rax, rbx                         ; Sumar la columna de origen al índice
    lea r8, [tablero + rax]              ; Dirección de la posición de origen en r8

    ; Calcular la posición de destino en el tablero
    movzx rax, byte [filaDestino]        ; Cargar fila de destino como 8 bits y extender a 64 bits
    imul rax, 7                          ; Multiplicar por el número de columnas (7)
    movzx rbx, byte [columnaDestino]     ; Cargar columna de destino como 8 bits y extender a 64 bits
    add rax, rbx                         ; Sumar la columna de destino al índice
    lea r9, [tablero + rax]              ; Dirección de la posición de destino en r9

    ; Colocar 'X' en la posición de destino
    mov byte [r9], 'X'

    ; Liberar la posición de origen escribiendo '_'
    mov byte [r8], '_'

    ret

calcularDesplazamiento:
    imul rax, 7          ; Multiplicar por nro de filas                
    add rax, rbx         ; Sumar nro de columnas
    ret     

realizarMovimientoOficial:
    movzx rax, byte [filaOrigen]
    movzx rbx, byte [columnaOrigen]

    callAndAdjustStack calcularDesplazamiento

    lea r8, [tablero + rax]              

    movzx rax, byte [filaDestino]
    movzx rbx, byte [columnaDestino]

    callAndAdjustStack calcularDesplazamiento

    lea r9, [tablero + rax]

    ; Colocar 'O' en la posición de destino
    mov byte [r9], 'O'

    ; Liberar la posición de origen escribiendo '_'
    mov byte [r8], '_'

    ret