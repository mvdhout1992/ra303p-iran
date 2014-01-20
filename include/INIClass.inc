;              INIClass::~INIClass(void)
%assign        INIClass__~INIClass                                  0x004F25D0

%assign        INIClass__Load                                       0x004F28C4
;    int const INIClass::Save(FileClass &)
%assign        INIClass__Save                                       0x004F2F08
%assign        INIClass__Entry_Count                                0x004F31BC

;        const INIClass::Get_Bool(char *,char *,int)
%assign        INIClass__Get_Bool                                   0x004F3ACC
;        const INIClass::Get_Int(char *,char *,int)
%assign        INIClass__Get_Int                                    0x004F3660
%assign        INIClass__Get_String                                 0x004F3A34
; char * const INIClass::Get_Entry(char *, int)
%assign        INIClass__Get_Entry                                  0x004F31EC
%assign        INIClass__Get_Textblock                              0x004F3528
%assign        INIClass__Get_UUBlock                                0x004F3338

;          int INIClass::Put_Bool(char *, char *, int)
%assign        INIClass__Put_Bool                                   0x004F3AB0
;          int INIClass::Put_Int(char *,char *,int,int)
%assign        INIClass__Put_Int                                    0x004F35E8
;          int INIClass::Put_String(char *,char *,char *)
%assign        INIClass__Put_String                                 0x004F3760
;          int INIClass::Put_Fixed(char *, char *, fixed)
%assign        INIClass__Put_Fixed                                  0x004F3D80


; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro call_INIClass__Get_Bool 4
    mov  ecx, dword %4
    mov  ebx, dword %3
    mov  edx, dword %2
    mov  eax, %1
    call INIClass__Get_Bool
%endmacro

; args: <INIClass>, <section>, <key>, <default>, <dst>
%macro call_INIClass__Get_Int 4
    mov  ecx, dword %4
    mov  ebx, dword %3
    mov  edx, dword %2
    mov  eax, %1
    call INIClass__Get_Int
%endmacro

; args: <INICLAS> <section>, <key>, <default>, <dst>, <dst_len>
%macro call_INIClass__Get_String 6
    push %6             ; dst len
    push %5             ; dst
    mov  ecx, dword %4  ; default
    mov  ebx, dword %3  ; key
    mov  edx, dword %2  ; section
    mov  eax, %1
    call INIClass__Get_String
%endmacro

; args: <INIClass>, <Section>, <Key>, <Bool Value>
%macro call_INIClass__Put_Bool 4
    mov  ebx, %3
    mov  edx, %2
    mov  eax, %1
    mov  ecx, %4
    call INIClass__Put_Bool
%endmacro

; args: <INIClass>, <Section>, <Key>, <Int Value>
%macro call_INIClass__Put_Int 4
    push 0
    mov  ebx, %3
    mov  edx, %2
    mov  eax, %1
    mov  ecx, %4
    call INIClass__Put_Int
%endmacro

; args: <INIClass>, <Section>, <Key>, <String Value>
%macro call_INIClass__Put_String 4
    mov  ebx, %3
    mov  edx, %2
    mov  ecx, %4
    mov  eax, %1
    call INIClass__Put_String
%endmacro

; args: <INIClass>, <Section>, <Key>, <Fixed Value>
%macro call_INIClass__Put_Fixed 4
    mov  ebx, %3
    mov  edx, %2
    mov  eax, %1
    mov  ecx, %4
    call INIClass__Put_Fixed
%endmacro
x