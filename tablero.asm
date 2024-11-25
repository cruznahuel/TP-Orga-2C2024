verificarTableroGuardado:                   ;devuelve el string archivoALeer con el valor "tablero.txt" o "tableroGuardado.txt"
    Strcpy archivoALeer, archivoTablero

    mov rdi, archivoTableroGuardado
    mov rsi, modoLectura
    sub rsp, 8
    call fopen
    add rsp,8
    cmp rax, 0
    jle finVerificarTableroGuardado

    mov qword[fileHandle], rax

    mov rdi, qword[fileHandle]
    sub rsp, 8
    call fgetc
    add rsp, 8
    cmp rax, 0
    jl finVerificarTableroGuardado          ;significa que hay archivo pero esta vacio ya que fgetc devuelve -1

    mov rdi, qword[fileHandle]
    sub rsp, 8
    call fclose
    add rsp, 8  

    Puts mensajeCargarPartida

    pedirCargarPartida:
    Scanf2 formatoChar, inputChar
    cmp rax, 0
    jle inputInvalido

    xor rdi, rdi
    mov dil, byte[inputChar]
    sub rsp, 8
    call toupper
    add rsp, 8
    mov byte[inputChar], al
    
    mov al, byte[inputChar]
    mov bl, byte[respuestaNegativa]
    cmp al, bl
    je finVerificarTableroGuardado
    
    mov al, byte[inputChar]
    mov bl, byte[respuestaPositiva]
    cmp al, bl
    jne inputInvalido

    Strcpy archivoALeer, archivoTableroGuardado
    jmp finVerificarTableroGuardado

    inputInvalido:
    Puts mensajeEleccionCargaIncorrecta
    jmp pedirCargarPartida

    finVerificarTableroGuardado:
    ret


leerTablero:
    mov rdi, archivoALeer
    mov rsi, modoLectura
    sub rsp, 8
    call fopen
    add rsp, 8

    cmp rax, 0
    jle errorLecturaArchivo

    mov qword[fileHandle], rax

    mov rdi, tablero
    mov rsi, 50
    mov rdx, qword[fileHandle]
    sub rsp, 8
    call fgets
    add rsp, 8

    mov rax, 0
    jmp finLeerTablero

    errorLecturaArchivo:
    mov rdi, mensajeErrorLectura
    mov rsi, archivoALeer
    sub rsp, 8
    call printf
    add rsp, 8
    
    mov rax, 1

    finLeerTablero:
    mov rdi, qword[fileHandle]
    sub rsp, 8
    call fclose
    add rsp, 8

    ret


imprimirTablero:
    Puts nuevaLinea
    
    mov rdi, e
    sub rsp, 8
    call printf
    add rsp, 8

    mov r14, 0
    imprimirPrimeraLinea:
    
    mov rdi, formatoIndiceInt  
    mov rsi, r14
    sub rsp, 8
    call printf
    add rsp, 8

    inc r14
    cmp r14, 6
    jle imprimirPrimeraLinea

    Puts nuevaLinea

    mov r13, 0
    mov r14, 0
    mov r15, 0
    imprimirFila:
    
    mov rdi, formatoIndiceInt  
    mov rsi, r13
    sub rsp, 8
    call printf
    add rsp, 8

    imprimirCaracterTablero:
    mov rdi, formatoIndiceChar
    xor rsi, rsi
    mov sil, byte[tablero+r14+r15]
    sub rsp, 8
    call printf
    add rsp, 8
    inc r15
    cmp r15, 6
    jle imprimirCaracterTablero
    add r14, r15
    mov r15, 0

    Puts nuevaLinea

    inc r13
    cmp r13, 6
    jle imprimirFila

    Puts nuevaLinea

    ret