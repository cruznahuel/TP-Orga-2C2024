ingresarDatos:
    Puts mensajeIngFilColOrigen
    Gets inputFilCol

    lea rdi, [inputFilCol]
                   
    mov rdx, r12           
    mov rcx, r13 
    
    callAndAdjustStack validarFilCol
    
    ret


siguienteTurno:    
    mov al, [turnoSoldado]  
    xor al, 1               
    mov [turnoSoldado], al  
    
    callAndAdjustStack iniciarTurno

    ret     


calcularDesplazamiento:
    imul rax, 7          ; Multiplicar por nro de filas                
    add rax, rbx         ; Sumar nro de columnas
    ret     


realizarMovimiento:
    movzx rax, byte [filaOrigen]
    movzx rbx, byte [columnaOrigen]

    callAndAdjustStack calcularDesplazamiento

    lea r8, [tablero + rax]              

    movzx rax, byte [filaDestino]
    movzx rbx, byte [columnaDestino]

    callAndAdjustStack calcularDesplazamiento

    lea r9, [tablero + rax]

    ; Colocar 'O' en la posición de destino
    mov al, byte [caracter]              
    mov byte [r9], al   

    ; Liberar la posición de origen escribiendo '_'
    mov byte [r8], '_'

    ret