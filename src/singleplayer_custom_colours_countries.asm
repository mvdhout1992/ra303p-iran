@HOOK   0x004DDD31  _HouseClass__Read_INI_Country_And_Colour
@HOOK   0x00540F20  _ScoreClass__Presentation_Proper_Country_Check

str_colour: db "Colour",0
str_country: db "Country",0

_ScoreClass__Presentation_Proper_Country_Check:
    
    mov     BYTE dl, [eax+0x41]
    mov     edi, eax
    jmp     0x00540F25

_HouseClass__Read_INI_Country_And_Colour
    call    0x004D33E4 ; HouseClass::HouseClass(HousesType)
    mov     [ebp-0x24], eax
    
    Save_Registers   
    
    mov     esi, [ebp-0x24] ; HouseClass_This
    
    mov     ecx, 0xFF   ; default
    mov     edx, edi    ; section
    mov     DWORD eax, [ebp-20h] ; scenario INI
    mov     ebx, str_colour  ; key
    call    0x004F3660 ; const INIClass::Get_Int(char *,char *,int)
    
    cmp     BYTE al, 0xFF
    jz      .No_Custom_Colour
    
    mov     [esi+0x178F], al
    
.No_Custom_Colour:
    
    Restore_Registers
    
    Save_Registers
    
    mov     esi, [ebp-0x24] ; HouseClass_This
    
    mov     ecx, 0xFF   ; default
    mov     edx, edi    ; section
    mov     DWORD eax, [ebp-20h] ; scenario INI
    mov     ebx, str_country ; key
    call    0x004F3660 ; const INIClass::Get_Int(char *,char *,int)
    
    cmp     BYTE al, 0xFF
    jz      .No_Custom_Country
    
    mov     [esi+0x41], al
    
.No_Custom_Country:
    
    Restore_Registers
    jmp     0x004DDD36