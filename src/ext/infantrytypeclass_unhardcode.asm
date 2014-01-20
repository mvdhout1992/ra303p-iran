@HOOK 0x004EB040 _InfantryTypeClass__From_Name_Unhardcode_InfantryTypes_Count
@HOOK 0x004F40C7 _Init_Game_Set_InfantryTypes_Heap_Count
@HOOK 0x004EAF16 _InfantryTypeClass__Init_Heap_UnhardCode_UnitTypes
@HOOK 0x004597F2 _BuildingClass__Update_Buildables_UnhardCode_InfantryTypes
@HOOK 0x004EB159 _InfantryTypeClass__One_Time_UnhardCode_InfantryTypes

str_InfantryTypes db"InfantryTypes",0
InfantryTypesExtCount    db    0

_InfantryTypeClass__One_Time_UnhardCode_InfantryTypes:
    mov  al, [InfantryTypesExtCount]
    add  al, 0x1A

    cmp  dl, al
    jl   0x004EB08D
    jmp  0x004EB162

_BuildingClass__Update_Buildables_UnhardCode_InfantryTypes:
    mov  al, [InfantryTypesExtCount]
    add  al, 0x1A

    cmp  dh, al
    jl   0x0045972F
    jmp  0x004597FB

Init_InfantryTypeClass:
    mov  eax, 1A2h
    call 0x004DF728 ; InfantryTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  ecx, eax

    pop  eax
    mov  edx, ebx
    add  edx, 0x1A ; InfantryType

    push 0               ; __int32
    push 2               ; char
    push 2               ; char
    push 0x00601A4C        ; offset DoInfoStruct E1DoControls[] ; __int32
    push 1        ; char
    push 0               ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 0               ; __int32
    push 1        ; __int32
    push 0               ; __int32
    push 10h             ; __int32
    mov  ebx, 48h
    push 35h             ; __int32
    mov  DWORD [0x006019C4], 1
    call 0x004DF5E0 ; InfantryTypeClass::InfantryTypeClass(InfantryType,int,char *,int,int,int,int,int,int,int,int,PipEnum,DoInfoStruct *,int,int,char *)
.Ret:
    retn

_InfantryTypeClass__Init_Heap_UnhardCode_UnitTypes:

Loop_Over_RULES_INI_Section_Entries str_InfantryTypes, Init_InfantryTypeClass

.Ret:
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    jmp  0x004EAF1C


_Init_Game_Set_InfantryTypes_Heap_Count:
    Get_RULES_INI_Section_Entry_Count str_InfantryTypes

    mov  BYTE [InfantryTypesExtCount], al
    mov  edx, eax
    add  edx, 1Ah
    jmp  0x004F40CC


_InfantryTypeClass__From_Name_Unhardcode_InfantryTypes_Count:
    mov  al,    [InfantryTypesExtCount]
    add  al, 1Ah

    cmp  dl, al
    jl   0x004EB04C
    jmp  0x004EB045
