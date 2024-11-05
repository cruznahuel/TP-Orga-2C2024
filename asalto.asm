global main
extern gets
extern puts
extern printf
extern scanf

extern fgets
extern fread 

extern fputs
extern fopen
extern fclose
extern strcpy
extern strcmp

%macro Puts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro
%macro Gets 1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro
%macro inputNumero 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call scanf
    add rsp, 8
%endmacro
%macro Strcpy 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call strcpy
    add rsp, 8
%endmacro

section .data
    mensajeInicial                      db      "Bienvenidos al juego 'El Asalto'",10,0
    tablero                 times 49    db      " "
    archivoTablero                      db      "tablero.txt",0
    archivoTableroGuardado              db      "tableroGuardado.txt",0
    mensajeErrorLectura                 db      "Hubo un error al leer: %s",10,0
    modoLectura                         db      "r",0
    mensajeCargarPartida                db      "Hay una partida guardada, ¿quiere reanudarla? S/N",10,0
    respuestaPositiva                   db      "S",0
    respuestaNegativa                   db      "N",0
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0




    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndice                       db      " %i ",0
    formatoChar                         db      " %c ",0
    nuevaLinea                          db      "",0


    prueba                              db      "prueba",0

section .bss
    fileHandle                          resq    1
    archivoALeer                        resb    30
    inputStr                            resb    30






section .text
main:
    Puts mensajeInicial
    
    Strcpy archivoALeer, archivoTablero
    
    sub rsp, 8
    call verificarTableroGuardado
    add rsp, 8

    sub rsp, 8
    call leerTablero
    add rsp, 8
    
    Puts prueba
    
    cmp rax, 0
    je finPrograma

    
    sub rsp, 8
    call imprimirTablero
    add rsp, 8


    ; ...



    finPrograma:
    ret


verificarTableroGuardado:
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
    call fclose
    add rsp, 8  

    Puts mensajeCargarPartida

    pedirCargarPartida:
    Gets inputStr
    ; podriamos ver que si ingresan s o n (minusculas) sea valido tambien. Habria que usar la funcion toupper()
    mov rdi, inputStr
    mov rsi, respuestaNegativa
    sub rsp, 8
    call strcmp
    add rsp, 8

    cmp rax, 0
    jmp finVerificarTableroGuardado
    
    mov rdi, inputStr
    mov rsi, respuestaPositiva
    sub rsp, 8
    call strcmp
    add rsp, 8

    cmp rax, 0
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

    mov rdi, tablero
    mov rsi, 49
    mov rdx, qword[fileHandle]
    sub rsp, 8
    call fgets
    add rsp, 8
    jmp finLeerTablero

    errorLecturaArchivo:
    mov rdi, mensajeErrorLectura
    mov rsi, archivoALeer
    sub rsp, 8
    call printf
    add rsp, 8 
    
    mov rax, 0

    finLeerTablero:
    mov rax, 1
    ret

imprimirTablero:
    Puts nuevaLinea
    Puts e

    mov rax, 0
    imprimirPrimeraLinea:
    
    mov rdi, formatoIndice
    mov rsi, rax
    sub rsp, 8
    call printf
    add rsp, 8

    inc rax
    cmp rax, 6
    jle imprimirPrimeraLinea

    Puts nuevaLinea

    mov rax, 0
    mov rbx, 0
    imprimirFila:
    
    mov rdi, formatoIndice
    mov rsi, rax
    sub rsp, 8
    call printf
    add rsp, 8

    imprimirCaracterTablero:
    mov rdi, formatoChar 
    xor rsi, rsi
    mov sil, byte[tablero+rbx]
    sub rsp, 8
    call printf
    add rsp, 8
    inc rbx
    cmp rbx, 6
    jle imprimirCaracterTablero

    Puts nuevaLinea

    inc rax
    cmp rax, 6
    jle imprimirFila


    ret