@HOOK   0x004DDD31  _HouseClass__Read_INI_Country_And_Colour
@HOOK   0x00540F20  _ScoreClass__Presentation_Proper_Country_Check
@HOOK   0x004DDE56  _HouseClass__Read_INI_Optional_House_Neutral_Ally
@HOOK   0x004DDE80  _HouseClass__Read_INI_Optional_House_Neutral_Ally_Patch_Out_Double

str_colour: db "Colour",0
str_country: db "Country",0
str_allytheneutralhouse db "AllyTheNeutralHouse",0
allyneutral: db 1

_HouseClass__Read_INI_Optional_House_Neutral_Ally_Patch_Out_Double:
    jmp     0x004DDE85

_HouseClass__Read_INI_Optional_House_Neutral_Ally: 
    mov     edx, 0Ah
    mov     eax, esi
   
    cmp     BYTE [allyneutral], 0
    jz      .Ret
    
    call     0x004D6060 ; HouseClass::Make_Ally(HousesType)
    
.Ret:
    mov     BYTE [allyneutral], 1
    jmp     0x004DDE62

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
    
    Save_Registers
    
    mov     ecx, 1   ; default
    mov     edx, edi    ; section
    mov     DWORD eax, [ebp-20h] ; scenario INI
    mov     ebx, str_allytheneutralhouse  ; key
    call    0x004F3ACC ; const INIClass::Get_Bool(char *,char *,int)
    
    mov     BYTE [allyneutral], al
    
    Restore_Registers
    jmp     0x004DDD36