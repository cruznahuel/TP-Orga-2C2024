determinarOficial:
    movzx r12, byte[filaOrigen]
    movzx r13, byte[columnaOrigen]

    cmp r12w, [filaOficial1]
    jne esOficial2
    cmp r13w, [columnaOficial1]
    jne esOficial2
    je  esOficial1

esOficial1:
    mov byte[oficialSeleccionado],1
    ret

esOficial2:
    mov byte[oficialSeleccionado],2
    ret

cargarPosicionOficial:

    cmp byte[oficialSeleccionado],1
    je  cargarPosicionOficial1
    jne cargarPosicionOficial2

    cargarPosicionOficial1:
        movzx r14, byte[filaOficial1]
        movzx r15, byte[columnaOficial1]
        ret
    cargarPosicionOficial2:
        movzx r14, byte[filaOficial1]
        movzx r15, byte[columnaOficial1]
        ret


leerArchivoOficiales:
    mov rdi, archivoOficialesALeer
    mov rsi, modoLectura
    callAndAdjustStack fopen

    cmp rax, 0
    jle errorLecturaArchivoOficiales

    mov qword[fileHandleOficiales], rax

    mov rdi, buffer
    mov rsi, 50
    mov rdx, qword[fileHandleOficiales]

    callAndAdjustStack fgets
    callAndAdjustStack eliminar_salto

    Strcpy datosOficial1, buffer

    mov r12, 9
    Strcpy buffer, datosOficial1
    callAndAdjustStack obtenerValorOficialSegunIndice ;a partir de un string en el buffer y un indice, guarda en el acumulador el numero que se encontraba ahi.
    mov word[filaOficial1] , ax


    mov r12, 10
    Strcpy buffer, datosOficial1

    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[columnaOficial1], ax
 

    ; leer la segunda linea (oficial 2)
    lea rdi, [buffer]
    mov rsi, 50
    mov rdx, [fileHandleOficiales]

    callAndAdjustStack fgets
    Strcpy datosOficial2, buffer

    mov r12, 9
    Strcpy buffer, datosOficial2

    callAndAdjustStack obtenerValorOficialSegunIndice ;a partir de un string y un indice, guarda en el acumulador el numero que se encontraba ahi.
    mov word[filaOficial2] , ax


    mov r12, 10
    Strcpy buffer, datosOficial2

    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[columnaOficial2], ax


    mov rax, 0
    jmp finLeerOficiales

    errorLecturaArchivoOficiales:
        mov rdi, mensajeErrorLectura
        mov rsi, archivoOficialesALeer
        callAndAdjustStack printf
        mov rax,1
    
    finLeerOficiales:
        mov rdi, qword[fileHandleOficiales]
        callAndAdjustStack fclose
        
        ret


    


eliminar_salto:
    xor rcx, rcx           ; Inicializar contador en 0
    mov rsi, buffer        ; RSI apunta al inicio del buffer

    contar_caracteres:
        cmp byte [rsi + rcx], 0 ; verifico si es '\0'
        je fin_calculo_longitud ; Si lo es, terminar
        inc rcx                 ; Incrementar el contador
        jmp contar_caracteres   ; Repetir para el siguiente carácter

    fin_calculo_longitud:
    ; RCX ahora contiene la longitud de la cadena en el buffer
    ; Puedes usar RCX como longitud_buffer
    dec rcx 
    buscar_salto:
    cmp byte [rsi + rcx], 10 ; Comparar con '\n'
    jne fin_eliminar_salto   ; Si no es '\n', terminar
    mov byte [rsi + rcx], 0  ; Reemplazar '\n' con '\0'
    fin_eliminar_salto:
        ret



obtenerValorOficialSegunIndice:
    mov r15,0                  
    mov r13,0  
    mov r14,0
    xor rax,rax ; doy valor 0 al acumulador                 
    jmp recorrarHastaElIndice   
    recorrarHastaElIndice:     
        mov bl, [buffer+r13]          
        cmp bl, ' '             
        je esNuevoNumero       
        cmp bl,0
        je fin
        inc r13
        jmp recorrarHastaElIndice

    esNuevoNumero:
        inc r13
        inc r14
        cmp r14, r12 ;comparo en indice actual con el pasado por parametro
        je procesarNumero
        jne recorrarHastaElIndice

    procesarNumero:
        mov bl, [buffer+r13]

        cmp bl, ' '
        je fin
        cmp bl,0
        je fin

        sub bl, '0' ; Convertir el dígito a número

        cmp r15, 0
        je sumarNumero ; Si es el primer dígito, no multiplicar por 10
        mov cl, 10
        mul cl ; Multiplicar el acumulador por 10

        sumarNumero:
            add ax, bx ; Sumar el dígito
            mov r15, 1 ; Marcar que ya no es el primer dígito
            inc r13
            jmp procesarNumero
    fin:
        ret

registrarDesplazamiento:
    callAndAdjustStack cargarPosicionOficial

    sub r14w, [filaDestino]
    sub r15w, [columnaDestino]
    callAndAdjustStack obtener_index
    ret
obtener_index:
    mov byte[indice],0
    cmp r14b,0
    jl .sur                    ; Fila aumenta
    jg .norte                  ; Fila disminuye
    cmp r15b, 0
    jl .este                   ; Columna aumenta
    jg .oeste                  ; Columna disminuye

    ; Caso: Sin movimiento
    mov byte [indice], 8        ; Índice para `soldadosCapturados`
    ret

.norte:
    cmp r15b, 0
    jl .noreste
    jg .noroeste
    mov byte [indice], 1        ; Norte
    ret


.sur:
    cmp r15b, 0
    jl .sudeste
    jg .sudoeste
    mov byte [indice], 6        ; Sur
    ret

.este:
    mov byte [indice], 4        ; Este
    ret

.oeste:
    mov byte [indice], 3        ; Oeste
    ret

.noreste:
    mov byte [indice], 2        ; Noreste
    ret

.noroeste:
    mov byte [indice], 0        ; Noroeste
    ret

.sudeste:
    mov byte [indice], 7        ; Sudeste
    ret

.sudoeste:
    mov byte [indice], 5        ; Sudoeste
    ret 