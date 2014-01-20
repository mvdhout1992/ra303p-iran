@HOOK 0x004D4EEF _HouseClass__AI_Radar1
@HOOK 0x004D4ED3 _HouseClass__AI_Radar2
@HOOK 0x004D4EFD _HouseClass__AI_Radar3
@HOOK 0x0052DBBD _RadarClass__Draw_It_1
@HOOK 0x0052D832 _RadarClass__Activate_Play_Radar_Sound1
@HOOK 0x0052D8D8 _RadarClass__Activate_Play_Radar_Sound2

_RadarClass__Draw_It_1:
    test ch, 40h
    jz   0x0052DC0A

    mov  eax, [0x00669958]
    test BYTE [eax+0x43], 1
    mov  eax, [ebp-0x020]
    jnz  0x0052DC0A

.Ret:
    jmp  0x0052DBC2


_HouseClass__AI_Radar3:
    cmp  BYTE [deadplayersradar], 0
    jz   .Normal_Code

    mov  eax, [ebp-0x58]
    test BYTE [eax+0x43], 1
    jz   .Normal_Code
    mov  eax, 0x00668250
    cmp  BYTE [eax+0CB0h], 0
    ; need to restore eax
    jnz  .Ret

    mov  eax, 0x00668250
    mov  edx, 1
    call 0x0052D790
    mov  eax, 0x00668250
    mov  edx, 3
    call 0x0052D790
    jmp  .Ret

.Normal_Code:
    mov  eax, 0x00668250
    call 0x0052D790

.Ret:
    jmp  0x004D4F02

_HouseClass__AI_Radar1:
    push eax
    cmp  BYTE [deadplayersradar], 0
    jz   .Normal_Code

    mov  eax, [ebp-0x58]
    test BYTE [eax+0x43], 1
    jz   .Normal_Code

    mov  edx, 1 ; this jumps over some checks, check the original instructions
    pop  eax
    jmp  0x004D4EF8

.Normal_Code:
    pop  eax
    test eax, eax
    jz   0x004D4F02
    mov  edx, 4
    jmp  0x004D4EF8


_HouseClass__AI_Radar2:
    push eax
    cmp  BYTE [deadplayersradar], 0
    jz   .Normal_Code

    mov  eax, [ebp-0x58]
    test BYTE [eax+0x43], 1
    jz   .Normal_Code

 ;   test    byte [eax+44h], 8
 ;   jz      0x004D4F02
    pop  eax
    jmp  0x004D4EDE

.Normal_Code:
    pop  eax
    and  eax, 0FFh
    jnz  0x004D4EDE
    mov  eax, [ebp-0x58]
    jmp  0x004D4ED8

_RadarClass__Activate_Play_Radar_Sound1:
    cmp  BYTE [deadplayersradar], 0
    jz   .Normal_Code

    mov  eax, [0x00669958]
    test BYTE [eax+0x43], 1
    jz   .Normal_Code

.No_Sound:
    add  esp, 4
    jmp  0x0052D837

.Normal_Code:
    mov  eax, 4Ah
    call 0x00425F24 ; Sound_Effect(VocType,fixed,int,short,HousesType)
    jmp  0x0052D837

_RadarClass__Activate_Play_Radar_Sound2:
    cmp  BYTE [deadplayersradar], 0
    jz   .Normal_Code

    mov  eax, [0x00669958]
    test BYTE [eax+0x43], 1
    jz   .Normal_Code

.No_Sound:
    add  esp, 4
    jmp  0x0052D8DD

.Normal_Code:
    mov  eax, 49h
    call 0x00425F24 ; Sound_Effect(VocType,fixed,int,short,HousesType)
    jmp  0x0052D8DD
