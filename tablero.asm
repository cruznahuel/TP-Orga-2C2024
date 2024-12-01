verificarTableroGuardado:                   ;devuelve el string archivoALeer con el valor "tablero.txt" o "tableroGuardado.txt"
    Strcpy archivoALeer, archivoTablero

    abrirArchivo archivoTableroGuardado, modoLectura
    cmp rax, 0
    jle finVerificarTableroGuardado

    mov qword[fileHandle], rax

    mov rdi, inputStr
    mov rsi, 3
    mov rdx, qword[fileHandle]
    sub rsp, 8
    call fgets
    add rsp, 8
    cmp rax, 0
    jle finVerificarTableroGuardado          ;significa que hay archivo pero esta vacio ya que fgetc devuelve -1

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
    je limpiarBuffer
    
    mov al, byte[inputChar]
    mov bl, byte[respuestaPositiva]
    cmp al, bl
    jne inputInvalido

    Strcpy archivoALeer, archivoTableroGuardado
    mov byte[hayPartidaGuardada], 'S'
    jmp limpiarBuffer

    inputInvalido:
    Puts mensajeEleccionCargaIncorrecta
    jmp pedirCargarPartida

    limpiarBuffer:
    sub rsp, 8
    call getchar
    add rsp, 8
    cmp al, 10
    jne limpiarBuffer

    finVerificarTableroGuardado:
    cerrarArchivo qword[fileHandle]

    ret

cargarTurnoGuardado:
    cmp byte[hayPartidaGuardada], 'N'
    je turnoCargado

    abrirArchivo archivoTurno, modoLectura
    cmp rax, 0
    jle errorAberturaArchivoTurno
    mov qword[fileHandle], rax

    mov rdi, turnoJugadorStr
    mov rsi, 2
    mov rdx, qword[fileHandle]
    sub rsp, 8
    call fgets
    add rsp, 8

    mov byte[turnoJugadorStr + 1], 0
    Sscanf3 turnoJugadorStr, formatoInt, turnoJugador
    cerrarArchivo qword[fileHandle]
    jmp turnoCargado

    errorAberturaArchivoTurno:
    Puts mensajeErrorAperturaGuardado
    mov rax, 1
    jmp finCargaTurnoGuardado

    turnoCargado:
    mov rax, 0

    finCargaTurnoGuardado:
    ret


leerTablero:
    sub rsp, 8
    call cargarTurnoGuardado
    add rsp, 8
    cmp rax, 1
    je z

    abrirArchivo archivoALeer, modoLectura
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
    cerrarArchivo qword[fileHandle]

    z:
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