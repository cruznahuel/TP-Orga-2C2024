global main
%include "imports.asm"

section .data
    mensajeInicial                      db      "Bienvenidos al juego 'El Asalto'",0
    tablero                 times 50    db      0                                           ;49 para los caracteres y 1 para el 0 que agrega fgets
    archivoTablero                      db      "tablero.txt",0
    archivoTableroGuardado              db      "tableroGuardado.txt",0
    mensajeErrorLectura                 db      "Hubo un error al leer: %s",10,0
    modoLectura                         db      "r",0
    mensajeCargarPartida                db      "Hay una partida guardada, ¿quiere reanudarla? S/N",10,0
    respuestaPositiva                   db      'S'
    respuestaNegativa                   db      'N'
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0
    formatoChar                         db      "%c",0    
    formatoInputFilCol                  db      "%hi %hi", 0 ; Transformar los campos a nro entero (me sobra para guardar un nro entre 1 y 7)



    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndiceInt                    db      " %i ",0
    formatoIndiceChar                   db      " %c ",0
    nuevaLinea                          db      "",0


    prueba                              db      "prueba",0

    ; Seccion movimientos
    mensajeIngFilColOrigen              db      "Ingrese fila (0 a 6) y columna (0 a 6) que desea mover separados por un espacio: ", 0
    mensajeErrorInput                   db      "Los datos ingresados son inválidos, intente nuevamente.", 0
    mensajeInputCorrecto                db      "Los datos son correctos", 0
    mensajeSoldadoValido                db      "La posición indicada tiene efectivamente un soldado", 0
    mensajeErrorSoldado                 db      "No hay un soldado presente en esta posición", 0
    mensajeIngFilColDestino             db      "Ingrese fila (0 a 6) y columna (0 a 6) a la que desea mover separados por un espacio: ", 0
    
    soldado                             db      'X' ; Defino variable soldado con valor 'X'
    oficial                             db      'O' ; Defino variable oficial con valor 'O'
    lugarLibre                          db      '_' ; Defino variable lugarLibre con valor '_'

    mensajeErrorLugarLibre              db      "La posición seleccionada no está libre, por favor ingrese nuevamente", 0
    mensajeLugarLibreValido             db      "La posición seleccionada está efectivamente libre", 0
    mensajeErrorMovimiento              db      "El movimiento planteado no es valido", 0
    mensajeMovimientoValido             db      "El movimiento planteado es correcto", 0




section .bss
    fileHandle                          resq    1
    archivoALeer                        resb    30
    inputStr                            resb    30
    inputChar                           resb    1
    inputFilColOrigen                   resb    50 ; Defino un campo lo suficientemente grande para mitigar el riesgo de pisar memoria
    filaOrigen                          resw    1
    columnaOrigen                       resw    1
    inputValido                         resb    1 ; 'S' valido 'N' invalido
    inputFilColDestino                  resb    50
    filaDestino                         resw    1
    columnaDestino                      resw    1




section .text
main:
    Puts mensajeInicial
    
    sub rsp, 8
    call verificarTableroGuardado
    add rsp, 8

    sub rsp, 8
    call leerTablero        ;devuelve 0 si se pudo leer el archivo
    add rsp, 8
    cmp rax, 0
    jne finPrograma

    sub rsp, 8
    call imprimirTablero
    add rsp, 8

    Puts mensajeIngFilColOrigen
    Gets inputFilColOrigen

    lea rdi, [inputFilColOrigen]                  
    sub rsp, 8
    call validarFilColOrigen
    add rsp, 8


    cmp byte[inputValido], 'S'
    je continuar

    Puts mensajeErrorInput

    jmp main

    continuar:
    xor rax, rax  ; Limpia el valor previo en rax
    sub rsp, 8
    mov rsi, filaOrigen
    mov rdx, columnaOrigen
    ;mov dl, 'X' ; Valido que el lugar seleccionado contenga un soldado
    call validarLugarSoldado
    add rsp, 8

    cmp rax, 1
    je soldadoValido       ; Si hay un soldado, saltamos a soldadoValido.

    Puts mensajeErrorSoldado
    jmp main               ; Si no hay soldado, volvemos al inicio.

    soldadoValido:
    Puts mensajeSoldadoValido

    Puts mensajeIngFilColDestino
    Gets inputFilColDestino

    lea rdi, [inputFilColDestino]
    sub rsp, 8
    call validarFilColDestino
    add rsp, 8

    sub rsp, 8
    mov rsi, filaDestino
    mov rdx, columnaDestino
    ;mov dl, [lugarLibre] ; Valido que el lugar seleccionado esté libre
    call validarLugarLibre
    add rsp, 8

    cmp rax, 1
    je lugarLibreValido       ; Si el lugar está libre salto a lugarLibreValido

    Puts mensajeErrorLugarLibre
    jmp soldadoValido               

    lugarLibreValido:
    Puts mensajeLugarLibreValido
    sub rsp, 8
    call validarMovimientoSoldado
    add rsp, 8

    cmp rax, 1
    je movimientoSoldadoValido

    Puts mensajeErrorMovimiento
    jmp soldadoValido

    movimientoSoldadoValido:
    ; Imprimir mensaje de movimiento válido
    Puts mensajeMovimientoValido

    ret

    ; ...

    finPrograma:
    ret


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
    Scanf formatoChar, inputChar
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




