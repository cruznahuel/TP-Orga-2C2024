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
        Strcpy datosOficialActual,datosOficial1
        ret
    cargarPosicionOficial2:
        movzx r14, byte[filaOficial2]
        movzx r15, byte[columnaOficial2]
        Strcpy datosOficialActual,datosOficial2
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

    dec rcx 
    buscar_salto:
    cmp byte [rsi + rcx], 10 ; Comparar con '\n'
    jne fin_eliminar_salto   ; Si no es '\n', terminar
    mov byte [rsi + rcx], 0  ; Reemplazar '\n' con '\0'
    fin_eliminar_salto:
        ret

añadir_salto:
    xor rcx, rcx           ; Inicializar contador en 0
    mov rsi, buffer        ; RSI apunta al inicio del buffer

    contar_caracteres_añadir: 
        cmp byte [rsi + rcx], 0 ; verifico si es '\0'
        je fin_calculo_longitud_añadir ; Si lo es, terminar
        inc rcx                 ; Incrementar el contador
        jmp contar_caracteres_añadir   ; Repetir para el siguiente carácter

    fin_calculo_longitud_añadir:

    mov byte [rsi + rcx], 10  ; Reemplazar '\0' con '\n'
    inc rcx
    mov byte [rsi + rcx], 0  ; agrego '\0'
    fin_añadir_salto:
        ret


obtenerValorOficialSegunIndice:
    mov r15,0                  
    mov r13,0  
    mov r14,0
    xor rax,rax ; doy valor 0 al acumulador  
    cmp r12b,0
    je procesarNumero   

    jmp recorrerHastaElIndice   
    recorrerHastaElIndice: 

        mov bl, [buffer+r13]          
        cmp bl, ' '             
        je esNuevoNumero       
        cmp bl,0
        je fin
        inc r13
        jmp recorrerHastaElIndice

    esNuevoNumero:
        inc r13
        inc r14
        cmp r14, r12 ;comparo en indice actual con el pasado por parametro
        je procesarNumero
        jne recorrerHastaElIndice

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
    xor r14,r14
    xor r15,r15
    callAndAdjustStack cargarPosicionOficial

    sub r14w, [filaDestino]
    sub r15w, [columnaDestino]
    callAndAdjustStack obtenerIndice
    callAndAdjustStack ajustarStringOficial

    mov r12, 9
    Strcpy buffer, datosOficial1
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[filaOficial1] , ax
    mov r12, 10
    Strcpy buffer, datosOficial1
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[columnaOficial1], ax

    mov r12, 9
    Strcpy buffer, datosOficial2
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[filaOficial2] , ax
    mov r12, 10
    Strcpy buffer, datosOficial2
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov word[columnaOficial2], ax

    ret
obtenerIndice:
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

ajustarStringOficial:
    Strcpy buffer,datosOficialActual
    mov r10,0 ;desplazamiento del string a modificar         
    mov r13,0 ;desplazamiento del string 
    mov r14,0 ;indice actual
    mov r15,0 ;0 para indicar que es primer digito 
    
    xor rax,rax ; doy valor 0 al acumulador     
    jmp copiarHastaElIndice  

    cmp byte[indice],0
    je registrarCambio

    copiarHastaElIndice: 
        
        cmp r14b, 9 ;comparo en indice actual con el pasado por parametro
        je registrarFilaColumna

        mov bl, [buffer+r13]  
        cmp bl, ' '             
        je nuevoNumero       
        cmp bl,0
        je finCopiar

        mov byte[datosOficialActual+r10],bl ;ver si asi esta bien, capaz haya que poner que es de tamaño byte.

        inc r13
        inc r10
        jmp copiarHastaElIndice

        nuevoNumero:
            mov byte[datosOficialActual+r10],bl ;ver si asi esta bien, capaz haya que poner que es de tamaño byte.
            inc r13
            inc r10
            inc r14
            cmp r14b,[indice]
            je  registrarCambio
            jne copiarHastaElIndice

    registrarCambio:
        mov bl, [buffer+r13]

        cmp bl, ' '
        je finRegistrarCambio
        cmp bl,0
        je finRegistrarCambio

        sub bl, '0' ; Convertir el dígito a número

        cmp r15, 0
        je sumarNumeroActual ; Si es el primer dígito, no multiplicar por 10
        mov cl, 10
        mul cl ; Multiplicar el acumulador por 10

        sumarNumeroActual:
            add ax, bx ; Sumar el dígito
            mov r15, 1 ; Marcar que ya no es el primer dígito
            inc r13
            jmp registrarCambio

        finRegistrarCambio:
            inc ax
            cmp r15, 1
            je convertirACaracter; si solo hay un caracter lo convierto, en caso contrario divido por 10 y convierto cada uno
            mov cl, 10
            div cl ; dividir el acumulador por 10
            mov bl,ah
            add bl,'0'
            mov byte[datosOficialActual+r10],bl;datosOficialActual contiene la direccion del string, r10 es el desplazamiento    VERI SI FUNCIONA ASI, CAPAZ HAY QUE PONER BYTE O ALGO
            inc r10

        convertirACaracter:
            mov bl,al
            add bl,'0'
            mov byte[datosOficialActual+r10],bl
            inc r10
            mov byte[datosOficialActual+r10],' ' ;ver si asi esta bien, capaz haya que poner que es de tamaño byte.
            jmp copiarHastaElIndice

    registrarFilaColumna:
        mov bl,[filaDestino]
        add bl, '0'
        mov byte[datosOficialActual+r10],bl

        inc r10
        mov byte[datosOficialActual+r10],' '

        inc r10
        mov bl,[columnaDestino]
        add bl, '0'
        mov byte[datosOficialActual+r10],bl
        inc r10
    
    finCopiar:
        mov byte[datosOficialActual+r10],0
        cmp byte[oficialSeleccionado],1
        je copiarOficial1
        jne copiarOficial2
        
        copiarOficial1:
            Strcpy datosOficial1,datosOficialActual
            ret
        copiarOficial2:
            Strcpy datosOficial2,datosOficialActual
            ret

imprimirDatosOficiales:

    xor rsi,rsi ;dejo el valor de rsi en 0

    mov r12, 0
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeNoroeste
    callAndAdjustStack printf

    mov r12, 1
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeNorte
    callAndAdjustStack printf

    mov r12, 2
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeNoreste
    callAndAdjustStack printf

    mov r12, 3
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeOeste
    callAndAdjustStack printf

    mov r12, 4
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeEste
    callAndAdjustStack printf

    mov r12, 5
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeSudoeste
    callAndAdjustStack printf

    mov r12, 6
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeSur
    callAndAdjustStack printf

    mov r12, 7
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeSudeste
    callAndAdjustStack printf

    mov r12, 8
    Strcpy buffer, datosOficialActual
    callAndAdjustStack obtenerValorOficialSegunIndice
    mov si, ax
    mov rdi, mensajeCapturas
    callAndAdjustStack printf

    ret
