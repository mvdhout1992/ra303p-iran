@HOOK 0x00578974 _UnitTypeClass__From_Name_Unhardcode_UnitTypes_Count
@HOOK 0x004F40FA _Init_Game_Set_UnitTypes_Heap_Count
@HOOK 0x00578950 _UnitTypeClass__Init_Heap_UnhardCode_UnitTypes
@HOOK 0x00459715 _BuildingClass__Update_Buildables_UnhardCode_UnitTypes
@HOOK 0X00578ADB _UnitTypeClass__One_Time_UnhardCode_UnitTypes

str_UnitTypes db"UnitTypes",0
UnitTypesCount    db    0

_UnitTypeClass__One_Time_UnhardCode_UnitTypes:
    mov  al, [UnitTypesCount]
    add  al, 0x16

    cmp  dl, al
    jl   0x005789BF
    jmp  0x00578AE4

_BuildingClass__Update_Buildables_UnhardCode_UnitTypes:
    mov  al,    [UnitTypesCount]
    add  al, 0x16
    cmp  bl, al
    jl   0x004596D4
    jmp  0x0045971A

Init_UnitTypeClass:
    mov  eax, 19Eh
    call 0x0056E290 ; UnitTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  ecx, eax

    pop  eax
    mov  edx, ebx
    add  edx, 0x16 ; UnitType

    push 0Eh
    push 0
    push 20h
    push 0
    push 0
    push 0
    push 1
    push 0
    push 0
    push 0
    push 1
    push 0
    push 0
    push 0
    push 1
    push 0
    push 1
    push 0
    push 0C0h
    push 0
    push 0C0h
    push 30h
    mov  ebx, 41h ; translation ID
    push 1
    mov  DWORD [0x006057E4], 3 ; Turret Dir adjust
    push 2
    call 0x0056E09C    ; UnitTypeClass::UnitTypeClass( lots of args..)
.Ret:
    retn

_UnitTypeClass__Init_Heap_UnhardCode_UnitTypes:

Loop_Over_RULES_INI_Section_Entries str_UnitTypes, Init_UnitTypeClass

.Ret:
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    jmp  0x00578956



_Init_Game_Set_UnitTypes_Heap_Count:
    Get_RULES_INI_Section_Entry_Count str_UnitTypes

    mov  BYTE [UnitTypesCount], al
    mov  edx, eax
    add  edx, 16h
    jmp  0x004F40FF

_UnitTypeClass__From_Name_Unhardcode_UnitTypes_Count:
    mov  al,    [UnitTypesCount]
    add  al, 16h


    cmp  dl, al
    jl   0x00578980
    jmp  0x0057899E
