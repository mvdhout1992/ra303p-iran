@HOOK 0x00584B44 _VesselTypeClass__From_Name_Unhardcode_VesselTypes
@HOOK 0x004F410B _Init_Game_Set_VesselTypes_Heap_Count
@HOOK 0x0058484B _VesselTypeClass__Init_Heap_Unhardcode_VesselTypes
@HOOK 0x00584A3A _VesselTypeClass__One_Time_Unhardcode_VesselTypes
@HOOK 0x00459661 _BuildingClass__Update_Buildables_Unhardcode_VesselTypes

str_VesselTypes db"VesselTypes",0
VesselTypesTypesExtCount    db    0
%define        OriginalVesselTypesHeapCount    7

_BuildingClass__Update_Buildables_Unhardcode_VesselTypes:
    mov  al, [VesselTypesTypesExtCount]
    add  al, OriginalVesselTypesHeapCount

    cmp  dl, al
    jl   0x00459620
    jmp  0x00459666

_VesselTypeClass__One_Time_Unhardcode_VesselTypes:
    mov  al, [VesselTypesTypesExtCount]
    add  al, OriginalVesselTypesHeapCount

    cmp  dh, al
    jl   0x0058497D
    jmp  0x00584A43

Init_VesslTypeeClass:
    mov  eax, 19Eh
    call 0x00581FEC ; VesselTypeClass::operator new(uint)
    test eax, eax
    jz   .Ret

    push eax
    mov  eax, edx
    ; edx should have the name of the INI section already
    call 0x005C3900 ; strdup()
    mov  ecx, eax

    pop  eax
    mov  edx, ebx
    add  edx, OriginalVesselTypesHeapCount ; VesselType

    push 0Eh
    push 8
    push 1
    push 1
    push 0
    push 0
    push 0
    push 0
    push 0
    push 0
    mov  ebx, 17Ch
    push 0
    mov  DWORD [0x00605A90], 1 ; __Vessel_Idx
    call 0x00581F0C ; VesselTypeClass::VesselTypeClass(VesselType,int,char *,AnimType,int,int,int,int,int,int,int,int,int,int)

.Ret:
    retn

_VesselTypeClass__Init_Heap_Unhardcode_VesselTypes:

    Loop_Over_RULES_INI_Section_Entries str_VesselTypes, Init_VesslTypeeClass

.Ret:
    lea  esp, [ebp-14h]
    pop  edi
    pop  esi
    pop  edx
    jmp  0x00584851

_Init_Game_Set_VesselTypes_Heap_Count:
    Get_RULES_INI_Section_Entry_Count str_VesselTypes
    mov  BYTE [VesselTypesTypesExtCount], al
    mov  edx, eax

    add  edx, OriginalVesselTypesHeapCount
    jmp  0x004F4110

_VesselTypeClass__From_Name_Unhardcode_VesselTypes:
    mov  al, [VesselTypesTypesExtCount]
    add  al, OriginalVesselTypesHeapCount

    cmp  dl, al
    jl   0x00584B50
    jmp  0x00584B49
