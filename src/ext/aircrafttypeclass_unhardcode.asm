@HOOK 0x00403F08 _AircraftTypeClass__From_Name_Unhardcode_AircraftTypes
@HOOK 0x004F40B6 _Init_Game_Set_AircraftTypes_Heap_Count
@HOOK 0x00403EE3 _AircraftTypeClass__Init_Heap_Unhardcode_AircraftTypes
@HOOK 0x00403FF3 _AircraftTypeClass__One_Time_Unhardcode_AircraftTypes
@HOOK 0x00459850 _BuildingClass__Update_Buildables_Unhardcode_AircraftTypes

str_AircraftTypes db"AircraftTypes",0
AircraftTypesTypesExtCount    db    0
%define        OriginalAircraftTypesHeapCount    7

_BuildingClass__Update_Buildables_Unhardcode_AircraftTypes:
    mov  al, [AircraftTypesTypesExtCount]
    add  al, OriginalAircraftTypesHeapCount
    cmp  ah, al
    jl   0x0045980F
    jmp  0x00459855

_AircraftTypeClass__One_Time_Unhardcode_AircraftTypes:
    mov  al, [AircraftTypesTypesExtCount]
    add  al, OriginalAircraftTypesHeapCount
    cmp  dl, al
    jl   0x00403F55
    jmp  0x00403FFC

Init_AircraftTypeClass:
    mov  eax, 19Dh
    call 0x00401324 ; AircraftTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  ecx, eax

    pop  eax
    mov  edx, ebx
    add  edx, OriginalAircraftTypesHeapCount ; AircraftType

    push 0Eh
    push 20h
    push 0FFh
    push 0Eh
    push 0
    push 0
    push 1
    push 1
    push 1
    push 0
    push 0
    push 1
    push 0
    push 0
    push 40h
    mov  ebx, 4Ch
    push 0
    mov  DWORD [0x005FDF74], 5
    call 0x00401210 ; AircraftTypeClass::AircraftTypeClass(AircraftType,int,char *,int,int,int,int,int,int,int,int,int,int,int,int,StructType,int,int,MissionType)


.Ret:
    retn

_AircraftTypeClass__Init_Heap_Unhardcode_AircraftTypes:

    Loop_Over_RULES_INI_Section_Entries str_AircraftTypes, Init_AircraftTypeClass

.Ret:
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    jmp  0x00403EE9

_Init_Game_Set_AircraftTypes_Heap_Count:
    Get_RULES_INI_Section_Entry_Count str_AircraftTypes

    mov  BYTE [AircraftTypesTypesExtCount], al
    mov  edx, eax

    add  edx, OriginalAircraftTypesHeapCount
    jmp  0x004F40BB

_AircraftTypeClass__From_Name_Unhardcode_AircraftTypes:
    mov  al, [AircraftTypesTypesExtCount]
    add  al, OriginalAircraftTypesHeapCount

    cmp  dl, al
    jl   0x00403F14
    jmp  0x00403F0D
