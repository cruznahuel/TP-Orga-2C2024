; imports.asm
extern gets
extern puts
extern printf
extern scanf
extern sscanf

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

%macro callAndAdjustStack 1
    sub rsp, 8
    call %1
    add rsp, 8
%endmacro
