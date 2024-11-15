global main
extern gets
extern puts
extern printf
extern scanf

extern fgets
extern fread 

extern fputs
extern fopen
extern fgetc
extern fclose
extern strcpy
extern strcmp
extern toupper

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
%macro Scanf 2
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
    respuestaPositiva                   db      'S'
    respuestaNegativa                   db      'N'
    mensajeEleccionCargaIncorrecta      db      "Respuesta inválida, debe ser S o N",10,0
    formatoChar                         db      "%c",0    



    ;Para la impresion del tablero
    e                                   db      "   ",0
    formatoIndiceInt                    db      " %i ",0
    formatoIndiceChar                   db      " %c ",0
    nuevaLinea                          db      "",0


    prueba                              db      "prueba",0

section .bss
    fileHandle                          resq    1
    archivoALeer                        resb    30
    inputStr                            resb    30
    inputChar                           resb    1





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

    mov rdi, byte[inputChar]
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

    mov rdi, tablero
    mov rsi, 49
    mov rdx, qword[fileHandle]
    sub rsp, 8
    Puts prueba
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
    ret
    

imprimirTablero:
    Puts nuevaLinea
    Puts e

    mov rax, 0
    imprimirPrimeraLinea:
    
    mov rdi, formatoIndiceInt  
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
    
    mov rdi, formatoIndiceInt  
    mov rsi, rax
    sub rsp, 8
    call printf
    add rsp, 8

    imprimirCaracterTablero:
    mov rdi, formatoIndiceChar
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