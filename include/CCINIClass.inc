%assign        CCINIClass__CCINIClass                                 0x004C7C60

%assign        CCINIClass__Load                                       0x00462F50

;          int CCINIClass::Put_VQType(char *, char *, VQType)
%assign        CCINIClass__Put_VQType                                 0x00463830
;          int CCINIClass::Put_ThemeType(char *, char *, ThemeType)
%assign        CCINIClass__Put_ThemeType                              0x00463948

; args: <INI Name>, <FileClass>, <INIClass>
%macro call_CCINIClass__Load 3
    mov edx, %1
    mov eax, %2
    call FileClass__FileClass

    ; check ini exists
    mov eax, %2
    xor edx, edx
    call FileClass__Is_Available

    ; initialize iniclass
    mov eax, %3
    call CCINIClass__CCINIClass

    ; load fileclass to iniclass
    mov edx, %2
    mov eax, %3
    call CCINIClass__Load
%endmacro

; args: <INIClass>, <Section>, <Key>, <VQType Value>
%macro call_CCINIClass__Put_VQType 4
    mov  ebx, %3
    mov  edx, %2
    mov  eax, %1
    mov  cl, %4
    call CCINIClass__Put_VQType
%endmacro

; args: <INIClass>, <Section>, <Key>, <ThemeType Value>
%macro call_CCINIClass__Put_ThemeType 4
    mov  ebx, %3
    mov  edx, %2
    mov  eax, %1
    mov  cl, %4
    call CCINIClass__Put_ThemeType
%endmacro
