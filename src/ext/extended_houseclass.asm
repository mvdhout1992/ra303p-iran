@HOOK 0x004C7175 _TFixedHeapClass_fn_init_New_HouseClass_Size
@HOOK 0x004C8365 _TFixedHeapClass__HouseClass__Constructor_New_HouseClass_Size
@HOOK 0x004DDD1D _HouseClass__Read_INI_New_HouseClass_Size
@HOOK 0x004CED13 _TFixedHeapClass__HouseClass__Save_New_HouseClass_Size
@HOOK 0x004CEDF5 _TFixedHeapClass__HouseClass__Load_New_HouseClass_Size
@HOOK 0x004CEE10 _TFixedHeapClass__HouseClass__Load_Clear_Memory_For_Old_Savegames
@HOOK 0x004DDD31 _HouseClass__Read_INI
@HOOK 0x00540F20 _ScoreClass__Presentation_Proper_Country_Check
@HOOK 0x004DDE56 _HouseClass__Read_INI_Optional_House_Neutral_Ally
@HOOK 0x004DDE80 _HouseClass__Read_INI_Optional_House_Neutral_Ally_Patch_Out_Double

str_colour: db "Colour",0
str_color3: db "Color",0
str_country: db "Country",0
str_buildingsgetinstantlycaptured: db "BuildingsGetInstantlyCaptured",0
str_nobuildingcrew db "NoBuildingCrew",0
str_allytheneutralhouse db "AllyTheNeutralHouse",0
str_secondarycolorscheme db "SecondaryColorScheme",0
allyneutral: db 1

%define Old_HouseClass_Size     0x17A8
%define New_HouseClass_Size     0x27A8

%define    EXT_Resigned                0x17BC
%define    EXT_ConnectionLost            0x17B8
%define EXT_SpawnLocation            0x17B4
%define EXT_IsSpectator                0x17B0
%define EXT_SecondaryColorScheme    0x1802
; Use offset +0x1800 for bool BuildingsGetInstantlyCpatured
; Use offset +0x1801 for bool NoBuildingCrew
; Use offset +0x1802 for byte SecondaryColorScheme
; Use Offset +0x1803 to +0x1873 for infantry left
; Use Offset +0x1873 to +0x18E3 for tanks left
; Use Offset +0x1903 to +0x1973 for planes left
; Use Offset +0x1973 to +0x19E3 for vessels left
; Use Offset +0x1A00 to +0x1B60 for buildings left

_TFixedHeapClass__HouseClass__Load_Clear_Memory_For_Old_Savegames:
    Clear_Extended_Class_Memory_For_Old_Saves esi, New_HouseClass_Size, Old_HouseClass_Size

    mov  BYTE [esi+EXT_SecondaryColorScheme], 0xFF

.Ret:
    mov  ebx, 0x005F6538
    jmp  0x004CEE15

_TFixedHeapClass_fn_init_New_HouseClass_Size:
    mov  edx, New_HouseClass_Size
    jmp  0x004C717A

_TFixedHeapClass__HouseClass__Constructor_New_HouseClass_Size:
    mov  edx, New_HouseClass_Size
    jmp  0x004C836A

_HouseClass__Read_INI_New_HouseClass_Size:
    mov  edx, New_HouseClass_Size
    jmp  0x004DDD22

_TFixedHeapClass__HouseClass__Save_New_HouseClass_Size:
    mov  ebx, New_HouseClass_Size
    jmp  0x004CED18

_TFixedHeapClass__HouseClass__Load_New_HouseClass_Size:
    cmp  DWORD [SaveGameVersion], New_Savegame_Version
    jnz  .Old_Savegame

    mov  ebx, New_HouseClass_Size
    jmp  0x004CEDFA

.Old_Savegame:
    mov  ebx, Old_HouseClass_Size
    jmp  0x004CEDFA

_HouseClass__Read_INI_Optional_House_Neutral_Ally_Patch_Out_Double:
    cmp  edx, 0x0A ; Neutral house
    jz   .Ret

    call 0x004D6060  ; HouseClass::Make_Ally(HousesType)

.Ret:
    jmp  0x004DDE85

_HouseClass__Read_INI_Optional_House_Neutral_Ally:
    mov  edx, 0Ah
    mov  eax, esi

    cmp  BYTE [allyneutral], 0
    jz   .Ret

    call 0x004D6060 ; HouseClass::Make_Ally(HousesType)

.Ret:
    mov  BYTE [allyneutral], 1
    jmp  0x004DDE62

_ScoreClass__Presentation_Proper_Country_Check:

    mov  BYTE dl, [eax+0x41]
    mov  edi, eax
    jmp  0x00540F25

_HouseClass__Read_INI:
    call 0x004D33E4 ; HouseClass::HouseClass(HousesType)
    mov  [ebp-0x24], eax

    Save_Registers

    mov  esi, [ebp-0x24] ; HouseClass_This

    mov  ecx, 0xFF   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_colour  ; key
    call INIClass__Get_Int

    cmp  BYTE al, 0xFF
    jz   .No_Custom_Colour

    mov  [esi+0x178F], al

.No_Custom_Colour:

    Restore_Registers

    Save_Registers

    mov  esi, [ebp-0x24] ; HouseClass_This

    mov  ecx, 0xFF   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_color3  ; key
    call INIClass__Get_Int

    cmp  BYTE al, 0xFF
    jz   .No_Custom_Color

    mov  [esi+0x178F], al

.No_Custom_Color:

    Restore_Registers

    Save_Registers

    mov  esi, [ebp-0x24] ; HouseClass_This

    mov  ecx, 0xFF   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_country ; key
    call INIClass__Get_Int

    cmp  BYTE al, 0xFF
    jz   .No_Custom_Country

    mov  [esi+0x41], al


.No_Custom_Country:

    Restore_Registers

    Save_Registers

    mov  ecx, 0   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_buildingsgetinstantlycaptured  ; key
    call INIClass__Get_Bool
    mov  ecx, [ebp-0x24] ; HouseClass this pointer
    mov  [ecx+0x1800], al

    Restore_Registers

    Save_Registers

    mov  ecx, 0   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_nobuildingcrew  ; key
    call INIClass__Get_Bool
    mov  ecx, [ebp-0x24] ; HouseClass this pointer
    mov  [ecx+0x1801], al

    Restore_Registers

    Save_Registers

    mov  ecx, 0xFF   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_secondarycolorscheme ; key
    call INIClass__Get_Int
    mov  ecx, [ebp-0x24] ; HouseClass this pointer
    mov  [ecx+0x1802], al

    Restore_Registers

    Save_Registers

    mov  ecx, 1   ; default
    mov  edx, edi    ; section
    mov  DWORD eax, [ebp-20h] ; scenario INI
    mov  ebx, str_allytheneutralhouse  ; key
    call INIClass__Get_Int

    mov  BYTE [allyneutral], al

    Restore_Registers
    jmp  0x004DDD36
