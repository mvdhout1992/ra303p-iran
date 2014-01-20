%define _fopen                                                        0x005D40B9
%define _fclose                                                       0x005D41C6

%assign _printf                                                       0x005CD97B
%assign _sprintf                                                      0x005B8BAA
%assign _fprintf                                                      0x005D41A5

%assign _stristr                                                      0x005CEC59
%assign _strdup                                                       0x005C3900
%assign _strcmpi                                                      0x005B8B50
%assign _strcpy                                                       0x005E55C8

%macro call_printf 1-*
    %rep %0
        %rotate -1
        PUSH %1
    %endrep
    call _printf
    add ESP,(%0 * 4)
%endmacro

%macro call_sprintf 1-*
    %rep %0
        %rotate -1
        PUSH %1
    %endrep
    call _sprintf
    add ESP,(%0 * 4)
%endmacro
