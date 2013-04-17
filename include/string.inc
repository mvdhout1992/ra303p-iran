%define _printf     0x005CD97B
%define _sprintf    0x005B8BAA

%macro printf 1-*
    %rep %0
        %rotate -1
        PUSH %1
    %endrep
    CALL _printf
    ADD ESP,(%0 * 4)
%endmacro

%macro sprintf 1-*
    %rep %0
        %rotate -1
        PUSH %1
    %endrep
    CALL _sprintf
    ADD ESP,(%0 * 4)
%endmacro
