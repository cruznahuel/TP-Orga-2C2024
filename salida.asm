menuSalida:
    Puts mensajeEleccionSalida

    pedirOpcionSalida:
    Scanf2 formatoChar, eleccionSalida
    cmp rax, 0
    je formatoIncorrecto

    xor rdi, rdi
    mov dil, byte[eleccionSalida]
    sub rsp, 8
    call toupper
    add rsp, 8
    mov byte[eleccionSalida], al

    cmp byte[eleccionSalida], 'G'
    je guardarPartida

    cmp byte[eleccionSalida], 'X'
    je salirSinGuardar
    
    Puts mensajeEleccionSalidaIncorrecta
    jmp pedirOpcionSalida

    formatoIncorrecto:
    Puts mensajeFormatoIncorrecto
    jmp pedirOpcionSalida

    guardarPartida:
    ;Guardado tablero
    abrirArchivo archivoTableroGuardado, modoEscritura
    cmp rax, 0
    jle errorAberturaArchivo
    mov qword[fileHandle], rax

    mov rdi, tablero
    mov rsi, qword[fileHandle]
    sub rsp, 8
    call fputs
    add rsp, 8
    cmp rax, 0
    jle errorGuardado
    cerrarArchivo qword[fileHandle]
    
    ;Guardado turno
    abrirArchivo archivoTurno, modoEscritura
    cmp rax, 0
    jle errorAberturaArchivo
    mov qword[fileHandle], rax

    ;mov r10b, byte[turnoJugador]
    ;mov byte[turnoJugadorStr], r10b
    xor r10, r10
    mov r10b, byte[turnoJugador]
    Sprintf3 turnoJugadorStr, formatoInt, r10
    mov rdi, turnoJugadorStr
    mov rsi, qword[fileHandle]
    sub rsp, 8
    call fputs
    add rsp, 8
    cmp rax, 0
    jle errorGuardado
    cerrarArchivo qword[fileHandle]

    Puts mensajeGuardadoExitoso
    jmp terminarSalida

    salirSinGuardar:
    abrirArchivo archivoTableroGuardado, modoEscritura
    cmp rax, 0
    jle errorAberturaArchivo
    mov qword[fileHandle], rax
    cerrarArchivo qword[fileHandle]

    abrirArchivo archivoTurno, modoEscritura
    cmp rax, 0
    jle errorAberturaArchivo
    mov qword[fileHandle], rax
    cerrarArchivo qword[fileHandle]

    Puts mensajeSalirSinGuardar
    jmp terminarSalida

    errorAberturaArchivo:
    Puts mensajeErrorAperturaGuardado
    jmp menuSalida

    errorGuardado:
    Puts mensajeErrorGuardado
    jmp menuSalida

    terminarSalida:
    add rsp,16
    add rsp,16
    add rsp,16
    add rsp,16

    jmp finPrograma



