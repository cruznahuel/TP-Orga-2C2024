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



validarLugarSoldado:
    movzx rax, byte[rsi]         ; Cargar la fila pasada en rsi
    imul rax, 7                  ; Multiplicar fila por el número de columnas (7)
    movzx rbx, byte[rdx]         ; Cargar la columna pasada en rdx
    add rax, rbx                 ; Índice = fila * 7 + columna

    mov cl, byte[tablero + rax]  ; Cargar el carácter correspondiente en el tablero

    ; Comparar cl con dl
    cmp cl, 'X'                  ; Comparar con el símbolo pasado en dl
    jne lugarSoldadoInvalido     ; Saltar si no coinciden

    mov rax, 1                   ; Retornar 1 si es válido
    ret

    lugarSoldadoInvalido:
    xor rax, rax                 ; Retornar 0 si es inválido
    ret

validarLugarLibre:
    movzx rax, byte[rsi]         ; Cargar la fila pasada en rsi
    imul rax, 7                  ; Multiplicar fila por el número de columnas (7)
    movzx rbx, byte[rdx]         ; Cargar la columna pasada en rdx
    add rax, rbx                 ; Índice = fila * 7 + columna

    mov cl, byte[tablero + rax]  ; Cargar el carácter correspondiente en el tablero

    ; Comparar cl con dl
    cmp cl, '_'                  ; Comparar con el símbolo pasado en dl
    jne lugarLibreInvalido       ; Saltar si no coinciden

    mov rax, 1                   ; Retornar 1 si es válido
    ret

    lugarLibreInvalido:
    xor rax, rax                 ; Retornar 0 si es inválido
    ret    


validarMovimientoSoldado:
    movzx rax, byte[filaDestino]
    movzx rbx, byte[filaOrigen]
    sub rax, rbx
    cmp rax, 1
    jne movimientoInvalido

    movzx rax, byte[columnaDestino]
    movzx rbx, byte[columnaOrigen]
    sub rax, rbx
    cmp rax, 1
    jg movimientoInvalido

    ; Validar que filaDestino > filaOrigen
    movzx rax, byte[filaDestino]
    movzx rbx, byte[filaOrigen]
    cmp rax, rbx
    jg movimientoValido

    movimientoInvalido:
    xor rax, rax
    ret

    movimientoValido:
    mov rax, 1
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