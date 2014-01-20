@HOOK 0x004D8CB4 _HouseClass__Init_Data_Spectator_Stuff
@HOOK 0x0053E4FB _Create_Units_Skip_Dead_Houses
@HOOK 0x0053DFD7 _Assign_Houses_Set_Up_Player_Pointer
@HOOK 0x00581153 _UnitClass__Read_INI_Skip_Dead_Houses
@HOOK 0x0058CAD3 _VesselClass__Read_INI_Skip_Dead_Houses
@HOOK 0x004F095B _InfantryClass__Read_INI_Skip_Dead_Houses
@HOOK 0x0045EF20 _BuildingClass__Read_INI_Skip_Dead_Houses
@HOOK 0x005326A2 _RadarClass__Draw_Names__Draw_Credits_Text_For_Specator
@HOOK 0x00532855 _RadarClass__Draw_Names__Draw_Credits_Count_For_Specator
@HOOK 0x00567048 _TechnoClass_Visual_Character_Spectator_Stuff

_TechnoClass_Visual_Character_Spectator_Stuff:
    cmp  cl, 5
    jnz  .Ret

    mov  DWORD eax, [0x00669958] ; PlayerPtr
    cmp  DWORD [eax+EXT_IsSpectator], 0
    jz   .Ret

    test BYTE [eax+0x43], 1
    jz   .Ret

    mov  cl, 3

.Ret:
    movsx eax, cl
    lea  esp, [ebp-0Ch]
    jmp  0x0056704E

_RadarClass__Draw_Names__Draw_Credits_Count_For_Specator:
    push eax
    mov  DWORD eax, [0x00669958] ; PlayerPtr
    cmp  DWORD [eax+EXT_IsSpectator], 1
    pop  eax
    jz   .Draw_Credits_Count

    add  eax, edi

.Ret:
    cmp  cl, 14h
    jmp  0x0053285A

.Draw_Credits_Count:
    mov  eax, ebx
    call 0x004D5E00 ; long const HouseClass::Available_Money(void)const  proc near
    jmp  .Ret


_RadarClass__Draw_Names__Draw_Credits_Text_For_Specator:
;    push    eax

    mov  DWORD eax, [0x00669958] ; PlayerPtr

    cmp  DWORD [eax+EXT_IsSpectator], 1
    jz   .Draw_Credits_Text

    push 12Ah
.Ret:
;    pop        eax
    jmp  0x005326A7

.Draw_Credits_Text:
    push 0xDF
    jmp  .Ret

_BuildingClass__Read_INI_Skip_Dead_Houses:
    call 0x004CD0E4 ; HouseTypeClass::From_Name(char *)
    mov  bl, al
    mov  edx, 0x005E8F5D ; ","
    mov  bh, al
    cmp  al, 0FFh
    jz   0x0045EF2E ; Code is different for buildings than for other stuff like infantry

    Save_Registers

    call 0x004D2CB0    ; HouseClass * HouseClass::As_Pointer(HousesType)
    test BYTE [eax+0x43], 1
    jnz  .Next_Iteration

    Restore_Registers
    jmp  0x0045EF2E

.Next_Iteration:
    Restore_Registers
    jmp  0x0045EED8

_InfantryClass__Read_INI_Skip_Dead_Houses:
    call 0x004CD0E4 ; HouseTypeClass::From_Name(char *)
    mov  bh, al
    cmp  al, 0FFh
    jz   0x004F0913

    Save_Registers

    call 0x004D2CB0    ; HouseClass * HouseClass::As_Pointer(HousesType)
    test BYTE [eax+0x43], 1
    jnz  .Next_Iteration

    Restore_Registers
    jmp  0x004F0966
.Next_Iteration:
    Restore_Registers
    jmp  0x004F0913


_VesselClass__Read_INI_Skip_Dead_Houses:
    call 0x004CD0E4 ; HouseTypeClass::From_Name(char *)
    mov  bh, al
    cmp  al, 0FFh
    jz   0x0058CA8B

    Save_Registers

    call 0x004D2CB0    ; HouseClass * HouseClass::As_Pointer(HousesType)
    test BYTE [eax+0x43], 1
    jnz  .Next_Iteration

    Restore_Registers
    jmp  0x0058CADE

.Next_Iteration:
    Restore_Registers
    jmp  0x0058CA8B

_UnitClass__Read_INI_Skip_Dead_Houses:
    call 0x004CD0E4 ; HouseTypeClass::From_Name(char *)
    mov  bh, al
    cmp  al, 0FFh
    jz   0x0058110B
    Save_Registers

    call 0x004D2CB0    ; HouseClass * HouseClass::As_Pointer(HousesType)
    test BYTE [eax+0x43], 1
    jnz  .Next_Iteration

    Restore_Registers
    jmp  0x0058115E

.Next_Iteration:
    Restore_Registers
    jmp  0x0058110B

_HouseClass__Init_Data_Spectator_Stuff:
    Save_Registers
    mov  BYTE [eax+178Fh], dl

    cmp  BYTE [spawner_is_active], 0
    jz   .Ret

    mov  ebx, eax
    call 0x004D2C48 ;  const HouseClass::operator HousesType(void)
    cmp  BYTE [SpectatorsArray+eax], 0
    jz   .Ret

    mov  eax, ebx
    or   BYTE [eax+0x43], 1 ; Make house dead
    mov  DWORD [eax+EXT_IsSpectator], 1
;    mov     eax, 0x00668250
;    mov     edx, 1
;    call    0x0052D790
;    mov     eax, 0x00668250
;    mov     edx, 3
;    call    0x0052D790

.Ret:
    Restore_Registers
    jmp  0x004D8CBA

_Create_Units_Skip_Dead_Houses:

    cmp  BYTE [spawner_is_active], 0
    jz   .Ret

    test BYTE [eax+0x43], 1
    jnz  .Spectator

.Ret:
    cmp  DWORD [ebp-0x8C], 0
    jmp  0x0053E502

.Spectator:
    jmp  0x0053E4D6

_Assign_Houses_Set_Up_Player_Pointer:
    mov  DWORD [0x00669958], edi

    cmp  BYTE [spawner_is_active], 0
    jz   .Ret
    test BYTE [eax+0x43], 1
    jz   .Ret

    mov  DWORD [0x0065D7F0], 1
    mov  DWORD [0x0067F315], 1

.Ret:
    jmp  0x0053DFDD
