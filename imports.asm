; imports.asm
extern system
extern gets
extern puts
extern printf
extern scanf
extern sscanf
extern sprintf

extern fopen
extern fclose
extern fputs
extern fgets
extern fgetc
extern strcpy
extern strcmp
extern toupper
extern getchar

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

%macro Printf2 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

%macro Scanf2 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call scanf
    add rsp, 8
%endmacro

%macro Sscanf3 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

%macro Sscanf4 4
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    mov rcx, %4
    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

%macro Sprintf3 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    sub rsp, 8
    call sprintf
    add rsp, 8
%endmacro

%macro Strcpy 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call strcpy
    add rsp, 8
%endmacro

%macro limpiarTerminal 0
    mov rdi, cmd_clear
    sub rsp, 8
    call system
    add rsp, 8
%endmacro

%macro abrirArchivo 2
    mov rdi, %1
    mov rsi, %2
    sub rsp, 8
    call fopen
    add rsp, 8
%endmacro

%macro cerrarArchivo 1
    mov rdi, %1
    sub rsp, 8
    call fclose
    add rsp, 8
%endmacro

;%macro callAndAdjustStack 1
;    sub rsp, 8
;    call %1
;    add rsp, 8
;%endmacro
